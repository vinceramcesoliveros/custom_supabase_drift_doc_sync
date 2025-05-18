import 'package:auto_route/auto_route.dart';
import 'package:custom_supabase_drift_sync/core/navigation/router.gr.dart';
import 'package:custom_supabase_drift_sync/presentation/components/theme_button.dart';
import 'package:custom_supabase_drift_sync/presentation/module/task_providers.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../core/constants.dart';

@RoutePage()
class TaskPage extends HookConsumerWidget {
  const TaskPage({super.key, required this.taskId});

  final String taskId;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taskNot = ref.watch(taskPProvider(taskId).notifier);
    final taskNameController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Task Page"),
        actions: [
          const ThemeButton(),
          IconButton(
            icon: Icon(MdiIcons.trashCanOutline),
            onPressed: () {
              ref.read(taskPProvider(taskId).notifier).deleteTask();
              context.router.maybePop();
            },
          )
        ],
      ),
      body: Column(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: K.spacing8,
                vertical: K.spacing16,
              ),
              child: Consumer(
                builder: (context, ref, child) {
                  final taskName = ref.watch(taskNameProvider(taskId));
                  return taskName.when(
                    data: (name) {
                      if (name != taskNameController.text) {
                        taskNameController.text = name;
                      }
                      return TextFormField(
                        controller: taskNameController,
                        decoration: const InputDecoration(
                          labelText: 'Task Name',
                        ),
                        onChanged: (value) => EasyDebounce.debounce(
                          K.debName,
                          const Duration(milliseconds: 700),
                          () {
                            ref
                                .read(taskPProvider(taskId).notifier)
                                .changeName(value);
                          },
                        ),
                        onFieldSubmitted: (value) {
                          ref
                              .read(taskPProvider(taskId).notifier)
                              .changeName(value);
                        },
                      );
                    },
                    loading: () => TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Loading...',
                      ),
                    ),
                    error: (error, stack) => Text(error.toString()),
                  );
                },
              ),
            ),
          ),
          ElevatedButton(
              onPressed: () {
                context.pushRoute(DocRoute(taskId: taskId));
              },
              child: const Text("Open Editor")),
        ],
      ),
    );
  }
}
