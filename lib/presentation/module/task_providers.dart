import 'dart:async';

import 'package:custom_supabase_drift_sync/core/constants.dart';
import 'package:custom_supabase_drift_sync/db/database.dart';
import 'package:custom_supabase_drift_sync/presentation/module/module.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'task_providers.g.dart';

@riverpod
class TaskP extends _$TaskP {
  @override
  Stream<TaskData> build(String taskId) async* {
    final appdb = ref.watch(appDatabaseProvider);

    final query = appdb.select(appdb.task)
      ..where((tbl) => tbl.id.equals(taskId));

    await for (final event in query.watchSingle()) {
      yield event;
    }
  }

  //changeNameFunction
  void changeName(String newName) {
    final value = state.value;
    if (value == null) return;
    state = AsyncValue.data(value.copyWith(
        name: newName, isRemote: false, updatedAt: DateTime.now()));
    EasyDebounce.debounce(K.debNameTaskProvider, const Duration(seconds: 4),
        () {
      updateInDB();
    });
  }

  void updateInDB() {
    final value = state.value;
    if (value == null) return;
    final appdb = ref.read(appDatabaseProvider);
    appdb.update(appdb.task).replace(value);
  }

  //UpdateINDBFUnction
}

//taskNameProvider
@riverpod
Future<String> taskName(TaskNameRef ref, String taskId) {
  return ref.watch(taskPProvider(taskId).selectAsync((task) => task.name));
}
