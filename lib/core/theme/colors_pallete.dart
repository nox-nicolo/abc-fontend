// import 'package:flutter/material.dart';

// class ColorPalette {
//   // Light Mode Colors
//   static const Color lightPink = Color(0xFFFCE4EC); // Lightest pink
//   static const Color pastelPink = Color.fromARGB(255, 187, 158, 27); // Pastel pink
//   static const Color hotPink = Color(0xFFFF4081); // Hot pink
//   static const Color deepPink = Color(0xFFC51162); // Deep pink
//   static const Color lightPurple = Color(0xFFE1BEE7); // Light purple accent
//   static const Color lightGrey = Color(0xFFEEEEEE);
//   static const Color darkGrey = Color(0xFF424242);

//   // Dark Mode Colors (designed to complement the light colors)
//   static const Color darkPink = Color(0xFF880E4F); // Darker shade of deep pink
//   static const Color darkPurple = Color(0xFF4A148C); // Darker shade of purple
//   static const Color darkBackground = Color(0xFF121212); // Dark background
//   static const Color darkSurface = Color(0xFF1E1E1E); // Dark surface
//   static const Color lightText = Color(0xFFFFFFFF); // Light text for dark backgrounds
//   static const Color darkText = Color(0xFFE0E0E0); // Darker text for dark backgrounds

//   // ColorScheme for Light Theme
//   static ColorScheme lightColorScheme = ColorScheme(
//     brightness: Brightness.light,
//     primary: pastelPink,
//     onPrimary: lightText,
//     secondary: lightPurple,
//     onSecondary: darkText,
//     surface: Colors.white,
//     onSurface: darkGrey,
//     error: Colors.red,
//     onError: lightText,
//   );

//   // ColorScheme for Dark Theme
//   static ColorScheme darkColorScheme = ColorScheme(
//     brightness: Brightness.dark,
//     primary: hotPink,
//     onPrimary: lightText,
//     secondary: darkPurple,
//     onSecondary: lightText,
//     surface: darkSurface,
//     onSurface: lightText,
//     error: Colors.redAccent,
//     onError: lightText,
//   );
// }



import 'package:flutter/material.dart';

/// Sophisticated color palette for women and girls
/// Elegant, modern aesthetics avoiding cliché pink overuse
class AppColors {
  // Light Theme Colors - Bright, soft, and welcoming
  static const Color lightPrimary = Color(0xFFE8B4CB); // Sophisticated Blush
  static const Color lightPrimaryVariant = Color(0xFFD4A5C2); // Deeper Blush
  static const Color lightSecondary = Color(0xFFB8E6D3); // Soft Mint
  static const Color lightSecondaryVariant = Color(0xFF9DDCC0); // Deeper Mint
  static const Color lightTertiary = Color(0xFFFFD4B3); // Warm Peach
  static const Color lightAccent = Color(0xFF87CEEB); // Sky Blue Accent
  static const Color lightAccentGold = Color(0xFFF5DEB3); // Champagne
  static const Color lightBackground = Color(0xFFFAFAFA); // Soft White
  static const Color lightSurface = Color(0xFFFFFFFF); // Pure White
  static const Color lightSurfaceVariant = Color(0xFFF8F8F8); // Light Surface
  static const Color lightOnPrimary = Color(0xFF2D2D2D); // Dark Text on Primary
  static const Color lightOnSecondary = Color(0xFF2D2D2D); // Dark Text on Secondary
  static const Color lightOnBackground = Color(0xFF1C1C1C); // Primary Text
  static const Color lightOnSurface = Color(0xFF1C1C1C); // Surface Text
  static const Color lightOnSurfaceVariant = Color(0xFF5A5A5A); // Secondary Text
  static const Color lightOutline = Color(0xFFE0E0E0); // Borders

  // Dark Theme Colors - Sleek, premium with warm glowing accents
  static const Color darkPrimary = Color(0xFF9C7FB8); // Elegant Lavender
  static const Color darkPrimaryVariant = Color(0xFF8A6FA6); // Deeper Lavender
  static const Color darkSecondary = Color(0xFF6BCAA3); // Vibrant Aqua
  static const Color darkSecondaryVariant = Color(0xFF5BB891); // Deeper Aqua
  static const Color darkTertiary = Color(0xFFFFB085); // Warm Coral
  static const Color darkAccent = Color(0xFF4FC3F7); // Bright Cyan
  static const Color darkAccentGold = Color(0xFFDAA520); // Rich Gold
  static const Color darkBackground = Color(0xFF121212); // Deep Charcoal
  static const Color darkSurface = Color(0xFF1E1E1E); // Surface Charcoal
  static const Color darkSurfaceVariant = Color(0xFF2A2A2A); // Elevated Surface
  static const Color darkOnPrimary = Color(0xFFFFFFFF); // White Text on Primary
  static const Color darkOnSecondary = Color(0xFF1C1C1C); // Dark Text on Secondary
  static const Color darkOnBackground = Color(0xFFE8E8E8); // Primary Text
  static const Color darkOnSurface = Color(0xFFE8E8E8); // Surface Text
  static const Color darkOnSurfaceVariant = Color(0xFFB8B8B8); // Secondary Text
  static const Color darkOutline = Color(0xFF404040); // Borders

  // Semantic Colors
  static const Color errorLight = Color(0xFFE57373);
  static const Color errorDark = Color(0xFFEF5350);
  static const Color successLight = Color(0xFF81C784);
  static const Color successDark = Color(0xFF66BB6A);
  static const Color warningLight = Color(0xFFFFB74D);
  static const Color warningDark = Color(0xFFFF9800);
  static const Color infoLight = Color(0xFF64B5F6);
  static const Color infoDark = Color(0xFF42A5F5);

  // Special Effect Colors
  static const Color shimmerLight = Color(0xFFF0F0F0);
  static const Color shimmerDark = Color(0xFF2A2A2A);
  static const Color shadowLight = Color(0x1A000000);
  static const Color shadowDark = Color(0x3A000000);
}
