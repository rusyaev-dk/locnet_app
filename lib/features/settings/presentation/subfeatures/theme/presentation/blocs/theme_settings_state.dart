part of 'theme_settings_cubit.dart';

sealed class ThemeSettingsState extends Equatable {
  const ThemeSettingsState();

  @override
  List<Object?> get props => [];
}

final class ThemeSettingsInitialState extends ThemeSettingsState {
  const ThemeSettingsInitialState();
}

final class ThemeSettingsLoadingState extends ThemeSettingsState {
  const ThemeSettingsLoadingState();
}

final class ThemeSettingsLoadedState extends ThemeSettingsState {
  const ThemeSettingsLoadedState({
    required this.themeType,
    required this.themeMode,
  });

  final AppThemeType themeType;
  final ThemeMode themeMode;

  ThemeSettingsLoadedState copyWith({
    AppThemeType? themeType,
    ThemeMode? themeMode,
  }) {
    return ThemeSettingsLoadedState(
      themeType: themeType ?? this.themeType,
      themeMode: themeMode ?? this.themeMode,
    );
  }

  @override
  List<Object?> get props => [themeType, themeMode];
}

final class ThemeSettingsFailureState extends ThemeSettingsState {
  const ThemeSettingsFailureState();
}
