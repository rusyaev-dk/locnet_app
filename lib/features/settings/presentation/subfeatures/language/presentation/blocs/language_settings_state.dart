part of 'language_settings_cubit.dart';

sealed class LanguageSettingsState extends Equatable {
  const LanguageSettingsState();

  @override
  List<Object?> get props => [];
}

final class LanguageSettingsInitialState extends LanguageSettingsState {
  const LanguageSettingsInitialState();
}

final class LanguageSettingsLoadingState extends LanguageSettingsState {
  const LanguageSettingsLoadingState();
}

final class LanguageSettingsLoadedState extends LanguageSettingsState {
  const LanguageSettingsLoadedState({required this.locale});

  final Locale locale;

  LanguageSettingsLoadedState copyWith({Locale? locale}) {
    return LanguageSettingsLoadedState(
      locale: locale ?? this.locale,
    );
  }

  @override
  List<Object?> get props => [locale];
}

final class LanguageSettingsFailureState extends LanguageSettingsState {
  const LanguageSettingsFailureState();
}
