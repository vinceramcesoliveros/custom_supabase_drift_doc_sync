import 'dart:convert';

import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:appflowy_editor_sync_plugin/editor_state_sync_wrapper.dart';
import 'package:appflowy_editor_sync_plugin/types/sync_db_attributes.dart';
import 'package:appflowy_editor_sync_plugin/types/update_types.dart';
import 'package:custom_supabase_drift_sync/db/database.dart';
import 'package:custom_supabase_drift_sync/presentation/module/module.dart';
import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'module.g.dart';

@riverpod
class DocP extends _$DocP {
  //Get db
  late final AppDatabase _db = ref.read(appDatabaseProvider);
  @override
  Future<EditorState> build(String taskId) async {
    final adapter = EditorStateSyncWrapper(
      syncAttributes: SyncAttributes(
        getInitialUpdates: () async {
          //Get all updates from docUpdates where docId = taskId
          // No need to initialize it because I initialize it on creating of task.
          final updatesSel = _db.select(_db.docup)
            ..where((u) => u.taskId.equals(taskId));
          final updates = await updatesSel.get();
          return updates
              .map((e) => DbUpdate(update: base64Decode(e.dataB64)))
              .toList();
        },
        getUpdatesStream: () async* {
          final updatesSel = _db.select(_db.docup)
            ..where(
              (u) => u.taskId.equals(taskId),
            )
            ..orderBy([(u) => OrderingTerm.asc(u.createdAt)]);
          final stream = updatesSel.watch();

          await for (final updates in stream) {
            if (updates.isNotEmpty) {
              yield updates.map(
                (e) {
                  return DbUpdate(
                    update: base64Decode(e.dataB64),
                  );
                },
              ).toList();
            }
          }
        }(),
        saveUpdate: (update) async {
          final userId = (await _getTaskData()).userId;

          await _db.into(_db.docup).insert(
                DocupCompanion.insert(
                  taskId: taskId,
                  dataB64: base64Encode(update),
                  createdAt: DateTime.now(),
                  userId: userId,
                  updatedAt: DateTime.now(),
                ),
              );
        },
      ),
    );
    final editorState = await adapter.initAndHandleChanges();

    ref.onDispose(adapter.dispose);

    return editorState;
  }

  //Helper private function to get taskData for taskId
  Future<TaskData> _getTaskData() async {
    final taskDataSel = _db.select(_db.task)..where((t) => t.id.equals(taskId));
    return taskDataSel.getSingle();
  }
}
