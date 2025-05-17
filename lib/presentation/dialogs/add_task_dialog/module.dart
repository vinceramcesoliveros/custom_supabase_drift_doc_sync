import 'dart:convert';

import 'package:appflowy_editor_sync_plugin/appflowy_editor_sync_utility_functions.dart';
import 'package:custom_supabase_drift_sync/domain/dialogs/add_task_state.dart';
import 'package:custom_supabase_drift_sync/presentation/module/module.dart';
import 'package:custom_supabase_drift_sync/presentation/module/projects_providers.dart';
import 'package:drift/drift.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

import '../../../db/database.dart';

part 'module.g.dart';

@riverpod
class AddTaskP extends _$AddTaskP {
  @override
  AddTaskState build() {
    return const AddTaskState();
  }

  void setName(String name) {
    state = state.copyWith(name: name);
  }

  void setProjectId(String projectId) {
    state = state.copyWith(projectId: Option.fromNullable(projectId));
  }

  Future<Option<int>> createTask() async {
    if (!state.isValid) {
      return const None();
    }
    final appdb = ref.read(appDatabaseProvider);
    return state.projectId.match(
      () => const None(),
      (projectId) async {
        final project = await ref.read(projectPProvider(projectId).future);
        final taskId = const Uuid().v4();
        final task = TaskCompanion.insert(
          id: Value(taskId),
          name: state.name,
          projectId: projectId,
          createdAt: DateTime.now().toUtc(),
          updatedAt: DateTime.now().toUtc(),
          userId: project.userId,
        );

        // Init task document
        final docInitUpdates =
            await AppflowyEditorSyncUtilityFunctions.initDocument();
        final mergedUpdates =
            await AppflowyEditorSyncUtilityFunctions.mergeUpdates(
          docInitUpdates,
        );

        final docUpdate = DocupCompanion.insert(
          taskId: taskId,
          dataB64: base64Encode(mergedUpdates),
          createdAt: DateTime.now().toUtc(),
          updatedAt: DateTime.now().toUtc(),
          userId: project.userId,
        );

        final id = await appdb.transaction(
          () async {
            final taskId = await appdb.into(appdb.task).insert(task);
            await appdb.into(appdb.docup).insert(docUpdate);
            return taskId;
          },
        );
        return Option.fromNullable(id);
      },
    );
  }
}
