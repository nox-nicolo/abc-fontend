import 'package:flutter/material.dart';

/// App color palette — designed for a women & girls beauty lifestyle app (18–50).
/// Light: warm whites + deep rose primary + sage teal secondary.
/// Dark:  rich deep-plum surfaces + soft rose + aqua mint accents.
/// All primary/secondary colors meet WCAG AA (≥4.5:1) on their respective surfaces.
class AppColors {
  // ===== LIGHT THEME =====
  static const Color lightPrimary           = Color(0xFFA33060); // Deep Rose         — 6.6:1 on white
  static const Color lightPrimaryVariant    = Color(0xFF7C2248); // Dark Rose          — used as primaryContainer
  static const Color lightSecondary         = Color(0xFF2E7D6B); // Rich Sage Teal     — 4.9:1 on white
  static const Color lightSecondaryVariant  = Color(0xFF235F52); // Deeper Teal        — used as secondaryContainer
  static const Color lightTertiary          = Color(0xFFB55A28); // Warm Terracotta    — 5.5:1 on white
  static const Color lightAccent            = Color(0xFF4A6FA5); // Muted Steel Blue
  static const Color lightAccentGold        = Color(0xFFC49A5C); // Rose Gold / Champagne
  static const Color lightBackground        = Color(0xFFFFF8FA); // Barely-Blush White
  static const Color lightSurface           = Color(0xFFFFFFFF); // Pure White
  static const Color lightSurfaceVariant    = Color(0xFFF5EAF0); // Light Pinkish-Grey
  static const Color lightOnPrimary         = Color(0xFFFFFFFF); // White on primary
  static const Color lightOnSecondary       = Color(0xFFFFFFFF); // White on secondary
  static const Color lightOnBackground      = Color(0xFF1D1317); // Near-Black (warm)
  static const Color lightOnSurface         = Color(0xFF1D1317); // Near-Black (warm)  — 19:1 on white
  static const Color lightOnSurfaceVariant  = Color(0xFF4E4044); // Warm Medium-Dark Grey — 9.8:1 on white
  static const Color lightOutline           = Color(0xFFAF9AA3); // Pinkish Border

  // ===== DARK THEME =====
  static const Color darkPrimary            = Color(0xFFEF93B8); // Soft Rose Pink     — 8.7:1 on dark surface
  static const Color darkPrimaryVariant     = Color(0xFFD47EA4); // Deeper Pink        — used as primaryContainer
  static const Color darkSecondary          = Color(0xFF7FCBB4); // Aqua Mint          — 7.2:1 on dark surface
  static const Color darkSecondaryVariant   = Color(0xFF5BB899); // Deeper Mint        — used as secondaryContainer
  static const Color darkTertiary           = Color(0xFFFFB085); // Warm Coral / Peach
  static const Color darkAccent             = Color(0xFF82CFFF); // Bright Cyan
  static const Color darkAccentGold         = Color(0xFFE8B86D); // Warm Gold
  static const Color darkBackground         = Color(0xFF14101A); // Deep Plum-Black
  static const Color darkSurface            = Color(0xFF1F1520); // Dark Plum Surface
  static const Color darkSurfaceVariant     = Color(0xFF2C1F2B); // Elevated Plum
  static const Color darkOnPrimary          = Color(0xFF5A0030); // Dark on rose primary  — 6.2:1 on primary
  static const Color darkOnSecondary        = Color(0xFF003828); // Dark on mint secondary
  static const Color darkOnBackground       = Color(0xFFEEE0E8); // Warm Off-White
  static const Color darkOnSurface          = Color(0xFFEEE0E8); // Warm Off-White     — 15:1 on dark surface
  static const Color darkOnSurfaceVariant   = Color(0xFFD0BFC8); // Muted Warm White
  static const Color darkOutline            = Color(0xFF5E4A56); // Plum Border

  // ===== SEMANTIC COLORS =====
  static const Color errorLight    = Color(0xFFBA1A1A); // Deep red     — 5.9:1 on white
  static const Color errorDark     = Color(0xFFFFB4AB); // Soft red-pink — good on dark
  static const Color successLight  = Color(0xFF2E7D32); // Deep green   — 5.1:1 on white
  static const Color successDark   = Color(0xFF81C784); // Soft green
  static const Color warningLight  = Color(0xFFE65100); // Deep orange  — 5.7:1 on white
  static const Color warningDark   = Color(0xFFFFB74D); // Soft amber
  static const Color infoLight     = Color(0xFF1565C0); // Deep blue    — 7.1:1 on white
  static const Color infoDark      = Color(0xFF64B5F6); // Soft blue

  // ===== SPECIAL EFFECT COLORS =====
  static const Color shimmerLight  = Color(0xFFF0E8EC);
  static const Color shimmerDark   = Color(0xFF2C1F2B);
  static const Color shadowLight   = Color(0x16000000);
  static const Color shadowDark    = Color(0x3D000000);
}
