import 'package:custom_supabase_drift_sync/db/database.dart';
import 'package:drift/drift.dart';

part 'task_dao_mixin.g.dart';

@DriftAccessor(tables: [Task])
class TaskDao extends DatabaseAccessor<AppDatabase> with _$TaskDaoMixin {
  TaskDao(super.db);

  Stream<List<TaskData>> watchTasksForProject(String projectId) {
    final query = select(task)..where((t) => t.projectId.equals(projectId));
    return query.watch();
  }

  //Stream<List<Task>> watchTasksByCompletedDate(DateTime date) {
  //  final query = select(tasks)
  //    ..where((t) => t.completedDateTime.date.equals(date));
  //  return query.watch();
  //}
}
