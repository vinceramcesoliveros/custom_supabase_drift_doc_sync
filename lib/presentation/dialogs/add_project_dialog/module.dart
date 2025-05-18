import 'package:custom_supabase_drift_sync/db/database.dart';
import 'package:custom_supabase_drift_sync/domain/dialogs/add_project_state.dart';
import 'package:custom_supabase_drift_sync/presentation/module/module.dart';
import 'package:drift/drift.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'module.g.dart';

@riverpod
class AddProjectP extends _$AddProjectP {
  @override
  AddProjectState build() {
    return const AddProjectState();
  }

  void setName(String name) {
    state = state.copyWith(name: name);
  }

  void setTeamId(String? teamId) {
    state = state.copyWith(teamId: Option.fromNullable(teamId));
  }

  Future<Option<int>> createProject() async {
    if (!state.isValid) {
      return const None();
    }
    final appdb = ref.read(appDatabaseProvider);

    final session = ref.read(sessionPProvider);

    return session.match(() => const None(), (session) async {
      final project = ProjectCompanion.insert(
        name: state.name,
        userId: session.user.id,
        updatedAt: DateTime.now().toUtc(),
        createdAt: DateTime.now().toUtc(),
        isRemote: const Value(false),
      );

      final id = await appdb.into(appdb.project).insert(project);
      return Option.fromNullable(id);
    });
  }
}
