import 'package:flutter/material.dart';

extension ContextExtension on BuildContext {
  /// Returns the [ThemeData] of the current context.
  ThemeData get theme => Theme.of(this);

  /// Returns the [TextTheme] of the current context.
  TextTheme get textTheme => Theme.of(this).textTheme;

  /// Returns the [ColorScheme] of the current context.
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  /// Returns the [Brightness] of the current context.
  Brightness get brightness => Theme.of(this).brightness;

  /// Text color. For dark theme white, for light theme black.
  Color get textColor => colorScheme.onSurface;
}
