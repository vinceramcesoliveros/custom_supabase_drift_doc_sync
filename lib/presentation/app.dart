import 'package:custom_supabase_drift_sync/presentation/module/module.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class App extends HookConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    useEffect(() {
      ref.read(authStateProvider);
      ref.read(syncMangerPProvider);
      //ref.read(supabaseConnectorPProvider);
      return null;
    }, []);
    return MaterialApp.router(
      title: 'Custom Sync Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routerConfig: router.config(),
    );
  }
}
