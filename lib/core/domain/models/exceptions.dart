import 'package:locnet_app/app/app.dart';

abstract class DomainException extends AppException {
  DomainException({required super.message, super.error, super.stackTrace});
}

// Name
abstract class NameException extends DomainException {
  NameException({required super.message});
}

final class NameInvalidCharactersException extends NameException {
  NameInvalidCharactersException()
      : super(message: 'Name contains invalid characters');
}

// Username
abstract class UsernameException extends DomainException {
  UsernameException({required super.message});
}

final class UsernameInvalidCharactersException extends UsernameException {
  UsernameInvalidCharactersException()
      : super(message: 'Username contains invalid characters');
}

// Job position
abstract class JobPositionException extends DomainException {
  JobPositionException({required super.message});
}

final class JobPositionInvalidCharactersException extends JobPositionException {
  JobPositionInvalidCharactersException()
      : super(message: 'Job position contains invalid characters');
}

// Password
abstract class PasswordException extends DomainException {
  PasswordException({required super.message});
}

final class PasswordTooShortException extends PasswordException {
  PasswordTooShortException()
      : super(message: 'Password must be at least 14 characters long');
}

final class PasswordNoUpperCaseException extends PasswordException {
  PasswordNoUpperCaseException()
      : super(message: 'Password must contain an uppercase letter');
}

final class PasswordNoLowerCaseException extends PasswordException {
  PasswordNoLowerCaseException()
      : super(message: 'Password must contain a lowercase letter');
}

final class PasswordNoDigitException extends PasswordException {
  PasswordNoDigitException()
      : super(message: 'Password must contain a digit');
}

final class PasswordInvalidCharactersException extends PasswordException {
  PasswordInvalidCharactersException()
      : super(message: 'Password contains invalid characters');
}