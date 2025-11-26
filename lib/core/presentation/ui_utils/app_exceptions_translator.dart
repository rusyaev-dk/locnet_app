import 'package:flutter/material.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/auth/domain/domain.dart';
import 'package:locnet_app/features/conversation/domain/domain.dart';
import 'package:locnet_app/features/settings/domain/domain.dart';
import 'package:locnet_app/gen/l10n/l10n.dart';

/// Provides localized messages for custom exceptions.
final class AppExceptionsTranslator {
  AppExceptionsTranslator._();

  /// Registry that maps exception Type to a localized string getter.
  /// Keys in l10n must be lowerCamelCase.
  static final Map<Type, String Function(S)>
  _registry = <Type, String Function(S)>{
    // API exceptions
    ApiUnauthorizedException: (s) => s.apiUnauthorizedException,
    ApiServerException: (s) => s.apiServerException,
    ApiValidationException: (s) => s.apiValidationException,
    ApiConnectionException: (s) => s.apiConnectionException,
    ApiUnknownException: (s) => s.apiUnknownException,
    ApiNotFoundException: (s) => s.apiNotFoundException,
    ApiForbiddenException: (s) => s.apiForbiddenException,
    ApiTimeoutException: (s) => s.apiTimeoutException,

    // Storage exceptions
    StorageReadException: (s) => s.storageReadException,
    StorageSerializationException: (s) => s.storageSerializationException,
    StorageUnknownException: (s) => s.storageUnknownException,
    StorageNotFoundException: (s) => s.storageNotFoundException,
    StorageWriteException: (s) => s.storageWriteException,
    StorageDeleteException: (s) => s.storageDeleteException,

    // Auth, LogIn and Registration exceptions
    AuthUnauthorizedException: (s) => s.authUnauthorizedException,
    AuthInvalidCredentialsException: (s) => s.authInvalidCredentialsException,
    AuthExpiredSessionException: (s) => s.authExpiredSessionException,
    AppAuthException: (s) => s.authUnknownException,
    RegistrationPasswordsDontMatchException: (s) =>
        s.registrationPasswordsDontMatchException,
    RegistrationEmptyFieldException: (s) => s.registrationEmptyFieldException,
    // Settings exceptions
    SettingsLocaleChangeException: (s) => s.settingsLocaleChangeException,
    SettingsThemeModeChangeException: (s) => s.settingsThemeModeChangeException,
    SettingsRestoreLocaleException: (s) => s.settingsRestoreLocaleException,
    SettingsRestoreThemeModeException: (s) =>
        s.settingsRestoreThemeModeException,
    AppSettingsException: (s) => s.settingsUnknownException,

    // Profile / validation exceptions
    NameInvalidCharactersException: (s) => s.nameInvalidCharactersException,
    UsernameInvalidCharactersException: (s) =>
        s.usernameInvalidCharactersException,
    JobPositionInvalidCharactersException: (s) =>
        s.jobPositionInvalidCharactersException,
    PasswordTooShortException: (s) => s.passwordTooShortException,
    PasswordNoUpperCaseException: (s) => s.passwordNoUpperCaseException,
    PasswordNoLowerCaseException: (s) => s.passwordNoLowerCaseException,
    PasswordNoDigitException: (s) => s.passwordNoDigitException,
    PasswordInvalidCharactersException: (s) =>
        s.passwordInvalidCharactersException,

    // Conversation Creator exceptions
    ConversationEmptyFieldException: (s) => s.conversationEmptyFieldException,
    ConversationDataTooLongException: (s) => s.conversationDataTooLongException,
    ConversationCreateException: (s) => s.conversationCreateException,

    // Optional base-class fallbacks
    AppApiException: (s) => s.apiUnknownException,
    AppStorageException: (s) => s.storageUnknownException,
    AppException: (s) => s.appException,
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

    if (exception is AppAuthException) return s.authUnknownException;
    if (exception is AppSettingsException) return s.settingsUnknownException;
    if (exception is AppApiException) return s.apiUnknownException;
    if (exception is AppStorageException) return s.storageUnknownException;
    if (exception is AppException) return s.appException;

    return fallback ?? exception.toString();
  }
}
