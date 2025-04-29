import 'package:adaptive_theme/adaptive_theme.dart';
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
