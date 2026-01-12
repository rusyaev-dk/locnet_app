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

final class RegistrationFailedException extends AppAuthException {
  RegistrationFailedException({
    required super.message,
    super.error,
    super.stackTrace,
  });
}

final class LogInFailedException extends AppAuthException {
  LogInFailedException({required super.message, super.error, super.stackTrace});
}

final class UsernameAlreadyTakenException extends AppAuthException {
  UsernameAlreadyTakenException({
    required super.message,
    super.error,
    super.stackTrace,
  });
}

abstract class AppSessionException extends DomainException {
  AppSessionException({required super.message, super.error, super.stackTrace});
}

final class SessionCacheWriteException extends AppSessionException {
  SessionCacheWriteException({
    required super.message,
    super.error,
    super.stackTrace,
  });
}

final class UserCacheWriteException extends AppSessionException {
  UserCacheWriteException({
    required super.message,
    super.error,
    super.stackTrace,
  });
}
