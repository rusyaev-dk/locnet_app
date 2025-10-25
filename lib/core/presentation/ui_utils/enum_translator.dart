
import 'package:flutter/material.dart';
import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/settings/domain/domain.dart';
import 'package:locnet_app/gen/gen.dart';

class AppMessageEnumTranslator {
  const AppMessageEnumTranslator._();

  static final Map<Type, Map<String, String Function(S)>> _registry =
      <Type, Map<String, String Function(S)>>{
        GlobalMessageType: <String, String Function(S)>{
          'unknown_error': (s) => s.unknownError,
          'no_internet': (s) => s.noInternetError,
          'request_timeout': (s) => s.requestTimeoutError,
          'unauthorized': (s) => s.unauthorizedError,
        },
        SettingsErrorType: <String, String Function(S)>{
          'locale_change_fail': (s) => s.localeChangeError,
          'theme_mode_change_fail': (s) => s.themeModeChangeError,
          'restore_locale_fail': (s) => s.localeRestoreError,
          'restore_theme_mode_fail': (s) => s.themeModeRestoreError,
        },
      };

  static String translate(
    BuildContext context,
    Object? enumValue, {
    String fallback = '',
  }) {
    if (enumValue == null) return fallback;
    final S s = S.of(context);
    final Type enumType = enumValue.runtimeType;
    final String key = enumValue.toString();

    final Map<String, String Function(S)>? typeMap = _registry[enumType];
    if (typeMap == null) return fallback.isEmpty ? key : fallback;

    final String Function(S)? getter = typeMap[key];
    if (getter == null) return fallback.isEmpty ? key : fallback;

    return getter(s);
  }
}