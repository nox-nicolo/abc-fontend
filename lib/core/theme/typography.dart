import 'package:africa_beuty/core/theme/colors_pallete.dart';
import 'package:flutter/material.dart';

class AppTypography {
  // Font Families 
  static const String primaryFontFamily = 'Poppins'; 
  static const String secondaryFontFamily = 'Roboto'; 

  // Text Styles
  static const TextStyle headlineLarge = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.lightOnSurface, 
  );

  static const TextStyle displayLarge = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 57,
    fontWeight: FontWeight.w400,
    color: AppColors.lightOnSurface, 
  );

  static const TextStyle headlineMedium = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 28,
    fontWeight: FontWeight.w600,
    color: AppColors.lightOnSurface,
  );

  static const TextStyle headlineSmall = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w500,
    color: AppColors.lightOnSurface,
  );

  static const TextStyle titleLarge = TextStyle(
    fontFamily: secondaryFontFamily,
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: AppColors.lightOnSurface,
  );

  static const TextStyle titleMedium = TextStyle(
    fontFamily: secondaryFontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.lightOnSurface,
  );

  static const TextStyle titleSmall = TextStyle(
    fontFamily: secondaryFontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.lightOnSurface,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontFamily: secondaryFontFamily,
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.lightOnSurface,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: secondaryFontFamily,
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.lightOnSurface,
  );

  static const TextStyle bodySmall = TextStyle(
    fontFamily: secondaryFontFamily,
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.lightOnSurface,
  );

  static const TextStyle labelLarge = TextStyle(
    fontFamily: secondaryFontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.lightOnSurface,
  );

  static const TextStyle labelMedium = TextStyle(
    fontFamily: secondaryFontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.lightOnSurface,
  );

  static const TextStyle labelSmall = TextStyle(
    fontFamily: secondaryFontFamily,
    fontSize: 11,
    fontWeight: FontWeight.w500,
    color: AppColors.lightOnSurface,
  );

  // TextTheme for Light and Dark Mode
  static TextTheme lightTextTheme = TextTheme(
    displayLarge: displayLarge.copyWith(color: AppColors.lightOnSurface),
    headlineLarge: headlineLarge.copyWith(color: AppColors.lightOnSurface),
    headlineMedium: headlineMedium.copyWith(color: AppColors.lightOnSurface),
    headlineSmall: headlineSmall.copyWith(color: AppColors.lightOnSurface),
    titleLarge: titleLarge.copyWith(color: AppColors.lightOnSurface),
    titleMedium: titleMedium.copyWith(color: AppColors.lightOnSurface),
    titleSmall: titleSmall.copyWith(color: AppColors.lightOnSurface),
    bodyLarge: bodyLarge.copyWith(color: AppColors.lightOnSurface),
    bodyMedium: bodyMedium.copyWith(color: AppColors.lightOnSurface),
    bodySmall: bodySmall.copyWith(color: AppColors.lightOnSurface),
    labelLarge: labelLarge.copyWith(color: AppColors.lightOnSurface),
    labelMedium: labelMedium.copyWith(color: AppColors.lightOnSurface),
    labelSmall: labelSmall.copyWith(color: AppColors.lightOnSurface),
  );

  static TextTheme darkTextTheme = TextTheme(
    displayLarge: displayLarge.copyWith(color: AppColors.darkOnSurface),
    headlineLarge: headlineLarge.copyWith(color: AppColors.darkOnSurface),
    headlineMedium: headlineMedium.copyWith(color: AppColors.darkOnSurface),
    headlineSmall: headlineSmall.copyWith(color: AppColors.darkOnSurface),
    titleLarge: titleLarge.copyWith(color: AppColors.darkOnSurface),
    titleMedium: titleMedium.copyWith(color: AppColors.darkOnSurface),
    titleSmall: titleSmall.copyWith(color: AppColors.darkOnSurface),
    bodyLarge: bodyLarge.copyWith(color: AppColors.darkOnSurface),
    bodyMedium: bodyMedium.copyWith(color: AppColors.darkOnSurface),
    bodySmall: bodySmall.copyWith(color: AppColors.darkOnSurface),
    labelLarge: labelLarge.copyWith(color: AppColors.darkOnSurface),
    labelMedium: labelMedium.copyWith(color: AppColors.darkOnSurface),
    labelSmall: labelSmall.copyWith(color: AppColors.darkOnSurface),
  );
}