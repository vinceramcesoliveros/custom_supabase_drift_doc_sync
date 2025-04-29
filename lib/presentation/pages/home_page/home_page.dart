import 'package:auto_route/auto_route.dart';
import 'package:custom_supabase_drift_sync/core/navigation/router.gr.dart';
import 'package:custom_supabase_drift_sync/presentation/components/theme_button.dart';
import 'package:custom_supabase_drift_sync/presentation/dialogs/add_project_dialog/add_project_dialog.dart';
import 'package:custom_supabase_drift_sync/presentation/module/module.dart';
import 'package:custom_supabase_drift_sync/presentation/module/projects_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

@RoutePage()
class HomePage extends ConsumerWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Home Page'),
          actions: const [
            ThemeButton(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => const AddProjectDialog(
                teamId: None(),
              ),
            );
          },
          child: const Icon(Icons.add),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ElevatedButton(
                onPressed: () {
                  ref.read(sessionPProvider.notifier).signOut();
                },
                child: const Text('Sign Out'),
              ),
              const SizedBox(height: 35),
              Expanded(child: Consumer(
                builder: (context, ref, child) {
                  final projectIds = ref.watch(projectsIdsPProvider);

                  return projectIds.when(
                      data: (projectIds) {
                        return ListView.builder(
                          itemBuilder: (context, index) {
                            final projectId = projectIds[index];
                            return Consumer(
                              builder: (context, ref, child) {
                                final project =
                                    ref.watch(projectNameProvider(projectId));

                                return project.when(
                                  data: (data) => ListTile(
                                    title: Text(data),
                                    onTap: () {
                                      context.pushRoute(
                                          ProjectRoute(projectId: projectId));
                                    },
                                  ),
                                  error: (error, stackTrace) => ListTile(
                                    title: Text(error.toString()),
                                  ),
                                  loading: () => const ListTile(
                                    title: Text('Loading...'),
                                  ),
                                );
                              },
                            );
                          },
                          itemCount: projectIds.length,
                        );
                      },
                      error: (error, stack) {
                        return ListTile(
                          title: Text(error.toString()),
                        );
                      },
                      loading: () => const CircularProgressIndicator());
                },
              ))
            ],
          ),
        ),
      ),
    );
  }
}
