import 'package:flutter/material.dart';
import 'package:locnet_app/features/settings/domain/domain.dart';

/// Preview colors for [AppThemeType] (e.g. in theme selector).
List<Color> themePreviewColors(AppThemeType type) {
  switch (type) {
    case AppThemeType.light:
      return const [
        Color(0xFFF5F5F5),
        Color(0xFFE0E0E0),
        Color(0xFF4A90E2),
        Color(0xFF90CAF9),
      ];
    case AppThemeType.lightBlue:
      return const [
        Color(0xFFF0F7FF),
        Color(0xFFE3EFFD),
        Color(0xFF2196F3),
        Color(0xFF1976D2),
      ];
    case AppThemeType.lightGreen:
      return const [
        Color(0xFFF1F8E9),
        Color(0xFFE8F5E9),
        Color(0xFF4CAF50),
        Color(0xFF2E7D32),
      ];
    case AppThemeType.lightPurple:
      return const [
        Color(0xFFF3E5F5),
        Color(0xFFE1BEE7),
        Color(0xFFAB47BC),
        Color(0xFF7B1FA2),
      ];
    case AppThemeType.dark:
      return const [
        Color(0xFF1E1E1E),
        Color(0xFF2D2D2D),
        Color(0xFF64B5F6),
        Color(0xFF1565C0),
      ];
    case AppThemeType.darkBlue:
      return const [
        Color(0xFF0E1621),
        Color(0xFF17212B),
        Color(0xFF5288C1),
        Color(0xFF2B5278),
      ];
    case AppThemeType.darkGreen:
      return const [
        Color(0xFF0D1B12),
        Color(0xFF1A2E22),
        Color(0xFF4CAF50),
        Color(0xFF2E7D32),
      ];
    case AppThemeType.darkPurple:
      return const [
        Color(0xFF1A1625),
        Color(0xFF2D2438),
        Color(0xFFAB47BC),
        Color(0xFF7B1FA2),
      ];
    case AppThemeType.lightOrange:
      return const [
        Color(0xFFFFF3E0),
        Color(0xFFFFE0B2),
        Color(0xFFFF9800),
        Color(0xFFEF6C00),
      ];
    case AppThemeType.lightTeal:
      return const [
        Color(0xFFE0F2F1),
        Color(0xFFB2DFDB),
        Color(0xFF26A69A),
        Color(0xFF00796B),
      ];
    case AppThemeType.lightAmber:
      return const [
        Color(0xFFFFF8E1),
        Color(0xFFFFECB3),
        Color(0xFFFFA726),
        Color(0xFFF57C00),
      ];
    case AppThemeType.lightPink:
      return const [
        Color(0xFFFCE4EC),
        Color(0xFFF8BBD0),
        Color(0xFFE91E63),
        Color(0xFFC2185B),
      ];
    case AppThemeType.lightIndigo:
      return const [
        Color(0xFFE8EAF6),
        Color(0xFFC5CAE9),
        Color(0xFF5C6BC0),
        Color(0xFF3949AB),
      ];
    case AppThemeType.lightRed:
      return const [
        Color(0xFFFFEBEE),
        Color(0xFFFFCDD2),
        Color(0xFFE53935),
        Color(0xFFC62828),
      ];
    case AppThemeType.darkOrange:
      return const [
        Color(0xFF1E1810),
        Color(0xFF2D2318),
        Color(0xFFFFB74D),
        Color(0xFFE65100),
      ];
    case AppThemeType.darkTeal:
      return const [
        Color(0xFF0D1816),
        Color(0xFF142824),
        Color(0xFF4DB6AC),
        Color(0xFF00695C),
      ];
    case AppThemeType.darkAmber:
      return const [
        Color(0xFF1E1A10),
        Color(0xFF2D2818),
        Color(0xFFFFCA28),
        Color(0xFFF57F17),
      ];
    case AppThemeType.darkPink:
      return const [
        Color(0xFF1E1218),
        Color(0xFF2D1824),
        Color(0xFFF48FB1),
        Color(0xFFAD1457),
      ];
    case AppThemeType.darkIndigo:
      return const [
        Color(0xFF12141E),
        Color(0xFF1C2030),
        Color(0xFF9FA8DA),
        Color(0xFF303F9F),
      ];
    case AppThemeType.darkRed:
      return const [
        Color(0xFF1E1010),
        Color(0xFF2D1818),
        Color(0xFFEF5350),
        Color(0xFFB71C1C),
      ];
  }
}

/// Primary accent swatch for UI chips (index 0–9).
Color themeAccentColor(int accentIndex) {
  switch (accentIndex.clamp(0, 9)) {
    case 1:
      return const Color(0xFF1976D2);
    case 2:
      return const Color(0xFF2E7D32);
    case 3:
      return const Color(0xFF7B1FA2);
    case 4:
      return const Color(0xFFEF6C00);
    case 5:
      return const Color(0xFF00796B);
    case 6:
      return const Color(0xFFF57C00);
    case 7:
      return const Color(0xFFC2185B);
    case 8:
      return const Color(0xFF3949AB);
    case 9:
      return const Color(0xFFC62828);
    default:
      return const Color(0xFF4A90E2);
  }
}
