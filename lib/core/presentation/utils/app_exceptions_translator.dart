import 'package:flutter/material.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/gen/l10n/l10n.dart';

final class AppExceptionsTranslator {
  AppExceptionsTranslator._();

  static final Map<Type, String Function(S)>
  _registry = <Type, String Function(S)>{
    // General exceptions
    AppException: (s) => s.appException,
    AppUnknownException: (s) => s.appUnknownException,

    // API exceptions
    ApiUnauthorizedException: (s) => s.apiUnauthorizedException,
    ApiServerException: (s) => s.apiServerException,
    ApiValidationException: (s) => s.apiValidationException,
    ApiNotFoundException: (s) => s.apiNotFoundException,
    ApiForbiddenException: (s) => s.apiForbiddenException,

    // Storage exceptions
    StorageException: (s) => s.storageReadException,
    StorageIOException: (s) => s.storageSerializationException,

    // NameInvalidCharactersException: (s) => s.nameInvalidCharactersException,
    // UsernameInvalidCharactersException: (s) =>
    //     s.usernameInvalidCharactersException,
    // UserDescriptionTooLongException: (s) =>
    //     s.jobPositionInvalidCharactersException,
    // PasswordTooShortException: (s) => s.passwordTooShortException,
    // PasswordNoUpperCaseException: (s) => s.passwordNoUpperCaseException,
    // PasswordNoLowerCaseException: (s) => s.passwordNoLowerCaseException,
    // PasswordNoDigitException: (s) => s.passwordNoDigitException,
    // PasswordInvalidCharactersException: (s) =>
    //     s.passwordInvalidCharactersException,

    // // Conversation Creator exceptions
    // ConversationEmptyFieldException: (s) => s.conversationEmptyFieldException,
    // ConversationDataTooLongException: (s) => s.conversationDataTooLongException,
    // ConversationCreateException: (s) => s.conversationCreateException,

    // // Optional base-class fallbacks
    // AppApiException: (s) => s.apiUnknownException,
    // AppStorageException: (s) => s.storageUnknownException,
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
