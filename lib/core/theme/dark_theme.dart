  // import 'package:africa_beuty/core/theme/colors_pallete.dart';
  // import 'package:africa_beuty/core/theme/typography.dart';
  // import 'package:africa_beuty/core/theme/widget_theme.dart';
  // import 'package:flutter/material.dart';

  // ThemeData darkTheme = ThemeData(
  //   colorScheme: ColorPalette.darkColorScheme,
  //   textTheme: AppTypography.darkTextTheme,
  //   appBarTheme: WidgetThemes.appBarThemeDark,
  //   elevatedButtonTheme: WidgetThemes.elevatedButtonThemeDark,
  //   outlinedButtonTheme: WidgetThemes.outlinedButtonThemeDark,
  //   textButtonTheme: WidgetThemes.textButtonThemeDark,
  //   // cardTheme: WidgetThemes.cardThemeDark,
  //   bottomAppBarTheme: WidgetThemes.bottomAppBarThemeDark,
  //   bottomNavigationBarTheme: WidgetThemes.bottomNavigationBarThemeDark,
  //   // dialogTheme: WidgetThemes.dialogThemeDark, 
  //   inputDecorationTheme: WidgetThemes.inputDecorationThemeDark, 
  //   brightness: Brightness.dark,
  //   visualDensity: VisualDensity.adaptivePlatformDensity,
  //   materialTapTargetSize: MaterialTapTargetSize.padded,
  // );


import 'package:africa_beuty/core/theme/colors_pallete.dart';
import 'package:africa_beuty/core/theme/typography.dart';
import 'package:flutter/material.dart';

/// Dark theme configuration for the app
/// Features sleek, premium design with warm glowing accents
class DarkTheme {
  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      
      // Color scheme using sophisticated palette
      colorScheme: const ColorScheme.dark(
        primary: AppColors.darkPrimary,
        onPrimary: AppColors.darkOnPrimary,
        primaryContainer: AppColors.darkPrimaryVariant,
        onPrimaryContainer: AppColors.darkOnPrimary,
        secondary: AppColors.darkSecondary,
        onSecondary: AppColors.darkOnSecondary,
        secondaryContainer: AppColors.darkSecondaryVariant,
        onSecondaryContainer: AppColors.darkOnPrimary,
        tertiary: AppColors.darkTertiary,
        onTertiary: AppColors.darkOnPrimary,
        tertiaryContainer: AppColors.darkAccentGold,
        onTertiaryContainer: AppColors.darkOnPrimary,
        surface: AppColors.darkSurface,
        onSurface: AppColors.darkOnSurface,
        surfaceVariant: AppColors.darkSurfaceVariant,
        onSurfaceVariant: AppColors.darkOnSurfaceVariant,
        background: AppColors.darkBackground,
        onBackground: AppColors.darkOnBackground,
        error: AppColors.errorDark,
        onError: Colors.white,
        outline: AppColors.darkOutline,
        outlineVariant: AppColors.darkOutline,
        shadow: AppColors.shadowDark,
        scrim: Colors.black87,
        inverseSurface: AppColors.lightSurface,
        onInverseSurface: AppColors.lightOnSurface,
        inversePrimary: AppColors.lightPrimary,
      ),

      // Typography
      textTheme: AppTypography.darkTextTheme,

      // App bar theme
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.darkSurface,
        foregroundColor: AppColors.darkOnSurface,
        surfaceTintColor: AppColors.darkPrimary,
        elevation: 0,
        scrolledUnderElevation: 1,
        centerTitle: true,
        titleTextStyle: AppTypography.headlineSmall.copyWith(
          color: AppColors.darkOnSurface,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: const IconThemeData(
          color: AppColors.darkOnSurface,
          size: 24,
        ),
      ),

      // Card theme
      cardTheme: CardThemeData(
        color: AppColors.darkSurface,
        surfaceTintColor: AppColors.darkPrimary,
        elevation: 4,
        shadowColor: AppColors.shadowDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.all(8),
      ),

      // Elevated button theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.darkPrimary,
          foregroundColor: AppColors.darkOnPrimary,
          surfaceTintColor: AppColors.darkPrimary,
          elevation: 3,
          shadowColor: AppColors.shadowDark,
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
          backgroundColor: AppColors.darkSecondary,
          foregroundColor: AppColors.darkOnSecondary,
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
          foregroundColor: AppColors.darkPrimary,
          side: const BorderSide(color: AppColors.darkPrimary, width: 0.0),
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
          foregroundColor: AppColors.darkPrimary,
          side: const BorderSide(color: AppColors.darkPrimary, width: 1.5),
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
        fillColor: AppColors.darkSurfaceVariant,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.darkPrimary.withOpacity(0.5)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.darkOutline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.darkPrimary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.redAccent),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.redAccent, width: 2),
        ),
        labelStyle: AppTypography.labelMedium.copyWith(color: AppColors.darkOnSurface),
        hintStyle: AppTypography.bodyMedium.copyWith(color: Colors.grey[400]),
        floatingLabelStyle: AppTypography.labelMedium.copyWith(color: AppColors.darkPrimary),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      ),

      // Bottom app bar theme
      bottomAppBarTheme: const BottomAppBarTheme(
        color: AppColors.darkSurface,
        elevation: 4,
      ),

      // Bottom navigation bar theme
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.darkSurface,
        selectedItemColor: AppColors.darkPrimary,
        unselectedItemColor: Colors.grey[600],
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        selectedLabelStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),

      // Navigation bar theme (Material 3)
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.darkSurface,
        surfaceTintColor: AppColors.darkPrimary,
        indicatorColor: AppColors.darkPrimary.withOpacity(0.3),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const TextStyle(
              color: AppColors.darkPrimary,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            );
          }
          return const TextStyle(
            color: AppColors.darkOnSurfaceVariant,
            fontSize: 12,
            fontWeight: FontWeight.w400,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(
              color: AppColors.darkPrimary,
              size: 24,
            );
          }
          return const IconThemeData(
            color: AppColors.darkOnSurfaceVariant,
            size: 24,
          );
        }),
      ),

      // Dialog theme
      dialogTheme: const DialogThemeData(
        backgroundColor: AppColors.darkSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),

      // Floating action button theme
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.darkTertiary,
        foregroundColor: AppColors.darkOnPrimary,
        elevation: 8,
        shape: CircleBorder(),
      ),

      // Chip theme
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.darkSurfaceVariant,
        selectedColor: AppColors.darkPrimary.withOpacity(0.3),
        labelStyle: const TextStyle(
          color: AppColors.darkOnSurface,
          fontSize: 14,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),

      // Divider theme
      dividerTheme: const DividerThemeData(
        color: AppColors.darkOutline,
        thickness: 1,
        space: 16,
      ),

      // Switch theme
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.darkPrimary;
          }
          return AppColors.darkOnSurfaceVariant;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.darkPrimary.withOpacity(0.5);
          }
          return AppColors.darkOutline;
        }),
      ),

      // Slider theme
      sliderTheme: SliderThemeData(
        activeTrackColor: AppColors.darkPrimary,
        inactiveTrackColor: AppColors.darkOutline,
        thumbColor: AppColors.darkPrimary,
        overlayColor: AppColors.darkPrimary.withOpacity(0.2),
        valueIndicatorColor: AppColors.darkPrimary,
        valueIndicatorTextStyle: const TextStyle(
          color: AppColors.darkOnPrimary,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),

      // Progress indicator theme
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.darkPrimary,
        linearTrackColor: AppColors.darkOutline,
        circularTrackColor: AppColors.darkOutline,
      ),

      // Additional properties for compatibility
      visualDensity: VisualDensity.adaptivePlatformDensity,
      materialTapTargetSize: MaterialTapTargetSize.padded,
    );
  }
}