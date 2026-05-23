import 'package:locnet_app/app/app.dart';

class StorageException extends AppException {
  StorageException({
    required super.message,
    super.stackTrace,
    super.error,
    super.details,
  });
}

class StorageIOException extends StorageException {
  StorageIOException({
    required super.message,
    super.stackTrace,
    super.error,
    super.details,
  });
}

class ApiException extends AppException {
  ApiException({
    required super.message,
    super.statusCode,
    super.stackTrace,
    super.error,
    super.details,
  });
}

final class ApiUnauthorizedException extends ApiException {
  ApiUnauthorizedException({
    required super.message,
    super.stackTrace,
    super.error,
    super.details,
    super.statusCode = 401,
  });
}

final class ApiForbiddenException extends ApiException {
  ApiForbiddenException({
    required super.message,
    super.stackTrace,
    super.error,
    super.details,
    super.statusCode = 403,
  });
}

final class ApiValidationException extends ApiException {
  ApiValidationException({
    required super.message,
    super.stackTrace,
    super.error,
    super.statusCode = 422,
  });
}

final class ApiNotFoundException extends ApiException {
  ApiNotFoundException({
    required super.message,
    super.stackTrace,
    super.error,
    super.statusCode = 404,
  });
}

final class ApiServerException extends ApiException {
  ApiServerException({
    required super.message,
    super.stackTrace,
    super.error,
    super.statusCode,
  });
}

final class ApiTimeoutException extends ApiException {
  ApiTimeoutException({
    required super.message,
    super.stackTrace,
    super.error,
    super.statusCode,
  });
}

/// Network is unreachable (SocketException, no internet).
/// Distinct from ApiException: the server was never reached at all.
final class ApiNetworkException extends ApiException {
  ApiNetworkException({
    required super.message,
    super.stackTrace,
    super.error,
  });
}
