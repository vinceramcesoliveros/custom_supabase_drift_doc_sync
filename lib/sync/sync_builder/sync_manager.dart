import 'dart:async';

import 'package:custom_supabase_drift_sync/core/constant_retry.dart';
import 'package:custom_supabase_drift_sync/core/error_handling.dart';
import 'package:custom_supabase_drift_sync/db/database.dart';
import 'package:custom_supabase_drift_sync/db/tab_separate_shared_preferences.dart';
import 'package:custom_supabase_drift_sync/sync/sync_builder.dart';
import 'package:custom_supabase_drift_sync/sync/sync_interface.dart';
import 'package:drift/drift.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class SyncManagerBuilder implements SyncInterface {
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
  final SyncBuilder syncClass;
  Timer? _periodicSyncTimer;

  /// If no queries provided, it will select all tables as default query
  ///
  /// Example:
  /// ```dart
  /// SyncManagerBuilder(
  /// tableQueries: [db.select(db.project), db.select(db.task)]
  /// )
  ///
  /// ```
  final List<SimpleSelectStatement<TableServer, DataClass>>? tableQueries;
  SyncManagerBuilder(
      {required this.db,
      required this.supabase,
      required this.basicSharePrefs,
      SyncBuilder? syncClass,
      this.tableQueries})
      : syncClass = syncClass ?? const SyncBuilder(),
        assert(tableQueries?.isNotEmpty != true),
        super() {
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
    await sequenceRetry(
      () => _synchronizeBase(),
    );
  }

  void _listenOnTheServerUpdates() {
    final tables = syncClass.syncedTables;
    supabase
        .channel('db-changes')
        .onAllChanges(
            serverTableNames: tables,
            currentInstanceId: _currentInstanceId,
            callback: (payload) {
              queueSyncDebounce();
            })
        .subscribe((status, err) {
      E.t.error('Status: $status\n Error: $err', err);
    });
  }

  void _startListeningOnInternetChanges() {
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

  void _startPeriodicSync() {
    _periodicSyncTimer?.cancel();
    _periodicSyncTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      E.t.debug('Triggering periodic sync (30s interval)');
      queueSync();
    });
  }

  void _startListening() {
    try {
      queueSync();
      _listenOnLocalUpdates();
      _listenOnTheServerUpdates();
      _startListeningOnInternetChanges();
      _startPeriodicSync();
    } catch (e) {
      E.t.error('$e');
    }
  }

  List<SimpleSelectStatement<TableServer, DataClass>> _defaultQueries() {
    final list = syncClass.tables
        .map((table) {
          return db.from(table);
        })
        .where((table) => table != null)
        .cast<TableInfo<TableServer, DataClass>>()
        .map((table) {
          return db.select(table);
        })
        .toList();
    return list;
  }

  void _listenOnLocalUpdates() {
    final tables = tableQueries ?? _defaultQueries();
    final combinedStream = syncClass.getUpdateStreams(tables);
    _streamSubscription = combinedStream.listen((data) async {
      final localChanges = await syncClass.getChanges(
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

  @override
  void queueSyncDebounce() {
    EasyDebounce.debounce('sync', const Duration(milliseconds: 100), () {
      E.t.debug('Debounce trigger sync');
      queueSync();
    });
  }

  Future<void> _synchronizeBase() async {
    final lastPulledAt = _getLastPulledAt() ?? DateTime(2000);
    final now = DateTime.now();
    final tables = syncClass.syncedTables;
    // Pull changes from the server
    final pullResponse = await supabase.rpc('pull_changes', params: {
      'collections': tables,
      'last_pulled_at': (lastPulledAt).toUtc().toIso8601String(),
    });

    final changes = pullResponse['changes'] as Map<String, dynamic>;

    // Apply changes to the local database
    await db.transaction(() async {
      await syncClass.sync(changes, db);
    });

    // Push local changes to the server
    final localChanges =
        await syncClass.getChanges(lastPulledAt, db, _currentInstanceId);
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

  @override
  void signIn() {
    _isLoggedIn = true;
    _startListening();
  }

  @override
  void signOut() async {
    _isLoggedIn = false;
    _stopListening();

    // Clear db
    await db.transaction(() async {
      for (final table in syncClass.tables) {
        final t = db.from(table);
        if (t != null) {
          await db.delete(t).go();
        }
      }
    });

    // set lastPulledAt = null
    await sharedPrefs.remove(lastPulledAtKey);
  }

  void _stopListening() {
    _streamSubscription?.cancel();
    _streamSubscription = null;
  }

  @override
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
        E.t.debug('Extra sync needed, scheduling first retry in 800ms');
        _extraSyncNeeded = false;

        // First retry after 800ms
        Future.delayed(const Duration(milliseconds: 800), () {
          if (!_isSyncing) {
            E.t.debug('Performing first retry sync');
            queueSync();

            // Second retry after 4000ms if no other updates triggered a sync
            Future.delayed(const Duration(milliseconds: 4000), () {
              if (!_isSyncing && !_extraSyncNeeded) {
                E.t.debug('Performing second retry sync');
                queueSync();

                // Third retry after another 1000ms if still no updates
                Future.delayed(const Duration(milliseconds: 6000), () {
                  if (!_isSyncing && !_extraSyncNeeded) {
                    E.t.debug('Performing third retry sync');
                    queueSync();
                  } else {
                    E.t.debug(
                        'Skipping third retry, sync already in progress or queued');
                  }
                });
              } else {
                E.t.debug(
                    'Skipping second retry, sync already in progress or queued');
              }
            });
          }
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

  @override
  void dispose() {
    _streamSubscription?.cancel();
    _streamSubscription = null;
    _connectionSubscription?.cancel();
    _connectionSubscription = null;
    _periodicSyncTimer?.cancel();
    _periodicSyncTimer = null;
  }
}
