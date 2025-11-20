import 'package:locnet_app/core/core.dart';

abstract class AppAuthException extends DomainException {
  AppAuthException({required super.message, super.error, super.stackTrace});
}

final class AuthUnauthorizedException extends AppAuthException {
  AuthUnauthorizedException({
    required super.message,
    super.error,
    super.stackTrace,
  });
}

final class AuthInvalidCredentialsException extends AppAuthException {
  AuthInvalidCredentialsException({
    required super.message,
    super.error,
    super.stackTrace,
  });
}

final class AuthExpiredSessionException extends AppAuthException {
  AuthExpiredSessionException({
    required super.message,
    super.error,
    super.stackTrace,
  });
}

final class RegistrationPasswordsDontMatchException extends AppAuthException {
  RegistrationPasswordsDontMatchException({
    required super.message,
    super.error,
    super.stackTrace,
  });
}

final class RegistrationEmptyFieldException extends AppAuthException {
  RegistrationEmptyFieldException({
    required super.message,
    super.error,
    super.stackTrace,
  });
}
