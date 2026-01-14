import 'package:locnet_app/app/app.dart';

class DomainException extends AppException {
  DomainException({required super.message, super.error, super.stackTrace});
}

final class InvalidCharactersException extends DomainException {
  InvalidCharactersException({
    required super.message,
    super.stackTrace,
    super.error,
  });
}

final class CharactersCountViolationException extends DomainException {
  CharactersCountViolationException({
    required super.message,
    super.stackTrace,
    super.error,
  });
}

final class RequiredValueNotProvidedException extends DomainException {
  RequiredValueNotProvidedException({
    required super.message,
    super.stackTrace,
    super.error,
  });
}
