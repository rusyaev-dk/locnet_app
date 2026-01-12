import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/auth/domain/domain.dart';
import 'package:locnet_app/features/settings/domain/domain.dart';
import 'package:locnet_app/features/theme_editor/domain/domain.dart';

part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit({
    required SettingsInteractor settingsInteractor,
    required AuthInteractor authInteractor,
    required ThemeEditorInteractor themeConstructorInteractor,
    required ILogger logger,
  }) : _settingsInteractor = settingsInteractor,
       _authInteractor = authInteractor,
       _themeConstructorInteractor = themeConstructorInteractor,
       _logger = logger,
       super(const SettingsInitialState());

  final SettingsInteractor _settingsInteractor;
  final AuthInteractor _authInteractor;
  final ThemeEditorInteractor _themeConstructorInteractor;
  final ILogger _logger;

  Future<void> changeLanguageCode(Locale newLocale) async {
    try {
      if (state is! SettingsLoadedState) {
        return;
      }
      final prevState = state as SettingsLoadedState;

      final bool changeLocaleSuccess = await _settingsInteractor.changeLanguage(
        newLanguageCode: newLocale.languageCode,
      );

      if (!changeLocaleSuccess) {
        final failure = SettingsLocaleChangeException(
          message: "Failed to update app locale",
        );
        emit(prevState.copyWith(failure: failure));
        _logger.exception(failure, StackTrace.current);
        return;
      }

      if (prevState.locale != newLocale) {
        emit(prevState.copyWith(locale: newLocale));
      }
    } catch (e, st) {
      _logger.exception(e, st);
      emit(
        SettingsFailureState(
          failure: e is AppException
              ? e
              : AppUnknownException(message: e.toString(), stackTrace: st),
        ),
      );
    }
  }

  Future<void> changeThemeMode(ThemeMode newMode) async {
    try {
      if (state is! SettingsLoadedState) {
        return;
      }
      final prevState = state as SettingsLoadedState;

      final String code = _encodeThemeMode(newMode);
      final bool changeThemeSuccess = await _settingsInteractor.changeThemeMode(
        newThemeCode: code,
      );

      if (!changeThemeSuccess) {
        final failure = SettingsThemeModeChangeException(
          message: "Failed to update app theme mode",
        );
        emit(prevState.copyWith(failure: failure));
        _logger.exception(failure, StackTrace.current);
        return;
      }

      if (prevState.themeMode != newMode) {
        emit(prevState.copyWith(themeMode: newMode));
      }
    } catch (e, st) {
      _logger.exception(e, st);
      emit(
        SettingsFailureState(
          failure: e is AppException
              ? e
              : AppUnknownException(message: e.toString(), stackTrace: st),
        ),
      );
    }
  }

  Future<void> restoreSettings() async {
    try {
      if (state is! SettingsLoadingState) {
        emit(const SettingsLoadingState());
      }

      final List<dynamic> results = await Future.wait([
        _settingsInteractor.getCurrentLanguageCode(),
        _settingsInteractor.getCurrentThemeMode(),
      ]);

      final String localeCode = results[0] as String;
      final String themeCode = results[1] as String;

      final Locale restoredLocale = Locale(localeCode);
      final ThemeMode restoredTheme = _decodeThemeMode(themeCode);
      final Session restoredSession = await _authInteractor.getSession();

      final AppTheme appTheme = await _themeConstructorInteractor
          .loadAppTheme();

      emit(
        SettingsLoadedState(
          locale: restoredLocale,
          themeMode: restoredTheme,
          appTheme: appTheme,
          session: restoredSession,
        ),
      );
    } catch (e, st) {
      _logger.exception(e, st);
      emit(
        SettingsFailureState(
          failure: e is AppException
              ? e
              : AppUnknownException(message: e.toString(), stackTrace: st),
        ),
      );
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
