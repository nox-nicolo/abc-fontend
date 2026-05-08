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

class LightTheme {
  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,

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
        surfaceContainerHighest: AppColors.lightSurfaceVariant,
        onSurfaceVariant: AppColors.lightOnSurfaceVariant,
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

      textTheme: AppTypography.lightTextTheme,
      scaffoldBackgroundColor: AppColors.lightBackground,
      canvasColor: AppColors.lightBackground,
      disabledColor: AppColors.lightOnSurfaceVariant.withValues(alpha: 0.38),
      hintColor: AppColors.lightOnSurfaceVariant,

      iconTheme: const IconThemeData(color: AppColors.lightOnSurface, size: 24),
      primaryIconTheme: const IconThemeData(
        color: AppColors.lightPrimary,
        size: 24,
      ),

      textSelectionTheme: TextSelectionThemeData(
        cursorColor: AppColors.lightPrimary,
        selectionColor: AppColors.lightPrimary.withValues(alpha: 0.24),
        selectionHandleColor: AppColors.lightPrimary,
      ),

      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.lightSurface,
        foregroundColor: AppColors.lightOnSurface,
        surfaceTintColor: AppColors.lightPrimary,
        elevation: 0,
        scrolledUnderElevation: 1,
        centerTitle: true,
        titleTextStyle: AppTypography.headlineSmall.copyWith(
          color: AppColors.lightOnSurface,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: const IconThemeData(
          color: AppColors.lightOnSurface,
          size: 24,
        ),
      ),

      cardTheme: CardThemeData(
        color: AppColors.lightSurface,
        surfaceTintColor: AppColors.lightPrimary,
        elevation: 2,
        shadowColor: AppColors.shadowLight,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(8),
      ),

      listTileTheme: const ListTileThemeData(
        tileColor: AppColors.lightSurface,
        iconColor: AppColors.lightOnSurfaceVariant,
        textColor: AppColors.lightOnSurface,
        selectedColor: AppColors.lightPrimary,
        selectedTileColor: AppColors.lightSurfaceVariant,
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.lightPrimary,
          foregroundColor: AppColors.lightOnPrimary,
          surfaceTintColor: AppColors.lightPrimary,
          elevation: 2,
          shadowColor: AppColors.shadowLight,
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),

      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.lightSecondary,
          foregroundColor: AppColors.lightOnSecondary,
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: AppColors.lightPrimary,
          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.lightPrimary,
          side: const BorderSide(color: AppColors.lightPrimary, width: 1.5),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.lightSurfaceVariant,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.lightPrimary),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.lightOutline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.lightPrimary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.errorLight),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.errorLight, width: 2),
        ),
        labelStyle: AppTypography.labelMedium.copyWith(
          color: AppColors.lightOnSurfaceVariant,
        ),
        hintStyle: AppTypography.bodyMedium.copyWith(
          color: AppColors.lightOnSurfaceVariant,
        ),
        floatingLabelStyle: AppTypography.labelMedium.copyWith(
          color: AppColors.lightPrimary,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
      ),

      bottomAppBarTheme: const BottomAppBarThemeData(
        color: AppColors.lightSurface,
        elevation: 4,
        shadowColor: AppColors.shadowLight,
      ),

      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.lightSurface,
        selectedItemColor: AppColors.lightPrimary,
        unselectedItemColor: AppColors.lightOnSurfaceVariant,
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

      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.lightSurface,
        surfaceTintColor: AppColors.lightPrimary,
        indicatorColor: AppColors.lightPrimary.withValues(alpha: 0.18),
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
            return const IconThemeData(color: AppColors.lightPrimary, size: 24);
          }
          return const IconThemeData(
            color: AppColors.lightOnSurfaceVariant,
            size: 24,
          );
        }),
      ),

      dialogTheme: const DialogThemeData(
        backgroundColor: AppColors.lightSurface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),

      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.lightSurface,
        surfaceTintColor: Colors.transparent,
        modalBackgroundColor: AppColors.lightSurface,
        modalBarrierColor: Colors.black54,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
      ),

      popupMenuTheme: PopupMenuThemeData(
        color: AppColors.lightSurface,
        surfaceTintColor: Colors.transparent,
        textStyle: AppTypography.bodyMedium.copyWith(
          color: AppColors.lightOnSurface,
        ),
        labelTextStyle: WidgetStateProperty.all(
          AppTypography.bodyMedium.copyWith(color: AppColors.lightOnSurface),
        ),
        iconColor: AppColors.lightOnSurfaceVariant,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),

      menuTheme: MenuThemeData(
        style: MenuStyle(
          backgroundColor: WidgetStateProperty.all(AppColors.lightSurface),
          surfaceTintColor: WidgetStateProperty.all(Colors.transparent),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ),

      tabBarTheme: TabBarThemeData(
        labelColor: AppColors.lightPrimary,
        unselectedLabelColor: AppColors.lightOnSurfaceVariant,
        indicatorColor: AppColors.lightPrimary,
        dividerColor: AppColors.lightOutline,
        labelStyle: AppTypography.labelLarge.copyWith(
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: AppTypography.labelLarge,
      ),

      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.lightPrimary,
        contentTextStyle: AppTypography.bodyMedium.copyWith(
          color: AppColors.lightOnPrimary,
          fontWeight: FontWeight.w500,
        ),
        actionTextColor: AppColors.lightOnPrimary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),

      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.lightPrimary,
        foregroundColor: AppColors.lightOnPrimary,
        elevation: 6,
        shape: CircleBorder(),
      ),

      chipTheme: ChipThemeData(
        backgroundColor: AppColors.lightSurfaceVariant,
        selectedColor: AppColors.lightPrimary.withValues(alpha: 0.18),
        labelStyle: const TextStyle(
          color: AppColors.lightOnSurface,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: AppColors.lightOutline),
        ),
      ),

      dividerTheme: const DividerThemeData(
        color: AppColors.lightOutline,
        thickness: 1,
        space: 16,
      ),

      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.lightPrimary;
          }
          return AppColors.lightOnSurfaceVariant;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.lightPrimary.withValues(alpha: 0.45);
          }
          return AppColors.lightOutline;
        }),
      ),

      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.lightPrimary;
          }
          return Colors.transparent;
        }),
        checkColor: WidgetStateProperty.all(AppColors.lightOnPrimary),
        side: const BorderSide(color: AppColors.lightOutline, width: 1.5),
      ),

      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.lightPrimary;
          }
          return AppColors.lightOnSurfaceVariant;
        }),
      ),

      sliderTheme: SliderThemeData(
        activeTrackColor: AppColors.lightPrimary,
        inactiveTrackColor: AppColors.lightOutline,
        thumbColor: AppColors.lightPrimary,
        overlayColor: AppColors.lightPrimary.withValues(alpha: 0.18),
        valueIndicatorColor: AppColors.lightPrimary,
        valueIndicatorTextStyle: const TextStyle(
          color: AppColors.lightOnPrimary,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),

      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.lightPrimary,
        linearTrackColor: AppColors.lightOutline,
        circularTrackColor: AppColors.lightOutline,
      ),

      visualDensity: VisualDensity.adaptivePlatformDensity,
      materialTapTargetSize: MaterialTapTargetSize.padded,
    );
  }
}
