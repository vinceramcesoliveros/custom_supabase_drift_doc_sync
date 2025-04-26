import 'dart:async';

import 'package:custom_supabase_drift_sync/db/database.dart';
import 'package:custom_supabase_drift_sync/db/isar/sync_info_schema.dart';
import 'package:custom_sync_drift_annotations/annotations.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:isar/isar.dart';
import 'package:retry/retry.dart';
import 'package:rxdart/rxdart.dart';
import 'package:supabase/supabase.dart';
import 'package:uuid/uuid.dart';

part 'sync_manager.sync.dart';

@SyncAnnotation(classes: [Task, Project, Docup])
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

class SyncManager {
  final AppDatabase db;
  final SupabaseClient supabase;
  final Isar isar;
  bool _isSyncing = false;
  bool _isLoggedIn = false;
  final String _currentInstanceId = const Uuid().v4();
  bool _extraSyncNeeded = false;
  StreamSubscription? _streamSubscription;

  SyncManager({
    required this.db,
    required this.supabase,
    required this.isar,
  }) : super() {
    _checkInitialLoginStatus();
  }

  Future<void> _checkInitialLoginStatus() async {
    // Replace this with your actual logic to check if the user is logged in
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
    })
        //.onPostgresChanges(
        //    event: PostgresChangeEvent.all,
        //    schema: 'public',
        //    table: 'task',
        //    filter: PostgresChangeFilter(
        //      type: PostgresChangeFilterType.neq,
        //      column: 'instance_id',
        //      value: _currentInstanceId,
        //    ),
        //    callback: (payload) {
        //      queueSyncDebounce();
        //    })
        //.onPostgresChanges(
        //    event: PostgresChangeEvent.all,
        //    schema: 'public',
        //    table: 'project',
        //    filter: PostgresChangeFilter(
        //      type: PostgresChangeFilterType.neq,
        //      column: 'instance_id',
        //      value: _currentInstanceId,
        //    ),
        //    callback: (payload) {
        //      queueSyncDebounce();
        //    })
        .subscribe();
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
    EasyDebounce.debounce('sync', const Duration(milliseconds: 500), () {
      queueSync();
    });
  }

  Future<void> _synchronizeBase() async {
    final lastPulledAt = _getLastPulledAt();
    final now = DateTime.now();

    // Pull changes from the server
    final pullResponse = await retry(
      () => supabase.rpc('pull_changes', params: {
        'collections': const SyncClass().syncedTables(),
        'last_pulled_at':
            (lastPulledAt ?? DateTime(2000)).toUtc().toIso8601String(),
      }),
      retryIf: (e) => e is TimeoutException || e is PostgrestException,
    );

    final changes = pullResponse['changes'] as Map<String, dynamic>;
    final timestamp = pullResponse['timestamp'] as int;

    // Apply changes to the local database
    await db.transaction(() async {
      await const SyncClass().sync(changes, db);
    });

    // Push local changes to the server
    final localChanges = await const SyncClass()
        .getChanges(lastPulledAt ?? DateTime(2000), db, _currentInstanceId);
    final isLocalChangesEmpty = localChanges.values.every((element) {
      return (element as Map<String, dynamic>)
          .values
          .every((innerElement) => innerElement.isEmpty);
    });
    if (!isLocalChangesEmpty) {
      final res = await supabase.rpc('push_changes', params: {
        '_changes': localChanges,
        'last_pulled_at': lastPulledAt?.toIso8601String(),
      }).timeout(const Duration(seconds: 10));
      _setLastPulledAt(DateTime.parse(res));
    } else {
      _setLastPulledAt(now.subtract(const Duration(minutes: 2)));
    }

    //TODO: Delete synced deletes from local db
  }

  void signIn() {
    _isLoggedIn = true;
    _startListening();
  }

  void signOut() {
    _isLoggedIn = false;
    _stopListening();
  }

  void _stopListening() {
    _streamSubscription?.cancel();
    _streamSubscription = null;
  }

  void queueSync() {
    if (_isSyncing) {
      _extraSyncNeeded = true;
      return;
    }

    _isSyncing = true;
    _synchronize().then((_) {
      _isSyncing = false;
      if (_extraSyncNeeded) {
        _extraSyncNeeded = false;
        queueSync(); // Trigger the extra sync
      }
    }).catchError((error) {
      _isSyncing = false;
      print('Sync failed: $error');
    });
  }

  DateTime? _getLastPulledAt() {
    final syncInfo = isar.syncInfos.get(1);
    return syncInfo?.lastPulledAt;
  }

  void _setLastPulledAt(DateTime timestamp) async {
    isar.write((isar) {
      isar.syncInfos.put(SyncInfo(id: 1, lastPulledAt: timestamp));
    });
  }
}
