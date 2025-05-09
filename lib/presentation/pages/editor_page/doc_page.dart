import 'package:auto_route/auto_route.dart';
import 'package:custom_supabase_drift_sync/presentation/components/sync_button.dart';
import 'package:custom_supabase_drift_sync/presentation/components/theme_button.dart';
import 'package:custom_supabase_drift_sync/presentation/pages/editor_page/desktop_editor.dart';
import 'package:custom_supabase_drift_sync/presentation/pages/editor_page/mobile_editor.dart';
import 'package:custom_supabase_drift_sync/presentation/pages/editor_page/module.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:universal_platform/universal_platform.dart';

@RoutePage()
class DocPage extends HookConsumerWidget {
  const DocPage({required this.taskId, super.key});

  final String taskId;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Doc Page'),
        actions: const [ThemeButton(), SynchronizeButton()],
      ),
      body: Consumer(
        builder: (context, ref, child) {
          final editorState = ref.watch(docPProvider(taskId));
          return editorState.when(
            data: (editorState) {
              if (UniversalPlatform.isDesktopOrWeb) {
                return DesktopEditor(editorState: editorState);
              }
              return MobileEditor(editorState: editorState);
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Center(child: Text('Error: $error')),
          );
        },
      ),
    );
  }
}
