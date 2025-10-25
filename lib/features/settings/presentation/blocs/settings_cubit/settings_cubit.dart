import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/settings/data/data.dart';
import 'package:locnet_app/features/settings/domain/domain.dart';

part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit({
    required ISettingsRepo settingsRepository,
    required ILogger logger,
  }) : _settingsRepository = settingsRepository,
       _logger = logger,
       super(SettingsInitialState()) {
    _restoreSettings();
  }

  final ISettingsRepo _settingsRepository;
  final ILogger _logger;

  Future<void> changeLocale(Locale newLocale) async {
    try {
      if (state is! SettingsLoadedState) {
        return;
      }
      final prevState = state as SettingsLoadedState;

      final bool changeLocaleSuccess = await _settingsRepository.changeLocale(
        newLocale.languageCode,
      );

      if (!changeLocaleSuccess) {
        prevState.copyWith(
          message: AppMessage(key: SettingsErrorType.localeChangeFail),
        );
        _logger.exception("Failed update app locale...");
        return;
      }

      if (prevState.locale != newLocale) {
        emit(prevState.copyWith(locale: newLocale));
      }
    } catch (e, st) {
      emit(
        SettingsFailureState(
          failure: e,
          message: AppMessage(key: GlobalMessageType.unknownError),
        ),
      );
      _logger.exception(e, st);
    }
  }

  Future<void> changeThemeMode(ThemeMode newMode) async {
    try {
      if (state is! SettingsLoadedState) {
        return;
      }
      final prevState = state as SettingsLoadedState;

      final String code = _encodeThemeMode(newMode);
      final bool changeThemeSuccess = await _settingsRepository.changeThemeMode(
        code,
      );

      if (!changeThemeSuccess) {
        prevState.copyWith(
          message: AppMessage(key: SettingsErrorType.themeModeChangeFail),
        );
        _logger.exception("Failed change app theme mode...");
        return;
      }

      if (prevState.themeMode != newMode) {
        emit(prevState.copyWith(themeMode: newMode));
      }
    } catch (e, st) {
      emit(
        SettingsFailureState(
          failure: extensionStreamHasListener,
          message: AppMessage(key: GlobalMessageType.unknownError),
        ),
      );
      _logger.exception(e, st);
    }
  }

  Future<void> _restoreSettings() async {
    try {
      if (state is! SettingsLoadingState) {
        emit(SettingsLoadingState());
      }

      final List<dynamic> results = await Future.wait([
        _settingsRepository.getCurrentLocale(),
        _settingsRepository.getCurrentThemeMode(),
      ]);

      final String localeCode = results[0] as String;
      final String themeCode = results[1] as String;

      final Locale restoredLocale = Locale(localeCode);
      final ThemeMode restoredTheme = _decodeThemeMode(themeCode);

      emit(
        SettingsLoadedState(locale: restoredLocale, themeMode: restoredTheme),
      );
    } catch (e, st) {
      emit(
        SettingsFailureState(
          failure: e,
          message: AppMessage(key: GlobalMessageType.unknownError),
        ),
      );
      _logger.exception(e, st);
    }
  }

  String _encodeThemeMode(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.system:
        return 'system';
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
    }
  }

  ThemeMode _decodeThemeMode(String code) {
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
}
