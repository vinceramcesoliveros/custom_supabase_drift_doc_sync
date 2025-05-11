import 'dart:async';

import 'package:custom_supabase_drift_sync/core/constant_retry.dart';
import 'package:custom_supabase_drift_sync/core/error_handling.dart';
import 'package:custom_supabase_drift_sync/db/database.dart';
import 'package:custom_supabase_drift_sync/db/tab_separate_shared_preferences.dart';
import 'package:drift/drift.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/foundation.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class SyncManagerBuilder {
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

  /// Example:
  /// ```dart
  /// SyncManagerBuilder(
  /// tableQueries: [db.select(db.project), db.select(db.task)]
  /// )
  /// ```
  final List<SimpleSelectStatement<TableServer, DataClass>>? tableQueries;
  SyncManagerBuilder(
      {required this.db,
      required this.supabase,
      required this.basicSharePrefs,
      SyncBuilder? syncClass,
      this.tableQueries})
      : syncClass = syncClass ?? const SyncBuilder(),
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
    supabase
        .channel('db-changes')
        .onAllChanges(
            serverTableNames: syncClass.syncedTables,
            currentInstanceId: _currentInstanceId,
            callback: (payload) {
              queueSyncDebounce();
            })
        .subscribe((status, err) {
      debugPrint('Status: $status\n Error: $err');
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

  void _startListening() {
    queueSync();
    _listenOnLocalUpdates();
    _listenOnTheServerUpdates();
    _startListeningOnInternetChanges();
  }

  void _listenOnLocalUpdates() {
    final tables = tableQueries ??
        [
          db.select(db.task),
          db.select(db.project),
          db.select(db.docup),
        ];
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

  void queueSyncDebounce() {
    EasyDebounce.debounce('sync', const Duration(milliseconds: 100), () {
      E.t.debug('Debounce trigger sync');
      queueSync();
    });
  }

  Future<void> _synchronizeBase() async {
    final lastPulledAt = _getLastPulledAt() ?? DateTime(2000);
    final now = DateTime.now();

    // Pull changes from the server
    final pullResponse = await supabase.rpc('pull_changes', params: {
      'collections': syncClass.syncedTables,
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

  void dispose() {
    _streamSubscription?.cancel();
    _streamSubscription = null;
    _connectionSubscription?.cancel();
    _connectionSubscription = null;
  }
}

mixin TableServer on Table {
  String get serverTableName;

  BoolColumn get isRemote => boolean().withDefault(const Constant(false))();
}

class SyncBuilder<T extends TableServer> {
  final List<T> tables;
  const SyncBuilder({
    this.tables = const [],
  });

  Future<void> sync(Map<String, dynamic> changes, AppDatabase db) async {
    await Future.wait(tables.map((table) => table.sync(changes, db)));
  }

  Future<Map<String, dynamic>> getChanges(
      DateTime lastSyncedAt, AppDatabase db, String currentInstanceId) async {
    final res = await Future.wait(tables
        .map((table) => table.getChanges(lastSyncedAt, db, currentInstanceId)));
    return res.fold<Map<String, dynamic>>({}, (prev, element) {
      prev.addAll(element);
      return prev;
    });
  }

  List<String> get syncedTables =>
      tables.map((table) => table.serverTableName).toList();

  /// [tableQueries] Customize which column you can filter to query
  ///
  Stream<List<List<R>>> getUpdateStreams<D extends List<DataClass>, R>(
      List<SimpleSelectStatement<T, R>> tableQueries) {
    final stream = tableQueries.map((q) {
      return (q..where((tbl) => tbl.isRemote.equals(false))).watch();
    }).toList();
    return Rx.combineLatestList(stream);
  }
}

extension SyncTableExtension on TableServer {
  Future<void> sync(Map<String, dynamic> changes, AppDatabase db) async {
    final taskChanges = changes[serverTableName] as Map<String, dynamic>;
    final taskInstance = db.task;
    final createdOrUpdated = taskChanges['created'] + taskChanges['updated'];
    for (final record in createdOrUpdated) {
      final existingRecord = await (db.select(taskInstance)
            ..where((tbl) => tbl.id.equals(record['id'])))
          .getSingleOrNull();
      if (existingRecord == null ||
          DateTime.parse(record['updated_at'])
              .isAfter(existingRecord.updatedAt)) {
        await db.into(taskInstance).insertOnConflictUpdate(TaskData.fromJson(
            (record as Map<String, dynamic>)..addAll({'isRemote': true})));
      }
    }
  }

  Future<Map<String, Map<String, List<dynamic>>>> getChanges(
      DateTime lastSyncedAt,
      AppDatabase database,
      String currentInstanceId) async {
    final taskInstance = database.task;
    final created = await (database.select(taskInstance)
          ..where((tbl) =>
              tbl.createdAt.isBiggerOrEqualValue(lastSyncedAt) &
              tbl.isRemote.equals(false)))
        .get();
    final updated = await (database.select(taskInstance)
          ..where((tbl) =>
              tbl.updatedAt.isBiggerOrEqualValue(lastSyncedAt) &
              tbl.createdAt.isSmallerThanValue(lastSyncedAt) &
              tbl.isRemote.equals(false)))
        .get();
    final deleted = await (database.select(taskInstance)
          ..where((tbl) =>
              tbl.deletedAt.isBiggerOrEqualValue(lastSyncedAt) &
              tbl.isRemote.equals(false)))
        .get();
    return {
      serverTableName: {
        'created': created
            .map((e) => e.toJson()
              ..remove('isRemote')
              ..addAll({
                'instance_id': currentInstanceId,
              }))
            .toList(),
        'updated': updated
            .map((e) => e.toJson()
              ..remove('isRemote')
              ..addAll({
                'instance_id': currentInstanceId,
              }))
            .toList(),
        'deleted': deleted
            .map((e) => e.toJson()
              ..remove('isRemote')
              ..addAll({
                'instance_id': currentInstanceId,
              }))
            .toList(),
      }
    };
  }
}

extension RealtimeChannelExtension on RealtimeChannel {
  RealtimeChannel onTableChanges({
    required String serverTableName,
    required String currentInstanceId,
    required void Function(PostgresChangePayload) callback,
  }) {
    final splitName = serverTableName.split('.');
    final schema = splitName.first;
    final table = splitName.last;
    return onPostgresChanges(
      event: PostgresChangeEvent.all,
      filter: PostgresChangeFilter(
        type: PostgresChangeFilterType.neq,
        column: 'instance_id',
        value: currentInstanceId,
      ),
      schema: schema,
      table: table,
      callback: callback,
    );
  }

  RealtimeChannel onAllChanges({
    required List<String> serverTableNames,
    required String currentInstanceId,
    required void Function(PostgresChangePayload) callback,
  }) {
    for (final name in serverTableNames) {
      onTableChanges(
        callback: callback,
        currentInstanceId: currentInstanceId,
        serverTableName: name,
      );
    }
    return this;
  }
}
