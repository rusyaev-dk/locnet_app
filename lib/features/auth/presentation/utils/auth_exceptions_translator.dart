import 'package:flutter/material.dart';
import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/auth/domain/domain.dart';
import 'package:locnet_app/gen/l10n/l10n.dart';

class AuthExceptionsTranslator {
  static final Map<Type, String Function(S)> _registry =
      <Type, String Function(S)>{
        PasswordsMismatchException: (s) => s.passwordsMismatchException,
        PasswordTooWeakException: (s) => s.passwordTooWeakException,
        AuthLoginAlreadyTakenException: (s) => s.authLoginAlreadyTakenException,
        AuthInvalidCredentialsException: (s) =>
            s.authInvalidCredentialsException,
        AuthUnauthorizedException: (s) => s.authUnauthorizedException,
        AuthException: (s) => s.authException,
      };

  static String translate(
    BuildContext context,
    Object? exception, {
    String? fallback,
  }) {
    if (exception == null) {
      return fallback ?? '';
    }

    final S s = S.of(context);
    final Type type = exception.runtimeType;

    final String Function(S)? direct = _registry[type];
    if (direct != null) {
      return direct(s);
    }

    return AppExceptionsTranslator.translate(
      context,
      exception,
      fallback: fallback,
    );
  }
}
