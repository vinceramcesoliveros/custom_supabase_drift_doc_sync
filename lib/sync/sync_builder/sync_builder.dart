import 'package:custom_supabase_drift_sync/db/database.dart';
import 'package:custom_supabase_drift_sync/sync/sync_builder.dart';
import 'package:custom_supabase_drift_sync/sync/sync_builder/extensions.dart';
import 'package:custom_supabase_drift_sync/sync/sync_builder/mixins.dart';
import 'package:drift/drift.dart';
import 'package:rxdart/rxdart.dart';

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
      tables.map((table) => table.serverTblName).toList();

  /// [tableQueries] Customize which column you can filter to query
  ///
  Stream<List<List<R>>> getUpdateStreams<D extends List<DataClass>, R>(
      List<SimpleSelectStatement<T, R>> tableQueries) {
    try {
      final stream = tableQueries.map((q) {
        return (q..where((tbl) => tbl.isRemote.equals(false))).watch();
      }).toList();
      return Rx.combineLatestList(stream);
    } catch (e) {
      rethrow;
    }
  }
}
