// import 'package:africa_beuty/core/theme/colors_pallete.dart';
// import 'package:africa_beuty/core/theme/typography.dart';
// import 'package:africa_beuty/core/theme/widget_theme.dart';
// import 'package:flutter/material.dart';

// ThemeData lightTheme = ThemeData(
//   colorScheme: ColorPalette.lightColorScheme,
//   textTheme: AppTypography.lightTextTheme,
//   appBarTheme: WidgetThemes.appBarThemeLight,
//   elevatedButtonTheme: WidgetThemes.elevatedButtonThemeLight,
//   outlinedButtonTheme: WidgetThemes.outlinedButtonThemeLight,
//   textButtonTheme: WidgetThemes.textButtonThemeLight,
//   // cardTheme: WidgetThemes.cardThemeLight,
//   bottomAppBarTheme: WidgetThemes.bottomAppBarThemeLight,
//   bottomNavigationBarTheme: WidgetThemes.bottomNavigationBarThemeLight,
//   // dialogTheme: WidgetThemes.dialogThemeLight,
//   inputDecorationTheme: WidgetThemes.inputDecorationThemeLight, 
//   brightness: Brightness.light,
//   visualDensity: VisualDensity.adaptivePlatformDensity,
//   materialTapTargetSize: MaterialTapTargetSize.padded,
// );


import 'package:africa_beuty/core/theme/colors_pallete.dart';
import 'package:africa_beuty/core/theme/typography.dart';
import 'package:flutter/material.dart';

/// Light theme configuration for the app
/// Features bright, soft, and welcoming colors with sophisticated aesthetics
class LightTheme {
  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      
      // Color scheme using sophisticated palette
      colorScheme: const ColorScheme.light(
        primary: AppColors.lightPrimary,
        onPrimary: AppColors.lightOnPrimary,
        primaryContainer: AppColors.lightPrimaryVariant,
        onPrimaryContainer: AppColors.lightOnPrimary,
        secondary: AppColors.lightSecondary,
        onSecondary: AppColors.lightOnSecondary,
        secondaryContainer: AppColors.lightSecondaryVariant,
        onSecondaryContainer: AppColors.lightOnSecondary,
        tertiary: AppColors.lightTertiary,
        onTertiary: AppColors.lightOnPrimary,
        tertiaryContainer: AppColors.lightAccentGold,
        onTertiaryContainer: AppColors.lightOnPrimary,
        surface: AppColors.lightSurface,
        onSurface: AppColors.lightOnSurface,
        surfaceVariant: AppColors.lightSurfaceVariant,
        onSurfaceVariant: AppColors.lightOnSurfaceVariant,
        background: AppColors.lightBackground,
        onBackground: AppColors.lightOnBackground,
        error: AppColors.errorLight,
        onError: Colors.white,
        outline: AppColors.lightOutline,
        outlineVariant: AppColors.lightOutline,
        shadow: AppColors.shadowLight,
        scrim: Colors.black54,
        inverseSurface: AppColors.darkSurface,
        onInverseSurface: AppColors.darkOnSurface,
        inversePrimary: AppColors.darkPrimary,
      ),

      // Typography
      textTheme: AppTypography.lightTextTheme,

      // App bar theme
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.lightSurface,
        foregroundColor: AppColors.lightOnSurface,
        surfaceTintColor: AppColors.lightPrimary,
        elevation: 0,
        scrolledUnderElevation: 1,
        centerTitle: true,
        titleTextStyle: AppTypography.headlineSmall.copyWith(
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: const IconThemeData(
          color: AppColors.lightOnSurface,
          size: 24,
        ),
      ),

      // Card theme
      cardTheme: CardThemeData(
        color: Colors.white,
        surfaceTintColor: AppColors.lightPrimary,
        elevation: 2,
        shadowColor: AppColors.shadowLight,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.all(8),
      ),

      // Elevated button theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.lightPrimary,
          foregroundColor: AppColors.lightOnPrimary,
          surfaceTintColor: AppColors.lightPrimary,
          elevation: 2,
          shadowColor: AppColors.shadowLight,
          textStyle: const TextStyle(fontSize: 16),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),

      // Filled button theme
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.lightSecondary,
          foregroundColor: AppColors.lightOnSecondary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        ),
      ),

      // Text button theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.black,
          side: const BorderSide(color: AppColors.darkSurface, width: 0.0),
          textStyle: const TextStyle(fontSize: 14),
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),

      // Outlined button theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.lightPrimary,
          side: const BorderSide(color: AppColors.lightPrimary, width: 1.5),
          textStyle: const TextStyle(fontSize: 16),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),

      // Input decoration theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.lightSurfaceVariant,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.lightPrimary),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.lightOutline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.lightPrimary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        labelStyle: AppTypography.labelMedium,
        hintStyle: AppTypography.bodyMedium.copyWith(color: Colors.grey[600]),
        floatingLabelStyle: AppTypography.labelMedium.copyWith(color: AppColors.lightPrimary),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      ),

      // Bottom app bar theme
      bottomAppBarTheme: const BottomAppBarTheme(
        color: Colors.white,
        elevation: 4,
      ),

      // Bottom navigation bar theme
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: AppColors.lightPrimary,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        selectedLabelStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),

      // Navigation bar theme (Material 3)
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.lightSurface,
        surfaceTintColor: AppColors.lightPrimary,
        indicatorColor: AppColors.lightPrimary.withOpacity(0.2),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const TextStyle(
              color: AppColors.lightPrimary,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            );
          }
          return const TextStyle(
            color: AppColors.lightOnSurfaceVariant,
            fontSize: 12,
            fontWeight: FontWeight.w400,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(
              color: AppColors.lightPrimary,
              size: 24,
            );
          }
          return const IconThemeData(
            color: AppColors.lightOnSurfaceVariant,
            size: 24,
          );
        }),
      ),

      // Dialog theme
      dialogTheme: const DialogThemeData(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),

      // Floating action button theme
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.lightTertiary,
        foregroundColor: AppColors.lightOnPrimary,
        elevation: 6,
        shape: CircleBorder(),
      ),

      // Chip theme
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.lightSurfaceVariant,
        selectedColor: AppColors.lightPrimary.withOpacity(0.2),
        labelStyle: const TextStyle(
          color: AppColors.lightOnSurface,
          fontSize: 14,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),

      // Divider theme
      dividerTheme: const DividerThemeData(
        color: AppColors.lightOutline,
        thickness: 1,
        space: 16,
      ),

      // Switch theme
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.lightPrimary;
          }
          return AppColors.lightOnSurfaceVariant;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.lightPrimary.withOpacity(0.5);
          }
          return AppColors.lightOutline;
        }),
      ),

      // Additional properties for compatibility
      visualDensity: VisualDensity.adaptivePlatformDensity,
      materialTapTargetSize: MaterialTapTargetSize.padded,
    );
  }
}