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

class DarkTheme {
  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,

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
        surfaceContainerHighest: AppColors.darkSurfaceVariant,
        onSurfaceVariant: AppColors.darkOnSurfaceVariant,
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

      textTheme: AppTypography.darkTextTheme,
      scaffoldBackgroundColor: AppColors.darkBackground,
      canvasColor: AppColors.darkBackground,
      disabledColor: AppColors.darkOnSurfaceVariant.withValues(alpha: 0.38),
      hintColor: AppColors.darkOnSurfaceVariant,

      iconTheme: const IconThemeData(color: AppColors.darkOnSurface, size: 24),
      primaryIconTheme: const IconThemeData(
        color: AppColors.darkPrimary,
        size: 24,
      ),

      textSelectionTheme: TextSelectionThemeData(
        cursorColor: AppColors.darkPrimary,
        selectionColor: AppColors.darkPrimary.withValues(alpha: 0.28),
        selectionHandleColor: AppColors.darkPrimary,
      ),

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

      cardTheme: CardThemeData(
        color: AppColors.darkSurface,
        surfaceTintColor: AppColors.darkPrimary,
        elevation: 4,
        shadowColor: AppColors.shadowDark,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(8),
      ),

      listTileTheme: const ListTileThemeData(
        tileColor: AppColors.darkSurface,
        iconColor: AppColors.darkOnSurfaceVariant,
        textColor: AppColors.darkOnSurface,
        selectedColor: AppColors.darkPrimary,
        selectedTileColor: AppColors.darkSurfaceVariant,
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.darkPrimary,
          foregroundColor: AppColors.darkOnPrimary,
          surfaceTintColor: AppColors.darkPrimary,
          elevation: 3,
          shadowColor: AppColors.shadowDark,
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),

      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.darkSecondary,
          foregroundColor: AppColors.darkOnSecondary,
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
          foregroundColor: AppColors.darkPrimary,
          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.darkPrimary,
          side: const BorderSide(color: AppColors.darkPrimary, width: 1.5),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.darkSurfaceVariant,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: AppColors.darkPrimary.withValues(alpha: 0.5),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.darkOutline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.darkPrimary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.errorDark),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.errorDark, width: 2),
        ),
        labelStyle: AppTypography.labelMedium.copyWith(
          color: AppColors.darkOnSurfaceVariant,
        ),
        hintStyle: AppTypography.bodyMedium.copyWith(
          color: AppColors.darkOnSurfaceVariant,
        ),
        floatingLabelStyle: AppTypography.labelMedium.copyWith(
          color: AppColors.darkPrimary,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
      ),

      bottomAppBarTheme: const BottomAppBarThemeData(
        color: AppColors.darkSurface,
        elevation: 4,
        shadowColor: AppColors.shadowDark,
      ),

      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.darkSurface,
        selectedItemColor: AppColors.darkPrimary,
        unselectedItemColor: AppColors.darkOnSurfaceVariant,
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

      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.darkSurface,
        surfaceTintColor: AppColors.darkPrimary,
        indicatorColor: AppColors.darkPrimary.withValues(alpha: 0.28),
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
            return const IconThemeData(color: AppColors.darkPrimary, size: 24);
          }
          return const IconThemeData(
            color: AppColors.darkOnSurfaceVariant,
            size: 24,
          );
        }),
      ),

      dialogTheme: const DialogThemeData(
        backgroundColor: AppColors.darkSurfaceVariant,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),

      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.darkSurface,
        surfaceTintColor: Colors.transparent,
        modalBackgroundColor: AppColors.darkSurface,
        modalBarrierColor: Colors.black87,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
      ),

      popupMenuTheme: PopupMenuThemeData(
        color: AppColors.darkSurfaceVariant,
        surfaceTintColor: Colors.transparent,
        textStyle: AppTypography.bodyMedium.copyWith(
          color: AppColors.darkOnSurface,
        ),
        labelTextStyle: WidgetStateProperty.all(
          AppTypography.bodyMedium.copyWith(color: AppColors.darkOnSurface),
        ),
        iconColor: AppColors.darkOnSurfaceVariant,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),

      menuTheme: MenuThemeData(
        style: MenuStyle(
          backgroundColor: WidgetStateProperty.all(
            AppColors.darkSurfaceVariant,
          ),
          surfaceTintColor: WidgetStateProperty.all(Colors.transparent),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ),

      tabBarTheme: TabBarThemeData(
        labelColor: AppColors.darkPrimary,
        unselectedLabelColor: AppColors.darkOnSurfaceVariant,
        indicatorColor: AppColors.darkPrimary,
        dividerColor: AppColors.darkOutline,
        labelStyle: AppTypography.labelLarge.copyWith(
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: AppTypography.labelLarge.copyWith(
          color: AppColors.darkOnSurfaceVariant,
        ),
      ),

      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.darkPrimary,
        contentTextStyle: AppTypography.bodyMedium.copyWith(
          color: AppColors.darkOnPrimary,
          fontWeight: FontWeight.w500,
        ),
        actionTextColor: AppColors.darkOnPrimary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),

      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.darkPrimary,
        foregroundColor: AppColors.darkOnPrimary,
        elevation: 8,
        shape: CircleBorder(),
      ),

      chipTheme: ChipThemeData(
        backgroundColor: AppColors.darkSurfaceVariant,
        selectedColor: AppColors.darkPrimary.withValues(alpha: 0.28),
        labelStyle: const TextStyle(
          color: AppColors.darkOnSurface,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: AppColors.darkOutline),
        ),
      ),

      dividerTheme: const DividerThemeData(
        color: AppColors.darkOutline,
        thickness: 1,
        space: 16,
      ),

      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.darkPrimary;
          }
          return AppColors.darkOnSurfaceVariant;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.darkPrimary.withValues(alpha: 0.45);
          }
          return AppColors.darkOutline;
        }),
      ),

      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.darkPrimary;
          }
          return Colors.transparent;
        }),
        checkColor: WidgetStateProperty.all(AppColors.darkOnPrimary),
        side: const BorderSide(color: AppColors.darkOutline, width: 1.5),
      ),

      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.darkPrimary;
          }
          return AppColors.darkOnSurfaceVariant;
        }),
      ),

      sliderTheme: SliderThemeData(
        activeTrackColor: AppColors.darkPrimary,
        inactiveTrackColor: AppColors.darkOutline,
        thumbColor: AppColors.darkPrimary,
        overlayColor: AppColors.darkPrimary.withValues(alpha: 0.18),
        valueIndicatorColor: AppColors.darkPrimary,
        valueIndicatorTextStyle: const TextStyle(
          color: AppColors.darkOnPrimary,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),

      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.darkPrimary,
        linearTrackColor: AppColors.darkOutline,
        circularTrackColor: AppColors.darkOutline,
      ),

      visualDensity: VisualDensity.adaptivePlatformDensity,
      materialTapTargetSize: MaterialTapTargetSize.padded,
    );
  }
}
