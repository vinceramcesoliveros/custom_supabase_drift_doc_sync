import 'package:custom_supabase_drift_sync/core/constants.dart';
import 'package:custom_supabase_drift_sync/presentation/dialogs/add_task_dialog/module.dart';
import 'package:custom_supabase_drift_sync/presentation/module/module.dart';
import 'package:custom_supabase_drift_sync/presentation/module/projects_providers.dart';
import 'package:flash/flash_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AddTaskDialog extends HookConsumerWidget {
  const AddTaskDialog({super.key, required this.projectId});

  final String projectId;

  Future<void> _handleSubmit(BuildContext context, WidgetRef ref) async {
    final addTaskNot = ref.read(addTaskPProvider.notifier);
    final res = await addTaskNot.createTask();

    res.match(
      () => {context.showErrorBar(content: const Text('Error creating task'))},
      (id) {
        context.showSuccessBar(content: const Text('Task created'));
        ref.read(appRouterProvider).maybePop();
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final addTaskNot = ref.watch(addTaskPProvider.notifier);

    useEffect(() {
      Future.microtask(() {
        addTaskNot.setProjectId(projectId);
      });
      return null;
    }, []);

    return AlertDialog(
      title: const Text('Add a new task'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Consumer(
            builder: (context, ref, child) {
              final projectName = ref.watch(projectNameProvider(projectId));
              return projectName.when(
                data: (projectName) => ListTile(
                  title: Text(projectName ?? 'No name'),
                ),
                loading: () => const ListTile(title: Text('Loading...')),
                error: (error, stack) => ListTile(
                  title: Text(error.toString()),
                ),
              );
            },
          ),
          const Gap(K.spacing16),
          TextField(
            decoration: const InputDecoration(hintText: 'Task name'),
            onChanged: addTaskNot.setName,
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
