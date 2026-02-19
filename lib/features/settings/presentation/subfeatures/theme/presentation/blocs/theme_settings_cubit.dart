import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:locnet_app/features/settings/domain/domain.dart';
import 'package:locnet_app/features/settings/presentation/blocs/blocs.dart';

part 'theme_settings_state.dart';

/// Subfeature cubit for theme: theme type (light/dark/blue/green/purple)
/// and theme mode (system/light/dark). Uses [SettingsInteractor], syncs [SettingsCubit].
class ThemeSettingsCubit extends Cubit<ThemeSettingsState> {
  ThemeSettingsCubit({
    required SettingsInteractor settingsInteractor,
    required SettingsCubit settingsCubit,
  })  : _settingsInteractor = settingsInteractor,
        _settingsCubit = settingsCubit,
        super(const ThemeSettingsInitialState());

  final SettingsInteractor _settingsInteractor;
  final SettingsCubit _settingsCubit;

  static String _encodeThemeMode(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.system:
        return 'system';
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
    }
  }

  static ThemeMode _decodeThemeMode(String code) {
    switch (code) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
      default:
        return ThemeMode.system;
    }
  }

  Future<void> load() async {
    emit(const ThemeSettingsLoadingState());
    try {
      final results = await Future.wait([
        _settingsInteractor.getCurrentThemeType(),
        _settingsInteractor.getCurrentThemeMode(),
      ]);
      final themeType = results[0] as AppThemeType;
      final themeMode = _decodeThemeMode(results[1] as String);
      emit(ThemeSettingsLoadedState(
        themeType: themeType,
        themeMode: themeMode,
      ));
    } catch (_) {
      emit(const ThemeSettingsFailureState());
    }
  }

  Future<void> setThemeType(AppThemeType type) async {
    final current = state;
    if (current is! ThemeSettingsLoadedState) return;

    final success = await _settingsInteractor.setThemeType(type);
    if (success) {
      emit(current.copyWith(themeType: type));
      _settingsCubit.updateThemeType(type);
    } else {
      emit(const ThemeSettingsFailureState());
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    final current = state;
    if (current is! ThemeSettingsLoadedState) return;

    final success = await _settingsInteractor.changeThemeMode(
      newThemeCode: _encodeThemeMode(mode),
    );
    if (success) {
      emit(current.copyWith(themeMode: mode));
      _settingsCubit.updateThemeMode(mode);
    } else {
      emit(const ThemeSettingsFailureState());
    }
  }
}
