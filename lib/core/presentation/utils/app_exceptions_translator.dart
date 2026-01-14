import 'package:flutter/material.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/gen/l10n/l10n.dart';

class AppExceptionsTranslator {
  static final Map<Type, String Function(S)> _registry =
      <Type, String Function(S)>{
        // General exceptions
        AppException: (s) => s.appException,
        AppUnknownException: (s) => s.appUnknownException,

        // API exceptions
        ApiUnauthorizedException: (s) => s.apiUnauthorizedException,
        ApiServerException: (s) => s.apiServerException,
        ApiValidationException: (s) => s.apiValidationException,
        ApiNotFoundException: (s) => s.apiNotFoundException,
        ApiForbiddenException: (s) => s.apiForbiddenException,
        ApiTimeoutException: (s) => s.apiTimeoutException,

        // Storage exceptions
        StorageException: (s) => s.storageException,
        StorageIOException: (s) => s.storageIOException,

        // General domain exceptions
        InvalidCharactersException: (s) => s.invalidCharactersException,
        CharactersCountViolationException: (s) =>
            s.charactersCountViolationException,
        RequiredValueNotProvidedException: (s) =>
            s.requiredValueNotProvidedException,
      };

  static String translate(
    BuildContext context,
    Object? exception, {
    String? fallback,
  }) {
    final S s = S.of(context);
    if (exception == null) return fallback ?? '';

    final Type type = exception.runtimeType;

    final String Function(S)? direct = _registry[type];
    if (direct != null) return direct(s);

    return fallback ?? exception.toString();
  }
}
