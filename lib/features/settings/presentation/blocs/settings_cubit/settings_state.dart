part of 'settings_cubit.dart';

sealed class SettingsState extends Equatable {
  const SettingsState({this.failure});

  final Object? failure;
}

final class SettingsInitialState extends SettingsState {
  const SettingsInitialState({super.failure});

  @override
  List<Object?> get props => [failure];
}

final class SettingsLoadingState extends SettingsState {
  const SettingsLoadingState({super.failure});

  @override
  List<Object?> get props => [failure];
}

final class SettingsLoadedState extends SettingsState {
  const SettingsLoadedState({
    required this.locale,
    required this.themeMode,
    required this.appTheme,
    required this.session,
    super.failure,
  });

  final Locale locale;
  final ThemeMode themeMode;
  final AppTheme appTheme;
  final Session session;

  SettingsLoadedState copyWith({
    Locale? locale,
    ThemeMode? themeMode,
    AppTheme? appTheme,
    Session? session,
    Object? failure,
  }) {
    return SettingsLoadedState(
      locale: locale ?? this.locale,
      themeMode: themeMode ?? this.themeMode,
      appTheme: appTheme ?? this.appTheme,
      session: session ?? this.session,
      failure: failure,
    );
  }

  @override
  List<Object?> get props => <Object?>[locale, session, themeMode, appTheme, failure];
}

final class SettingsFailureState extends SettingsState {
  const SettingsFailureState({required super.failure});

  @override
  List<Object?> get props => [failure];
}
