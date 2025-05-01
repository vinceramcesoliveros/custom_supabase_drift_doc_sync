import 'dart:async';

import 'package:custom_supabase_drift_sync/core/error_handling.dart';
import 'package:custom_supabase_drift_sync/db/database.dart';
import 'package:custom_supabase_drift_sync/db/tab_separate_shared_preferences.dart';
import 'package:custom_sync_drift_annotations/annotations.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:retry/retry.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase/supabase.dart';
import 'package:uuid/uuid.dart';

part 'sync_manager.sync.dart';

@SyncManager(classes: [Task, Project, Docup])
class SyncClass {
  const SyncClass();

  Future<void> sync(Map<String, dynamic> changes, AppDatabase db) =>
      _$SyncClassSync(changes, db);
  Future<Map<String, dynamic>> getChanges(
          DateTime lastSyncedAt, AppDatabase db, String currentInstanceId) =>
      _$SyncClassGetChanges(lastSyncedAt, db, currentInstanceId);
  List<String> syncedTables() => _$SyncClassSyncedTables();

  Stream<List<dynamic>> getUpdateStreams(AppDatabase db) =>
      _$SyncClassCombinedStreams(db);
}

class SyncManagerS {
  final AppDatabase db;
  final SupabaseClient supabase;
  final SharedPreferences basicSharePrefs;
  late final TabSeparateSharedPreferences sharedPrefs;
  bool _isSyncing = false;
  bool _isLoggedIn = false;
  final String _currentInstanceId = const Uuid().v4();
  bool _extraSyncNeeded = false;
  StreamSubscription? _streamSubscription;
  StreamSubscription<InternetStatus>? _connectionSubscription;

  SyncManagerS({
    required this.db,
    required this.supabase,
    required this.basicSharePrefs,
  }) : super() {
    _checkInitialLoginStatus();
    sharedPrefs = TabSeparateSharedPreferences.getInstance(basicSharePrefs);
  }

  Future<void> _checkInitialLoginStatus() async {
    // Replace this with your actual logic to check if the user is logged in.
    final session = supabase.auth.currentSession;
    if (session != null) {
      signIn();
    }
  }

  Future<void> _synchronize() async {
    await retry(
      () => _synchronizeBase(),
      retryIf: (e) => e is TimeoutException || e is PostgrestException,
    );
  }

  void _listenOnTheServerUpdates() {
    supabase.channel('db-changes').onAllSyncClassChanges(_currentInstanceId,
        (payload) {
      queueSyncDebounce();
    }).subscribe();
  }

  void startListeningOnInternetChanges() {
    _connectionSubscription =
        InternetConnection().onStatusChange.listen((InternetStatus status) {
      switch (status) {
        case InternetStatus.connected:
          queueSync();
          break;
        case InternetStatus.disconnected:
          // The internet is now disconnected
          break;
      }
    });
  }

  void _startListening() {
    queueSync();
    _listenOnLocalUpdates();
    _listenOnTheServerUpdates();
  }

  void _listenOnLocalUpdates() {
    final combinedStream = const SyncClass().getUpdateStreams(db);
    _streamSubscription = combinedStream.listen((data) async {
      final localChanges = await const SyncClass().getChanges(
          _getLastPulledAt() ?? DateTime(2000), db, _currentInstanceId);
      final isLocalChangesEmpty = localChanges.values.every((element) {
        return (element as Map<String, dynamic>)
            .values
            .every((innerElement) => innerElement.isEmpty);
      });
      if (!isLocalChangesEmpty) {
        queueSyncDebounce();
      }
    });
  }

  void queueSyncDebounce() {
    EasyDebounce.debounce('sync', const Duration(milliseconds: 1000), () {
      E.t.debug('Debounce trigger sync');
      queueSync();
    });
  }

  Future<void> _synchronizeBase() async {
    final lastPulledAt = _getLastPulledAt() ?? DateTime(2000);
    final now = DateTime.now();

    // Pull changes from the server
    final pullResponse = await supabase.rpc('pull_changes', params: {
      'collections': const SyncClass().syncedTables(),
      'last_pulled_at': (lastPulledAt).toUtc().toIso8601String(),
    });

    final changes = pullResponse['changes'] as Map<String, dynamic>;

    // Apply changes to the local database
    await db.transaction(() async {
      await const SyncClass().sync(changes, db);
    });

    // Push local changes to the server
    final localChanges = await const SyncClass()
        .getChanges(lastPulledAt, db, _currentInstanceId);
    final isLocalChangesEmpty = localChanges.values.every((element) {
      return (element as Map<String, dynamic>)
          .values
          .every((innerElement) => innerElement.isEmpty);
    });
    if (!isLocalChangesEmpty) {
      try {
        final res = await supabase.rpc('push_changes', params: {
          '_changes': localChanges,
          'last_pulled_at': now.toIso8601String(),
        }).timeout(const Duration(seconds: 10));
        await _setLastPulledAt(DateTime.parse(res));
      } catch (e, st) {
        E.t.error(e, st);
        print('Push changes failed: $e');
      }
    } else {
      await _setLastPulledAt(now.subtract(const Duration(minutes: 2)));
    }

    //TODO: Delete synced deletes from local db
  }

  void signIn() {
    _isLoggedIn = true;
    _startListening();
  }

  void signOut() async {
    _isLoggedIn = false;
    _stopListening();

    // Clear db
    await db.transaction(() async {
      await db.delete(db.docup).go();
      await db.delete(db.task).go();
      await db.delete(db.project).go();
    });

    // set lastPulledAt = null
    await sharedPrefs.remove(lastPulledAtKey);
  }

  void _stopListening() {
    _streamSubscription?.cancel();
    _streamSubscription = null;
  }

  void queueSync() {
    if (_isSyncing) {
      E.t.debug('Sync already in progress');
      _extraSyncNeeded = true;
      return;
    }

    _isSyncing = true;
    E.t.debug('Sync started');
    _synchronize().then((_) {
      E.t.debug('Sync completed');
      _isSyncing = false;

      if (_extraSyncNeeded) {
        E.t.debug('Extra sync needed');
        _extraSyncNeeded = false;
        Future.delayed(const Duration(milliseconds: 800), () {
          queueSync();
        });
      }
    }).catchError((error, st) {
      _isSyncing = false;
      E.t.error(error, st);
    });
  }

  String lastPulledAtKey = 'lastPulledAt';

  /// Get lastPulledAt using SharedPreferences
  DateTime? _getLastPulledAt() {
    final savedLastPulletAt = sharedPrefs.getString(lastPulledAtKey);
    return savedLastPulletAt != null ? DateTime.parse(savedLastPulletAt) : null;
  }

  Future<void> _setLastPulledAt(DateTime timestamp) async {
    await sharedPrefs.setString(lastPulledAtKey, timestamp.toIso8601String());
  }

  void dispose() {
    _streamSubscription?.cancel();
    _streamSubscription = null;
    _connectionSubscription?.cancel();
    _connectionSubscription = null;
  }
}
