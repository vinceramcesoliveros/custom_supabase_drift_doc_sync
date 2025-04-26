import 'package:custom_supabase_drift_sync/presentation/dialogs/add_team_dialog/module.dart';
import 'package:custom_supabase_drift_sync/presentation/module/module.dart';
import 'package:flash/flash_helper.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AddTeamDialog extends HookConsumerWidget {
  const AddTeamDialog({super.key});

  Future<void> _handleSubmit(BuildContext context, WidgetRef ref) async {
    final addTeamNot = ref.read(addTeamPProvider.notifier);
    final res = await addTeamNot.createTeam();

    res.match(
      () => {context.showErrorBar(content: const Text('Error creating team'))},
      (id) {
        context.showSuccessBar(content: const Text('Team created'));
        ref.read(appRouterProvider).maybePop();
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final addTeamNot = ref.watch(addTeamPProvider.notifier);
    return AlertDialog(
      title: const Text('Add a new team'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            decoration: const InputDecoration(hintText: 'Team name'),
            onChanged: addTeamNot.setName,
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
