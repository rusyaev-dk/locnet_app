import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:locnet_app/features/settings/domain/interactors/settings_interactor.dart';
import 'package:locnet_app/features/settings/presentation/blocs/blocs.dart';

part 'language_settings_state.dart';

class LanguageSettingsCubit extends Cubit<LanguageSettingsState> {
  LanguageSettingsCubit({
    required SettingsInteractor settingsInteractor,
    required SettingsCubit settingsCubit,
  })  : _settingsInteractor = settingsInteractor,
        _settingsCubit = settingsCubit,
        super(const LanguageSettingsInitialState());

  final SettingsInteractor _settingsInteractor;
  final SettingsCubit _settingsCubit;

  Future<void> load() async {
    emit(const LanguageSettingsLoadingState());
    try {
      final code = await _settingsInteractor.getCurrentLanguageCode();
      emit(LanguageSettingsLoadedState(locale: Locale(code)));
    } catch (_) {
      emit(const LanguageSettingsFailureState());
    }
  }

  Future<void> setLocale(Locale locale) async {
    final current = state;
    if (current is! LanguageSettingsLoadedState) return;

    final success = await _settingsInteractor.changeLanguage(
      newLanguageCode: locale.languageCode,
    );
    if (success) {
      emit(current.copyWith(locale: locale));
      _settingsCubit.updateLocale(locale);
    } else {
      emit(const LanguageSettingsFailureState());
    }
  }
}
