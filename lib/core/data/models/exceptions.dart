import 'package:locnet_app/app/app.dart';

abstract class AppApiException extends AppException {
  AppApiException({
    required super.message,
    super.error,
    super.stackTrace,
    this.statusCode,
  });

  final int? statusCode;

  @override
  String toString() => 'AppApiException($statusCode): $message';
}

// Concrete API exceptions

class ApiUnauthorizedException extends AppApiException {
  ApiUnauthorizedException({
    required super.message,
    super.statusCode,
    super.error,
    super.stackTrace,
  });
}

class ApiServerException extends AppApiException {
  ApiServerException({
    required super.message,
    super.statusCode,
    super.error,
    super.stackTrace,
  });
}

class ApiValidationException extends AppApiException {
  ApiValidationException({
    required super.message,
    super.statusCode,
    super.error,
    super.stackTrace,
    this.errors,
  });

  final Map<String, dynamic>? errors;
}

class ApiConnectionException extends AppApiException {
  ApiConnectionException({
    required super.message,
    super.error,
    super.stackTrace,
  });
}

class ApiUnknownException extends AppApiException {
  ApiUnknownException({
    required super.message,
    super.statusCode,
    super.error,
    super.stackTrace,
  });
}

class ApiNotFoundException extends AppApiException {
  ApiNotFoundException({
    required super.message,
    super.statusCode,
    super.error,
    super.stackTrace,
  });
}

class ApiForbiddenException extends AppApiException {
  ApiForbiddenException({
    required super.message,
    super.statusCode,
    super.error,
    super.stackTrace,
  });
}

class ApiTimeoutException extends AppApiException {
  ApiTimeoutException({
    required super.message,
    super.statusCode,
    super.error,
    super.stackTrace,
  });
}

// Storage-related exceptions

abstract class AppStorageException extends AppException {
  AppStorageException({required super.message, super.error, super.stackTrace});

  @override
  String toString() => 'AppStorageException: $message';
}

class StorageReadException extends AppStorageException {
  StorageReadException({required super.message, super.error, super.stackTrace});
}

class StorageSerializationException extends AppStorageException {
  StorageSerializationException({
    required super.message,
    super.error,
    super.stackTrace,
  });
}

class StorageUnknownException extends AppStorageException {
  StorageUnknownException({
    required super.message,
    super.error,
    super.stackTrace,
  });
}

class StorageNotFoundException extends AppStorageException {
  StorageNotFoundException({
    required super.message,
    super.error,
    super.stackTrace,
  });
}

class StorageWriteException extends AppStorageException {
  StorageWriteException({
    required super.message,
    super.error,
    super.stackTrace,
  });
}

class StorageDeleteException extends AppStorageException {
  StorageDeleteException({
    required super.message,
    super.error,
    super.stackTrace,
  });
}
