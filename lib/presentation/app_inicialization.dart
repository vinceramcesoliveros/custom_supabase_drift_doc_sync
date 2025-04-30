import 'package:custom_supabase_drift_sync/presentation/module/module.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppInicialization extends ConsumerWidget {
  const AppInicialization({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(authStateProvider);
    ref.watch(syncMangerPProvider);

    return child;
  }
}
