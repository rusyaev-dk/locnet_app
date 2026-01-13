import 'package:locnet_app/core/domain/domain.dart';

final class PasswordsMismatchException extends DomainException {
  PasswordsMismatchException({
    required super.message,
    super.stackTrace,
    super.error,
  });
}

final class PasswordTooWeakException extends 

// // Password
// abstract class PasswordException extends DomainException {
//   PasswordException({required super.message});
// }

// final class PasswordTooShortException extends PasswordException {
//   PasswordTooShortException()
//     : super(message: 'Password must be at least 14 characters long');
// }

// final class PasswordNoUpperCaseException extends PasswordException {
//   PasswordNoUpperCaseException()
//     : super(message: 'Password must contain an uppercase letter');
// }

// final class PasswordNoLowerCaseException extends PasswordException {
//   PasswordNoLowerCaseException()
//     : super(message: 'Password must contain a lowercase letter');
// }

// final class PasswordNoDigitException extends PasswordException {
//   PasswordNoDigitException() : super(message: 'Password must contain a digit');
// }

// final class PasswordInvalidCharactersException extends PasswordException {
//   PasswordInvalidCharactersException()
//     : super(message: 'Password contains invalid characters');
// }

// final class EmptyFieldException extends DomainException {
//   EmptyFieldException({required super.message});
// }
