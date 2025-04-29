import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';

class ThemeButton extends StatelessWidget {
  const ThemeButton({super.key});

  @override
  Widget build(BuildContext context) {
    final mode = AdaptiveTheme.of(context);
    return IconButton(
        onPressed: () {
          AdaptiveTheme.of(context).toggleThemeMode();
        },
        icon: Icon(switch (mode.mode) {
          AdaptiveThemeMode.light => Icons.light_mode,
          AdaptiveThemeMode.dark => Icons.dark_mode,
          AdaptiveThemeMode.system => Icons.brightness_auto,
        }));
  }
}
