import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:custom_supabase_drift_sync/presentation/module/module.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class SynchronizeButton extends ConsumerWidget {
  const SynchronizeButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = AdaptiveTheme.of(context);
    return IconButton(
      onPressed: () {
        ref.read(syncMangerPProvider).queueSync();
      },
      icon: Icon(MdiIcons.refresh),
    );
  }
}
