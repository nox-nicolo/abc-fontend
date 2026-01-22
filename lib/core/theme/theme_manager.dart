import 'package:africa_beuty/core/theme/dark_theme.dart';
import 'package:africa_beuty/core/theme/light_theme.dart';
import 'package:flutter/material.dart';

/// Theme manager to handle theme switching and provide theme data
class ThemeManager {
  static ThemeData get lightTheme => LightTheme.theme;
  static ThemeData get darkTheme => DarkTheme.theme;

  /// Get theme based on brightness
  static ThemeData getTheme(Brightness brightness) {
    return brightness == Brightness.light ? lightTheme : darkTheme;
  }

  /// Check if current theme is dark
  static bool isDarkTheme(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  /// Get current theme colors
  static ColorScheme getColorScheme(BuildContext context) {
    return Theme.of(context).colorScheme;
  }

  /// Get current text theme
  static TextTheme getTextTheme(BuildContext context) {
    return Theme.of(context).textTheme;
  }
}
