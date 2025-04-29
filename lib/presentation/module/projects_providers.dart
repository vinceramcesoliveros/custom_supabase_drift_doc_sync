import 'dart:async';

import 'package:custom_supabase_drift_sync/db/database.dart';
import 'package:custom_supabase_drift_sync/presentation/module/module.dart';
import 'package:dartx/dartx.dart';
import 'package:drift/drift.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'projects_providers.g.dart';

@riverpod
class ProjectsIdsP extends _$ProjectsIdsP {
  @override
  Stream<IList<String>> build() {
    final appdb = ref.watch(appDatabaseProvider);
    return appdb.projectDao.watchProjects();
  }
}

@riverpod
class ProjectP extends _$ProjectP {
  @override
  Stream<ProjectData> build(String projectId) async* {
    final appdb = ref.watch(appDatabaseProvider);

    final query = appdb.select(appdb.project)
      ..where((tbl) => tbl.id.equals(projectId));

    await for (final event in query.watchSingle()) {
      yield event;
    }
  }
}

@riverpod
FutureOr<String> projectName(ProjectNameRef ref, String projectId) async {
  return ref
      .watch(projectPProvider(projectId).selectAsync((data) => data.name));
}

@riverpod
class ProjectTaskIdsP extends _$ProjectTaskIdsP {
  @override
  Stream<IList<String>> build(String projectId) async* {
    final appdb = ref.watch(appDatabaseProvider);

    final query = appdb.selectOnly(appdb.task)
      ..addColumns([appdb.task.id, appdb.task.name])
      ..where(appdb.task.projectId.equals(projectId))
      ..orderBy([OrderingTerm.desc(appdb.task.name)]);

    await for (final event
        in query.map((row) => row.read(appdb.task.id)).watch()) {
      yield event.whereNotNull().toIList();
    }
  }
}

//@riverpod
//class TeamProjectsIdsP extends _$PersonalProjectsIdsP {
//  @override
//  Stream<IList<String>> build() async* {
//    final appdb = ref.watch(appDatabaseProvider);

//    final query = appdb.selectOnly(appdb.project)
//      ..addColumns([appdb.project.id])
//      ..join([
//        innerJoin(
//          appdb.accounts,
//          appdb.accounts.id.equalsExp(appdb.project.accountId),
//          useColumns: false,
//        ),
//      ])
//      ..where(appdb.accounts.personalAccount.equals(true));

//    await for (final event
//        in query.map((row) => row.read(appdb.project.id)).watch()) {
//      yield event.whereNotNull().toIList();
//    }
//  }
//}
