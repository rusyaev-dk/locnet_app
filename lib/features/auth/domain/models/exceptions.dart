import 'package:locnet_app/core/domain/domain.dart';

final class PasswordsMismatchException extends DomainException {
  PasswordsMismatchException({
    required super.message,
    super.stackTrace,
    super.error,
  });
}

final class PasswordTooWeakException extends DomainException {
  PasswordTooWeakException({
    required super.message,
    super.stackTrace,
    super.error,
  });
}

class AuthException extends DomainException {
  AuthException({required super.message, super.stackTrace, super.error});
}

class AuthInvalidCredentialsException extends DomainException {
  AuthInvalidCredentialsException({
    required super.message,
    super.stackTrace,
    super.error,
  });
}

class AuthUnauthorizedException extends DomainException {
  AuthUnauthorizedException({
    required super.message,
    super.stackTrace,
    super.error,
  });
}
