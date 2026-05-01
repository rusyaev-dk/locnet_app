import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/settings/domain/domain.dart';
import 'package:locnet_app/features/theme_editor/domain/domain.dart';

part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit({
    required SettingsInteractor settingsInteractor,
    required ThemeEditorInteractor themeConstructorInteractor,
    required ILogger logger,
  }) : _settingsInteractor = settingsInteractor,
       _themeConstructorInteractor = themeConstructorInteractor,
       _logger = logger,
       super(const SettingsInitialState());

  final SettingsInteractor _settingsInteractor;
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
        final failure = AppUnknownException(
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
        final failure = AppUnknownException(
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
        _themeConstructorInteractor.loadAppTheme(),
        _settingsInteractor.getCurrentThemeType(),
        _settingsInteractor.getCurrentTextScaleCode(),
        _settingsInteractor.getCurrentElementScaleCode(),
      ]);

      final String localeCode = results[0] as String;
      final String themeCode = results[1] as String;
      final AppTheme appTheme = results[2] as AppTheme;
      final AppThemeType themeType = results[3] as AppThemeType;
      final String textScaleCode = results[4] as String;
      final String elementScaleCode = results[5] as String;

      emit(
        SettingsLoadedState(
          locale: Locale(localeCode),
          themeMode: _decodeThemeMode(themeCode),
          appTheme: appTheme,
          themeType: themeType,
          textScaleFactor: _decodeTextScaleCode(textScaleCode),
          elementScaleFactor: _decodeElementScaleCode(elementScaleCode),
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

  Future<void> changeThemeType(AppThemeType newType) async {
    try {
      if (state is! SettingsLoadedState) return;
      final prevState = state as SettingsLoadedState;

      final bool success = await _settingsInteractor.setThemeType(newType);
      if (!success) {
        final failure = AppUnknownException(message: 'Failed to save theme');
        emit(prevState.copyWith(failure: failure));
        _logger.exception(failure, StackTrace.current);
        return;
      }
      emit(prevState.copyWith(themeType: newType));
    } catch (e, st) {
      _logger.exception(e, st);
      if (state is SettingsLoadedState) {
        emit(
          (state as SettingsLoadedState).copyWith(
            failure: e is AppException
                ? e
                : AppUnknownException(message: e.toString(), stackTrace: st),
          ),
        );
      } else {
        emit(
          SettingsFailureState(
            failure: e is AppException
                ? e
                : AppUnknownException(message: e.toString(), stackTrace: st),
          ),
        );
      }
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

  Future<void> changeTextScale(double newFactor) async {
    try {
      if (state is! SettingsLoadedState) {
        return;
      }
      final prevState = state as SettingsLoadedState;
      final clamped =
          newFactor.clamp(0.85, 1.2);
      final code = clamped.toStringAsFixed(2);

      final bool success = await _settingsInteractor.changeTextScale(
        newTextScaleCode: code,
      );

      if (!success) {
        final failure = AppUnknownException(
          message: 'Failed to update text scale',
        );
        emit(prevState.copyWith(failure: failure));
        _logger.exception(failure, StackTrace.current);
        return;
      }

      if ((prevState.textScaleFactor - clamped).abs() > 0.001) {
        emit(prevState.copyWith(textScaleFactor: clamped));
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

  Future<void> changeElementScale(double newFactor) async {
    try {
      if (state is! SettingsLoadedState) {
        return;
      }
      final prevState = state as SettingsLoadedState;
      final clamped = newFactor.clamp(0.9, 1.15);
      final code = clamped.toStringAsFixed(2);

      final bool success = await _settingsInteractor.changeElementScale(
        newElementScaleCode: code,
      );

      if (!success) {
        final failure = AppUnknownException(
          message: 'Failed to update element scale',
        );
        emit(prevState.copyWith(failure: failure));
        _logger.exception(failure, StackTrace.current);
        return;
      }

      if ((prevState.elementScaleFactor - clamped).abs() > 0.001) {
        emit(prevState.copyWith(elementScaleFactor: clamped));
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

  double _decodeTextScaleCode(String code) {
    switch (code) {
      case 's':
        return 0.9;
      case 'l':
        return 1.1;
      case 'm':
        return 1.0;
    }
    final value = double.tryParse(code);
    if (value == null || value < 0.85 || value > 1.2) return 1.0;
    return value.clamp(0.85, 1.2);
  }

  double _decodeElementScaleCode(String code) {
    final value = double.tryParse(code);
    if (value == null || value < 0.9 || value > 1.15) return 1.0;
    return value.clamp(0.9, 1.15);
  }
}
