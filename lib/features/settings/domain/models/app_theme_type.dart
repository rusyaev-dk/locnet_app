/// Predefined app color theme (Telegram Desktop–like).
/// Combines color scheme (default/blue/green/purple) with brightness (light/dark).
enum AppThemeType {
  light,
  lightBlue,
  lightGreen,
  lightPurple,
  dark,
  darkBlue,
  darkGreen,
  darkPurple;

  /// Storage key for persistence.
  String get storageKey => name;

  /// Whether this theme uses a light base (background).
  bool get isLight =>
      this == AppThemeType.light ||
      this == AppThemeType.lightBlue ||
      this == AppThemeType.lightGreen ||
      this == AppThemeType.lightPurple;

  /// Accent index: 0 = default, 1 = blue, 2 = green, 3 = purple.
  int get accentIndex {
    switch (this) {
      case AppThemeType.light:
      case AppThemeType.dark:
        return 0;
      case AppThemeType.lightBlue:
      case AppThemeType.darkBlue:
        return 1;
      case AppThemeType.lightGreen:
      case AppThemeType.darkGreen:
        return 2;
      case AppThemeType.lightPurple:
      case AppThemeType.darkPurple:
        return 3;
    }
  }

  /// User-facing label (for l10n) or fallback label.
  String get label {
    switch (this) {
      case AppThemeType.light:
        return 'Light';
      case AppThemeType.lightBlue:
        return 'Light Blue';
      case AppThemeType.lightGreen:
        return 'Light Green';
      case AppThemeType.lightPurple:
        return 'Light Purple';
      case AppThemeType.dark:
        return 'Dark';
      case AppThemeType.darkBlue:
        return 'Dark Blue';
      case AppThemeType.darkGreen:
        return 'Dark Green';
      case AppThemeType.darkPurple:
        return 'Dark Purple';
    }
  }

  /// Build [AppThemeType] from accent index (0–3) and light flag.
  static AppThemeType fromAccentAndBrightness({
    required int accentIndex,
    required bool isLight,
  }) {
    if (isLight) {
      switch (accentIndex) {
        case 1:
          return AppThemeType.lightBlue;
        case 2:
          return AppThemeType.lightGreen;
        case 3:
          return AppThemeType.lightPurple;
        default:
          return AppThemeType.light;
      }
    } else {
      switch (accentIndex) {
        case 1:
          return AppThemeType.darkBlue;
        case 2:
          return AppThemeType.darkGreen;
        case 3:
          return AppThemeType.darkPurple;
        default:
          return AppThemeType.dark;
      }
    }
  }

  /// Parse from stored string; returns [AppThemeType.light] on unknown.
  static AppThemeType fromStorage(String? value) {
    if (value == null || value.isEmpty) return AppThemeType.light;
    return AppThemeType.values.asNameMap()[value] ?? AppThemeType.light;
  }
}
