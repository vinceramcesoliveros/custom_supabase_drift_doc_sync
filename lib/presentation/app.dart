import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:custom_supabase_drift_sync/presentation/module/module.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class App extends ConsumerStatefulWidget {
  const App({super.key});

  @override
  ConsumerState<App> createState() => _AppState();
}

class _AppState extends ConsumerState<App> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // Initialize providers
    ref.read(authStateProvider);
    ref.read(syncMangerPProvider);
    //ref.read(supabaseConnectorPProvider);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    //TODO: Needs testing
    if (state == AppLifecycleState.resumed) {
      ref.read(syncMangerPProvider).queueSync();
    }
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(appRouterProvider);

    return AdaptiveTheme(
        light: ThemeData.light(useMaterial3: true),
        dark: ThemeData.dark(useMaterial3: true),
        initial: AdaptiveThemeMode.system,
        builder: (theme, darkTheme) {
          return MaterialApp.router(
            title: 'Custom Sync Flutter Demo',
            theme: theme,
            darkTheme: darkTheme,
            routerConfig: router.config(),
            debugShowCheckedModeBanner: false,
          );
        });
  }
}
