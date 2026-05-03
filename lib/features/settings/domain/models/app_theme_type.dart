/// Predefined app color theme (Telegram Desktop–like).
/// Combines color accent (10 variants) with brightness (light / dark).
///
/// New variants are appended to preserve [name] storage keys for existing users.
enum AppThemeType {
  light,
  lightBlue,
  lightGreen,
  lightPurple,
  dark,
  darkBlue,
  darkGreen,
  darkPurple,
  lightOrange,
  lightTeal,
  lightAmber,
  lightPink,
  lightIndigo,
  lightRed,
  darkOrange,
  darkTeal,
  darkAmber,
  darkPink,
  darkIndigo,
  darkRed;

  /// Storage key for persistence.
  String get storageKey => name;

  /// Whether this theme uses a light base (background).
  bool get isLight =>
      this == AppThemeType.light ||
      this == AppThemeType.lightBlue ||
      this == AppThemeType.lightGreen ||
      this == AppThemeType.lightPurple ||
      this == AppThemeType.lightOrange ||
      this == AppThemeType.lightTeal ||
      this == AppThemeType.lightAmber ||
      this == AppThemeType.lightPink ||
      this == AppThemeType.lightIndigo ||
      this == AppThemeType.lightRed;

  /// Accent index 0–9 (Locnet default, blue, green, purple, orange, teal,
  /// amber, pink, indigo, red).
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
      case AppThemeType.lightOrange:
      case AppThemeType.darkOrange:
        return 4;
      case AppThemeType.lightTeal:
      case AppThemeType.darkTeal:
        return 5;
      case AppThemeType.lightAmber:
      case AppThemeType.darkAmber:
        return 6;
      case AppThemeType.lightPink:
      case AppThemeType.darkPink:
        return 7;
      case AppThemeType.lightIndigo:
      case AppThemeType.darkIndigo:
        return 8;
      case AppThemeType.lightRed:
      case AppThemeType.darkRed:
        return 9;
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
      case AppThemeType.lightOrange:
        return 'Light Orange';
      case AppThemeType.lightTeal:
        return 'Light Teal';
      case AppThemeType.lightAmber:
        return 'Light Amber';
      case AppThemeType.lightPink:
        return 'Light Pink';
      case AppThemeType.lightIndigo:
        return 'Light Indigo';
      case AppThemeType.lightRed:
        return 'Light Red';
      case AppThemeType.darkOrange:
        return 'Dark Orange';
      case AppThemeType.darkTeal:
        return 'Dark Teal';
      case AppThemeType.darkAmber:
        return 'Dark Amber';
      case AppThemeType.darkPink:
        return 'Dark Pink';
      case AppThemeType.darkIndigo:
        return 'Dark Indigo';
      case AppThemeType.darkRed:
        return 'Dark Red';
    }
  }

  /// Build [AppThemeType] from accent index (0–9) and light flag.
  static AppThemeType fromAccentAndBrightness({
    required int accentIndex,
    required bool isLight,
  }) {
    final int i = accentIndex.clamp(0, 9);
    if (isLight) {
      switch (i) {
        case 1:
          return AppThemeType.lightBlue;
        case 2:
          return AppThemeType.lightGreen;
        case 3:
          return AppThemeType.lightPurple;
        case 4:
          return AppThemeType.lightOrange;
        case 5:
          return AppThemeType.lightTeal;
        case 6:
          return AppThemeType.lightAmber;
        case 7:
          return AppThemeType.lightPink;
        case 8:
          return AppThemeType.lightIndigo;
        case 9:
          return AppThemeType.lightRed;
        default:
          return AppThemeType.light;
      }
    } else {
      switch (i) {
        case 1:
          return AppThemeType.darkBlue;
        case 2:
          return AppThemeType.darkGreen;
        case 3:
          return AppThemeType.darkPurple;
        case 4:
          return AppThemeType.darkOrange;
        case 5:
          return AppThemeType.darkTeal;
        case 6:
          return AppThemeType.darkAmber;
        case 7:
          return AppThemeType.darkPink;
        case 8:
          return AppThemeType.darkIndigo;
        case 9:
          return AppThemeType.darkRed;
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
