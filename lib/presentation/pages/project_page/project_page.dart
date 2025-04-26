import 'package:animated_list_plus/animated_list_plus.dart';
import 'package:animated_list_plus/transitions.dart';
import 'package:auto_route/auto_route.dart';
import 'package:custom_supabase_drift_sync/core/navigation/router.gr.dart';
import 'package:custom_supabase_drift_sync/presentation/dialogs/add_task_dialog/add_task_dialog.dart';
import 'package:custom_supabase_drift_sync/presentation/module/module.dart';
import 'package:custom_supabase_drift_sync/presentation/module/projects_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../module/task_providers.dart';

@RoutePage()
class ProjectPage extends ConsumerWidget {
  const ProjectPage({super.key, required this.projectId});

  final String projectId;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Consumer(
          builder: (context, ref, child) {
            final projectName = ref.watch(projectNameProvider(projectId));
            return projectName.when(
              data: (name) => Text(name),
              loading: () => const Text('Loading...'),
              error: (error, stack) => Text(error.toString()),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AddTaskDialog(
              projectId: projectId,
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: Consumer(builder: (context, ref, child) {
        final taskIdsStream = ref.watch(projectTaskIdsPProvider(projectId));
        return taskIdsStream.when(
          data: (taskIds) {
            return ImplicitlyAnimatedList<String>(
              // The current items in the list.
              items: taskIds.toList(),
              // Called by the DiffUtil to decide whether two object represent the same item.
              // For example, if your items have unique ids, this method should check their id equality.
              areItemsTheSame: (a, b) => a == b,
              // Called, as needed, to build list item widgets.
              // List items are only built when they're scrolled into view.
              itemBuilder: (context, animation, item, index) {
                // Specifiy a transition to be used by the ImplicitlyAnimatedList.
                // See the Transitions section on how to import this transition.
                return Consumer(
                  builder: (context, ref, child) {
                    final task = ref.watch(taskPProvider(item));
                    return task.when(
                      data: (task) {
                        return SizeFadeTransition(
                          sizeFraction: 0.7,
                          curve: Curves.easeInOut,
                          animation: animation,
                          child: ListTile(
                            onTap: () {
                              ref
                                  .read(appRouterProvider)
                                  .push(TaskRoute(taskId: item));
                            },
                            title: Text(task.name ?? 'No name'),
                          ),
                        );
                      },
                      loading: () => const ListTile(
                        title: Text('Loading...'),
                      ),
                      error: (error, stack) => ListTile(
                        title: Text(error.toString()),
                      ),
                    );
                  },
                );
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Text(error.toString()),
        );
      }),
    );
  }
}
