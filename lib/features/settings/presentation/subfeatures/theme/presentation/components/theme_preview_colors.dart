import 'package:flutter/material.dart';
import 'package:locnet_app/features/settings/domain/domain.dart';

/// Preview colors for [AppThemeType] (e.g. in theme selector).
List<Color> themePreviewColors(AppThemeType type) {
  switch (type) {
    case AppThemeType.light:
      return const [
        Color(0xFFF5F5F5),
        Color(0xFFE0E0E0),
        Color(0xFF2196F3),
        Color(0xFF1976D2),
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
        Color(0xFF90CAF9),
        Color(0xFF42A5F5),
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
  }
}

/// Single accent color for a scheme (for chips/cards).
Color themeAccentColor(int accentIndex) {
  switch (accentIndex) {
    case 1:
      return const Color(0xFF2196F3);
    case 2:
      return const Color(0xFF4CAF50);
    case 3:
      return const Color(0xFF7B1FA2);
    default:
      return const Color(0xFF2196F3);
  }
}
