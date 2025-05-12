import 'package:custom_supabase_drift_sync/core/error_handling.dart';
import 'package:custom_supabase_drift_sync/db/database.dart';
import 'package:custom_supabase_drift_sync/sync/sync_builder.dart';
import 'package:dartx/dartx.dart';
import 'package:drift/drift.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

extension TableFinder on GeneratedDatabase {
  TableInfo<TableServer, DataClass>? from(TableServer table) {
    final schematics = allSchemaEntities
        .whereType<TableInfo<TableServer, DataClass>>()
        .firstOrNullWhere((d) {
      return d.asDslTable.serverTblName == table.serverTblName;
    });
    return schematics;
  }
}

extension DataClassExtension on DataClass {
  DateTime get rowUpdatedAt {
    final data = this.toJson()['updated_at'];
    if (data == null) {
      throw ArgumentError.value('table `updated_at` not found');
    }
    return DateTime.parse(data);
  }
}

extension SyncTableExtension on TableServer {
  Future<void> sync(Map<String, dynamic> changes, AppDatabase db) async {
    final taskChanges = changes[serverTblName] as Map<String, dynamic>;
    final table = db.from(this);
    if (table == null) {
      throw ArgumentError("Table not found");
    }
    final createdOrUpdated = taskChanges['created'] + taskChanges['updated'];

    for (final record in createdOrUpdated) {
      final existingRecord = await (db.select(table)
            ..where((tbl) => tbl.id.equals(record['id'])))
          .getSingleOrNull();
      if (existingRecord == null ||
          DateTime.parse(record['updated_at'])
              .isAfter(existingRecord.rowUpdatedAt)) {
        await db.into(table).insertOnConflictUpdate(fromJson(
            ((record as Map<String, dynamic>))..addAll({'isRemote': true})));
      }
    }
  }

  Future<Map<String, Map<String, List<dynamic>>>> getChanges(
      DateTime lastSyncedAt,
      AppDatabase database,
      String currentInstanceId) async {
    final table = database.from(this);
    if (table == null) {
      throw ArgumentError("Table not found");
    }
    final created = await (database.select(table)
          ..where((tbl) =>
              tbl.createdAt.isBiggerOrEqualValue(lastSyncedAt) &
              tbl.isRemote.equals(false)))
        .get();
    final updated = await (database.select(table)
          ..where((tbl) =>
              tbl.updatedAt.isBiggerOrEqualValue(lastSyncedAt) &
              tbl.createdAt.isSmallerThanValue(lastSyncedAt) &
              tbl.isRemote.equals(false)))
        .get();
    final deleted = await (database.select(table)
          ..where((tbl) =>
              tbl.deletedAt.isBiggerOrEqualValue(lastSyncedAt) &
              tbl.isRemote.equals(false)))
        .get();
    return {
      serverTblName: {
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
    try {
      RealtimeChannel? channel;
      for (final name in serverTableNames) {
        if (channel == null) {
          channel = onTableChanges(
            callback: callback,
            currentInstanceId: currentInstanceId,
            serverTableName: name,
          );
        } else {
          channel = channel.onTableChanges(
            callback: callback,
            currentInstanceId: currentInstanceId,
            serverTableName: name,
          );
        }
      }
      return channel!;
    } catch (e, s) {
      E.t.error("Unable to make changes on `onAllChanges`", e, s);
      return this;
    }
  }
}
