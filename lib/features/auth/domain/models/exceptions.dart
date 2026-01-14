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
