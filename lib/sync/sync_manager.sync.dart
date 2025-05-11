// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sync_manager.dart';

// **************************************************************************
// SyncGenerator
// **************************************************************************

// Sync function
Future<void> _$SyncClassSync(
    Map<String, dynamic> changes, AppDatabase db) async {
  await Future.wait([
    TaskSyncExtension.sync(changes, db),
    ProjectSyncExtension.sync(changes, db),
    DocupSyncExtension.sync(changes, db),
  ]);
}

// get changes function
Future<Map<String, dynamic>> _$SyncClassGetChanges(
    DateTime lastSyncedAt, AppDatabase db, String currentInstanceId) async {
  final res = await Future.wait([
    TaskGetChangesExtension.getChanges(lastSyncedAt, db, currentInstanceId),
    ProjectGetChangesExtension.getChanges(lastSyncedAt, db, currentInstanceId),
    DocupGetChangesExtension.getChanges(lastSyncedAt, db, currentInstanceId),
  ]);
  return res.fold<Map<String, dynamic>>({}, (prev, element) {
    prev.addAll(element);
    return prev;
  });
}

List<String> _$SyncClassSyncedTables() {
  return [
    Task.serverTableName,
    Project.serverTableName,
    Docup.serverTableName,
  ];
}

// Combined streams function
Stream<List<dynamic>> _$SyncClassCombinedStreams(AppDatabase db) {
  final taskStream =
      (db.select(db.task)..where((tbl) => tbl.isRemote.equals(false))).watch();
  final projectStream = (db.select(db.project)
        ..where((tbl) => tbl.isRemote.equals(false)))
      .watch();
  final docupStream =
      (db.select(db.docup)..where((tbl) => tbl.isRemote.equals(false))).watch();

  // Combine N streams
  return Rx.combineLatestList([
    taskStream,
    projectStream,
    docupStream,
  ]);
}

extension TaskRealtimeChannelExtension on RealtimeChannel {
  RealtimeChannel onTaskChanges(String currentInstanceId,
      void Function(PostgresChangePayload payload) callback) {
    return this.onPostgresChanges(
      event: PostgresChangeEvent.all,
      schema: Task.serverTableName.split('.')[0],
      table: Task.serverTableName.split('.')[1],
      filter: PostgresChangeFilter(
        type: PostgresChangeFilterType.neq,
        column: 'instance_id',
        value: currentInstanceId,
      ),
      callback: callback,
    );
  }
}

extension ProjectRealtimeChannelExtension on RealtimeChannel {
  RealtimeChannel onProjectChanges(String currentInstanceId,
      void Function(PostgresChangePayload payload) callback) {
    return this.onPostgresChanges(
      event: PostgresChangeEvent.all,
      schema: Project.serverTableName.split('.')[0],
      table: Project.serverTableName.split('.')[1],
      filter: PostgresChangeFilter(
        type: PostgresChangeFilterType.neq,
        column: 'instance_id',
        value: currentInstanceId,
      ),
      callback: callback,
    );
  }
}

extension DocupRealtimeChannelExtension on RealtimeChannel {
  RealtimeChannel onDocupChanges(String currentInstanceId,
      void Function(PostgresChangePayload payload) callback) {
    return this.onPostgresChanges(
      event: PostgresChangeEvent.all,
      schema: Docup.serverTableName.split('.')[0],
      table: Docup.serverTableName.split('.')[1],
      filter: PostgresChangeFilter(
        type: PostgresChangeFilterType.neq,
        column: 'instance_id',
        value: currentInstanceId,
      ),
      callback: callback,
    );
  }
}

extension CombinedSyncClassRealtimeChannelExtension on RealtimeChannel {
  RealtimeChannel onAllSyncClassChanges(String currentInstanceId,
      void Function(PostgresChangePayload payload) callback) {
    return this
        .onTaskChanges(currentInstanceId, callback)
        .onProjectChanges(currentInstanceId, callback)
        .onDocupChanges(currentInstanceId, callback);
  }
}
