import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:locnet_app/uikit/uikit.dart';

/// Accent index 0–9: Locnet default, blue, green, purple, orange, teal, amber,
/// pink, indigo, red.
/// Returns full [AppColorScheme] for light theme (all colors tuned for the accent).
AppColorScheme _lightSchemeForAccent(int accentIndex) {
  switch (accentIndex.clamp(0, 9)) {
    case 1:
      return const AppColorScheme.lightBlue();
    case 2:
      return const AppColorScheme.lightGreen();
    case 3:
      return const AppColorScheme.lightPurple();
    case 4:
      return const AppColorScheme.lightOrange();
    case 5:
      return const AppColorScheme.lightTeal();
    case 6:
      return const AppColorScheme.lightAmber();
    case 7:
      return const AppColorScheme.lightPink();
    case 8:
      return const AppColorScheme.lightIndigo();
    case 9:
      return const AppColorScheme.lightRed();
    default:
      return const AppColorScheme.light();
  }
}

/// Returns full [AppColorScheme] for dark theme (all colors tuned for the accent).
AppColorScheme _darkSchemeForAccent(int accentIndex) {
  switch (accentIndex.clamp(0, 9)) {
    case 1:
      return const AppColorScheme.darkBlue();
    case 2:
      return const AppColorScheme.darkGreen();
    case 3:
      return const AppColorScheme.darkPurple();
    case 4:
      return const AppColorScheme.darkOrange();
    case 5:
      return const AppColorScheme.darkTeal();
    case 6:
      return const AppColorScheme.darkAmber();
    case 7:
      return const AppColorScheme.darkPink();
    case 8:
      return const AppColorScheme.darkIndigo();
    case 9:
      return const AppColorScheme.darkRed();
    default:
      return const AppColorScheme.dark();
  }
}

final class AppThemeData {
  AppThemeData({
    int accentIndex = 0,
    AppColorScheme? lightScheme,
    AppColorScheme? darkScheme,
  }) : _lightColorScheme = lightScheme ?? _lightSchemeForAccent(accentIndex),
       _darkColorScheme = darkScheme ?? _darkSchemeForAccent(accentIndex);

  final AppColorScheme _lightColorScheme;
  final AppColorScheme _darkColorScheme;

  static final AppSpacing _spacing = AppSpacing.standard();
  static final AppRadii _radii = AppRadii.standard();
  static final AppMotion _motion = AppMotion.standard();
  static final AppBorders _borders = AppBorders.standard();
  static final AppDesignTokens _designTokens = AppDesignTokens.standard();

  ThemeData getLightTheme() {
    return ThemeData(
      extensions: [
        _lightColorScheme,
        _textScheme,
        _spacing,
        _radii,
        _motion,
        _borders,
        _designTokens,
      ],
      brightness: Brightness.light,
      textTheme: GoogleFonts.dmSansTextTheme(ThemeData.light().textTheme).apply(
        bodyColor: _lightColorScheme.onSurface,
        displayColor: _lightColorScheme.onSurface,
      ),
      colorScheme: ColorScheme(
        brightness: Brightness.light,
        primary: _lightColorScheme.primary,
        onPrimary: _lightColorScheme.onPrimary,
        primaryContainer: _lightColorScheme.primaryContainer,
        onPrimaryContainer: _lightColorScheme.onPrimaryContainer,
        secondary: _lightColorScheme.secondary,
        onSecondary: _lightColorScheme.onSecondary,
        secondaryContainer: _lightColorScheme.secondaryContainer,
        onSecondaryContainer: _lightColorScheme.onSecondaryContainer,
        tertiary: _lightColorScheme.tertiary,
        onTertiary: _lightColorScheme.onTertiary,
        tertiaryContainer: _lightColorScheme.tertiaryContainer,
        onTertiaryContainer: _lightColorScheme.onTertiaryContainer,
        error: _lightColorScheme.error,
        onError: _lightColorScheme.onError,
        errorContainer: _lightColorScheme.errorContainer,
        onErrorContainer: _lightColorScheme.onErrorContainer,
        surface: _lightColorScheme.surface,
        onSurface: _lightColorScheme.onSurface,
        surfaceContainerLowest: _lightColorScheme.surfaceContainerLowest,
        surfaceContainerLow: _lightColorScheme.surfaceContainerLow,
        surfaceContainer: _lightColorScheme.surfaceContainer,
        surfaceContainerHigh: _lightColorScheme.surfaceContainerHigh,
        surfaceContainerHighest: _lightColorScheme.surfaceContainerHighest,
        onSurfaceVariant: _lightColorScheme.onSurfaceVariant,
        outline: _lightColorScheme.outline,
        outlineVariant: _lightColorScheme.outlineVariant,
        shadow: _lightColorScheme.shadow,
        scrim: _lightColorScheme.scrim,
        inverseSurface: _lightColorScheme.inverseSurface,
        onInverseSurface: _lightColorScheme.onInverseSurface,
        inversePrimary: _lightColorScheme.inversePrimary,
        surfaceTint: _lightColorScheme.surfaceTint,
      ),
      scaffoldBackgroundColor: _lightColorScheme.surface,
      focusColor: _lightColorScheme.primary.withAlpha(0x33),
      hoverColor: _lightColorScheme.hoverOverlay,
      splashFactory: NoSplash.splashFactory,
      highlightColor: _lightColorScheme.pressedOverlay,
      appBarTheme: AppBarTheme(
        backgroundColor: _lightColorScheme.surface,
        elevation: 0,
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(borderRadius: _radii.defaultRadiusValue),
        enabledBorder: OutlineInputBorder(
          borderRadius: _radii.defaultRadiusValue,
          borderSide: BorderSide(
            color: _lightColorScheme.outlineVariant,
            width: _borders.thin,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: _radii.defaultRadiusValue,
          borderSide: BorderSide(
            color: _lightColorScheme.primary,
            width: _borders.medium,
          ),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: _spacing.md,
          vertical: _spacing.sm,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          padding: EdgeInsets.symmetric(horizontal: _spacing.md),
          shape: RoundedRectangleBorder(
            borderRadius: _radii.defaultRadiusValue,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: _spacing.md),
          shape: RoundedRectangleBorder(
            borderRadius: _radii.defaultRadiusValue,
          ),
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: _radii.defaultRadiusValue,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: _radii.defaultRadiusValue,
          ),
        ),
      ),
      listTileTheme: ListTileThemeData(
        shape: RoundedRectangleBorder(borderRadius: _radii.defaultRadiusValue),
      ),
      popupMenuTheme: PopupMenuThemeData(
        shape: RoundedRectangleBorder(borderRadius: _radii.mediumRadius),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: _lightColorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: _radii.xlRadius),
        titleTextStyle: _textScheme.headline.copyWith(
          fontSize: 16,
          color: _lightColorScheme.onSurface,
        ),
        contentTextStyle: _textScheme.body.copyWith(
          fontSize: 14,
          color: _lightColorScheme.onSurface,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        labelTextStyle: WidgetStateProperty.all<TextStyle>(
          GoogleFonts.dmSans(fontSize: 14),
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: _lightColorScheme.surface,
        selectedItemColor: _lightColorScheme.primary,
        unselectedItemColor: _lightColorScheme.onSurface,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: _lightColorScheme.surfaceContainerHigh,
        contentTextStyle: GoogleFonts.dmSans(
          color: _lightColorScheme.onSurface,
          fontSize: 13,
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: _radii.mediumRadius),
      ),
    );
  }

  ThemeData getDarkTheme() {
    return ThemeData(
      extensions: [
        _darkColorScheme,
        _textScheme,
        _spacing,
        _radii,
        _motion,
        _borders,
        _designTokens,
      ],
      brightness: Brightness.dark,
      textTheme: GoogleFonts.dmSansTextTheme(ThemeData.dark().textTheme).apply(
        bodyColor: _darkColorScheme.onSurface,
        displayColor: _darkColorScheme.onSurface,
      ),
      colorScheme: ColorScheme(
        brightness: Brightness.dark,
        primary: _darkColorScheme.primary,
        onPrimary: _darkColorScheme.onPrimary,
        primaryContainer: _darkColorScheme.primaryContainer,
        onPrimaryContainer: _darkColorScheme.onPrimaryContainer,
        secondary: _darkColorScheme.secondary,
        onSecondary: _darkColorScheme.onSecondary,
        secondaryContainer: _darkColorScheme.secondaryContainer,
        onSecondaryContainer: _darkColorScheme.onSecondaryContainer,
        tertiary: _darkColorScheme.tertiary,
        onTertiary: _darkColorScheme.onTertiary,
        tertiaryContainer: _darkColorScheme.tertiaryContainer,
        onTertiaryContainer: _darkColorScheme.onTertiaryContainer,
        error: _darkColorScheme.error,
        onError: _darkColorScheme.onError,
        errorContainer: _darkColorScheme.errorContainer,
        onErrorContainer: _darkColorScheme.onErrorContainer,
        surface: _darkColorScheme.surface,
        onSurface: _darkColorScheme.onSurface,
        surfaceContainerLowest: _darkColorScheme.surfaceContainerLowest,
        surfaceContainerLow: _darkColorScheme.surfaceContainerLow,
        surfaceContainer: _darkColorScheme.surfaceContainer,
        surfaceContainerHigh: _darkColorScheme.surfaceContainerHigh,
        surfaceContainerHighest: _darkColorScheme.surfaceContainerHighest,
        onSurfaceVariant: _darkColorScheme.onSurfaceVariant,
        outline: _darkColorScheme.outline,
        outlineVariant: _darkColorScheme.outlineVariant,
        shadow: _darkColorScheme.shadow,
        scrim: _darkColorScheme.scrim,
        inverseSurface: _darkColorScheme.inverseSurface,
        onInverseSurface: _darkColorScheme.onInverseSurface,
        inversePrimary: _darkColorScheme.inversePrimary,
        surfaceTint: _darkColorScheme.surfaceTint,
      ),
      scaffoldBackgroundColor: _darkColorScheme.surface,
      focusColor: _darkColorScheme.primary.withAlpha(0x33),
      hoverColor: _darkColorScheme.hoverOverlay,
      splashFactory: NoSplash.splashFactory,
      highlightColor: _darkColorScheme.pressedOverlay,
      appBarTheme: AppBarTheme(
        backgroundColor: _darkColorScheme.surface,
        elevation: 0,
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(borderRadius: _radii.defaultRadiusValue),
        enabledBorder: OutlineInputBorder(
          borderRadius: _radii.defaultRadiusValue,
          borderSide: BorderSide(
            color: _darkColorScheme.outlineVariant,
            width: _borders.thin,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: _radii.defaultRadiusValue,
          borderSide: BorderSide(
            color: _darkColorScheme.primary,
            width: _borders.medium,
          ),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: _spacing.md,
          vertical: _spacing.sm,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          padding: EdgeInsets.symmetric(horizontal: _spacing.md),
          shape: RoundedRectangleBorder(
            borderRadius: _radii.defaultRadiusValue,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: _spacing.md),
          shape: RoundedRectangleBorder(
            borderRadius: _radii.defaultRadiusValue,
          ),
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: _radii.defaultRadiusValue,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: _radii.defaultRadiusValue,
          ),
        ),
      ),
      listTileTheme: ListTileThemeData(
        shape: RoundedRectangleBorder(borderRadius: _radii.defaultRadiusValue),
      ),
      popupMenuTheme: PopupMenuThemeData(
        shape: RoundedRectangleBorder(borderRadius: _radii.mediumRadius),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: _darkColorScheme.surfaceContainerLow,
        shape: RoundedRectangleBorder(
          borderRadius: _radii.xlRadius,
          side: BorderSide(color: _darkColorScheme.outline),
        ),
        titleTextStyle: _textScheme.headline.copyWith(
          fontSize: 16,
          color: _darkColorScheme.onSurface,
        ),
        contentTextStyle: _textScheme.body.copyWith(
          fontSize: 14,
          color: _darkColorScheme.onSurface,
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: _darkColorScheme.surfaceContainerLow,
        selectedItemColor: _darkColorScheme.primary,
        unselectedItemColor: _darkColorScheme.onSurfaceVariant,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: _darkColorScheme.surfaceContainerHigh,
        contentTextStyle: GoogleFonts.dmSans(
          color: _darkColorScheme.onSurface,
          fontSize: 13,
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: _radii.mediumRadius),
      ),
    );
  }

  final _textScheme = AppTextScheme.base();
}
