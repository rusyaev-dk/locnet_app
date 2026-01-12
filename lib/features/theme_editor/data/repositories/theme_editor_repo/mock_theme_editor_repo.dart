import 'dart:async';

import 'package:flutter/material.dart';
import 'package:locnet_app/features/theme_editor/data/data.dart';
import 'package:locnet_app/features/theme_editor/domain/domain.dart';

final class MockThemeEditorRepo implements IThemeEditorRepo {
  MockThemeEditorRepo() {
    _currentTheme = const AppTheme(
      lightPalette: AppColorPalette(
        primary: Color(0xFF9D9336),
        onPrimary: Colors.white,
        primaryContainer: Color(0xFFE0DECD),
        onPrimaryContainer: Colors.black,
        secondary: Color(0xFFB4A94C),
        onSecondary: Colors.white,
        secondaryContainer: Color(0xFFE6E2B3),
        onSecondaryContainer: Colors.black,
        tertiary: Color(0xFF7A7028),
        onTertiary: Colors.white,
        tertiaryContainer: Color(0xFFD6D1A0),
        onTertiaryContainer: Colors.black,
        error: Color(0xFFB3261E),
        onError: Colors.white,
        errorContainer: Color(0xFFF9DEDC),
        onErrorContainer: Colors.black,
        surface: Colors.white,
        onSurface: Color(0xFF1A1A1A),
        surfaceDim: Color(0xFF706E6E),
        surfaceBright: Color(0xFFF5F4EC),
        surfaceContainerLowest: Colors.white,
        surfaceContainerLow: Color(0xFFF0EDE0),
        surfaceContainer: Color(0xFFE0DECD),
        surfaceContainerHigh: Color(0xFFE4E1D4),
        surfaceContainerHighest: Color(0xFFDDDACD),
        onSurfaceVariant: Color(0xFF444433),
        outline: Color(0xFF8E8C80),
        outlineVariant: Color(0xFFCCC9BB),
        shadow: Colors.black,
        scrim: Colors.black,
        inverseSurface: Color(0xFF2C2B23),
        onInverseSurface: Color(0xFFF2F1EA),
        inversePrimary: Color(0xFFE8DD93),
        surfaceTint: Color(0xFF9D9336),
        approval: Colors.green,
      ),
      darkPalette: AppColorPalette(
        primary: Color(0xFF9D9336),
        onPrimary: Color(0xFF111111),
        primaryContainer: Color(0xFF393324),
        onPrimaryContainer: Color(0xFFF6EAC2),
        secondary: Color(0xFFC0B07A),
        onSecondary: Color(0xFF111111),
        secondaryContainer: Color(0xFF2F2A18),
        onSecondaryContainer: Color(0xFFEDE4C7),
        tertiary: Color(0xFF86A2F0),
        onTertiary: Color(0xFF0E1320),
        tertiaryContainer: Color(0xFF223161),
        onTertiaryContainer: Color(0xFFE0E7FF),
        error: Color(0xFFF2B8B5),
        onError: Color(0xFF601410),
        errorContainer: Color(0xFF8C1D18),
        onErrorContainer: Color(0xFFFFDAD6),
        surface: Color(0xFF0E1117),
        onSurface: Color(0xFFEDEFF4),
        surfaceDim: Color(0xFF60759D),
        surfaceBright: Color(0xFF1C2230),
        surfaceContainerLowest: Color(0xFF0A0D12),
        surfaceContainerLow: Color(0xFF121621),
        surfaceContainer: Color(0xFF161B27),
        surfaceContainerHigh: Color(0xFF1B2130),
        surfaceContainerHighest: Color(0xFF222A3A),
        onSurfaceVariant: Color(0xFFC7CBD9),
        outline: Color(0xFF7A8194),
        outlineVariant: Color(0xFF2E3442),
        shadow: Colors.black,
        scrim: Colors.black,
        inverseSurface: Color(0xFFF4F6FA),
        onInverseSurface: Color(0xFF1A1F2A),
        inversePrimary: Color(0xFF4A5ACF),
        surfaceTint: Color(0xFFE3C874),
        approval: Colors.green,
      ),
    );
  }

  late AppTheme _currentTheme;

  Future<void> _delay() async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
  }

  @override
  Future<AppTheme> loadAppTheme() async {
    await _delay();
    return _currentTheme;
  }

  @override
  Future<bool> updateAppTheme({required AppTheme updatedAppTheme}) async {
    await _delay();
    _currentTheme = updatedAppTheme;
    return true;
  }
}
