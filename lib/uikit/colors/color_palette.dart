import 'package:flutter/material.dart';

/// Locnet Messenger design system color palette.
/// All raw hex values come from the HTML prototype (Locnet Messenger.html).
abstract class LocnetPalette {
  // ── Accent ──────────────────────────────────────────────────────────────
  static const accent = Color(0xFF4A90E2);
  static const accentMutedDark = Color(0x224A90E2);
  static const accentMutedLight = Color(0x154A90E2);

  // ── Online / approval ───────────────────────────────────────────────────
  static const online = Color(0xFF4CAF79);

  // ── Danger ──────────────────────────────────────────────────────────────
  static const danger = Color(0xFFE05050);

  // ── Dark theme surfaces ──────────────────────────────────────────────────
  static const darkBgPrimary = Color(0xFF0F1117);
  static const darkBgSecondary = Color(0xFF181B24);
  static const darkBgTertiary = Color(0xFF1F2330);
  static const darkBorder = Color(0xFF252A38);
  static const darkTextPrimary = Color(0xFFE8ECF4);
  static const darkTextSecondary = Color(0xFF8B93A8);
  static const darkTextMuted = Color(0xFF525B70);

  // ── Light theme surfaces ─────────────────────────────────────────────────
  static const lightBgPrimary = Color(0xFFFFFFFF);
  static const lightBgSecondary = Color(0xFFF4F5F7);
  static const lightBgTertiary = Color(0xFFE8EAF0);
  static const lightBorder = Color(0xFFDDE1EA);
  static const lightTextPrimary = Color(0xFF0F1117);
  static const lightTextSecondary = Color(0xFF5A6070);
  static const lightTextMuted = Color(0xFF9099AD);
}

// ---------------------------------------------------------------------------
// Legacy palettes below — kept for backward compatibility with existing code.
// Prefer LocnetPalette for new code.
// ---------------------------------------------------------------------------

abstract class ColorPalette {
  static const purple = Color(0xFF9824F2);
  static const greenYellow = Color(0xFFBEFF3D);
  static const darkScarlet = Color(0xFF4D052A);
  static const folly = Color(0xFFFF004D);
  static const cultured = Color(0xFFF6F6F6);
  static const chineseBlack = Color(0xFF171717);
  static const white = Colors.white;
  static const black = Colors.black;
  static const vividRaspberry = Color(0xFFFF176B);
  static const lightSilver = Color(0xFFD9D9D9);
  static const lightGreen = Color(0xFFB5CCAE);
  static const darkGreen = Color(0xFF84A58F);
  static const lightViolet = Color(0xFF74305B);
  static const violet = Color(0xFF4A194E);
  static const appleGreen = Color(0xFF83C000);
  static const platinum = Color(0xFFE7E4E0);
  static const orange = Color(0xFFFF5500);
  static const orangeVariant = Color(0xFFE29D00);
  static const green = Color(0xFF3BB33B);
  static const red = Colors.red;
  static const grey = Color(0xFF898989);
  static const darkestGrey = Color(0xFF1D1D1D);
  static const lightGrey = Color(0xFFf5f6f6);
}

abstract class DarkColorPalette {
  static const hanPurple = Color(0xFF6D38FF);
  static const inchworm = Color(0xFFC6FF57);
  static const maroon = Color(0xFF7B0008);
  static const brinkPink = Color(0xFFFF607D);
  static const raisinBlack = Color(0xFF222222);
  static const lightSilver = Color(0xFFD6D6D6);
  static const cyclamen = Color(0xFFFF79A8);
  static const etonBlue = Color(0xFF9CD29C);
  static const russianGreen = Color(0xFF628B6E);
  static const plum = Color(0xFF9E478B);
  static const brownChocolate = Color(0xFF561E43);
  static const vividLimeGreen = Color(0xFF9ECF00);
  static const white = Colors.white;
  static const black = Colors.black;
  static const orange = Color(0xFFFF5500);
  static const orangeVariant = Color(0xFFE29D00);
  static const green = Color(0xFF3BB33B);
  static const red = Colors.red;
  static const grey = Color(0xFF898989);
  static const darkestGrey = Color(0xFF1D1D1D);
  static const lightGrey = Color(0xFFf5f6f6);
}
