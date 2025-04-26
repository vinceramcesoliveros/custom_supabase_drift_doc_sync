import 'package:custom_supabase_drift_sync/core/constants.dart';
import 'package:custom_supabase_drift_sync/presentation/dialogs/add_project_dialog/module.dart';
import 'package:custom_supabase_drift_sync/presentation/module/module.dart';
import 'package:flash/flash_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fpdart/fpdart.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AddProjectDialog extends HookConsumerWidget {
  const AddProjectDialog({super.key, required this.teamId});

  final Option<String> teamId;

  Future<void> _handleSubmit(BuildContext context, WidgetRef ref) async {
    final addProjectNot = ref.read(addProjectPProvider.notifier);
    final res = await addProjectNot.createProject();

    res.match(
      () =>
          {context.showErrorBar(content: const Text('Error creating project'))},
      (id) {
        context.showSuccessBar(content: const Text('Project created'));
        ref.read(appRouterProvider).maybePop();
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final addProjectNot = ref.watch(addProjectPProvider.notifier);

    useEffect(() {
      Future.microtask(() {
        addProjectNot.setTeamId(teamId.toNullable());
      });
      return null;
    }, []);

    return AlertDialog(
      title: const Text('Add a new project'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          teamId.match(
            () => const ListTile(title: Text('Personal project')),
            (teamId) => const ListTile(
              title: Text('Team'),
              //subtitle: Consumer(
              //  builder: (context, ref, child) {
              //    final teamStream = ref.watch(teamPProvider(teamId));
              //    return teamStream.when(
              //      data: (team) => Text(team.name ?? 'No name'),
              //      error: (error, stack) => Text(error.toString()),
              //      loading: () => const Text('Loading...'),
              //    );
              //  },
              //),
            ),
          ),
          const Gap(K.spacing16),
          TextField(
            decoration: const InputDecoration(hintText: 'Project name'),
            onChanged: addProjectNot.setName,
            onSubmitted: (value) async => await _handleSubmit(context, ref),
            autofocus: true,
          ),
        ],
      ),
      actions: <Widget>[
        OutlinedButton(
          child: const Text('Cancel'),
          onPressed: () {
            ref.read(appRouterProvider).maybePop();
          },
        ),
        ElevatedButton(
          child: const Text('Create'),
          onPressed: () async => await _handleSubmit(context, ref),
        ),
      ],
    );
  }
}
