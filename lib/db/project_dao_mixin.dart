import 'package:custom_supabase_drift_sync/db/database.dart';
import 'package:dartx/dartx.dart';
import 'package:drift/drift.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';

part 'project_dao_mixin.g.dart';

@DriftAccessor(tables: [Project])
class ProjectDao extends DatabaseAccessor<AppDatabase> with _$ProjectDaoMixin {
  ProjectDao(super.db);

  Stream<IList<String>> watchProjects() async* {
    final query = selectOnly(project)
      ..addColumns([project.id])
      ..orderBy(
        [
          OrderingTerm(expression: project.name, mode: OrderingMode.desc),
        ],
      );
    final stream = query.map((row) => row.read(project.id)).watch();
    await for (final event in stream) {
      yield event.whereNotNull().toIList();
    }
  }
}
