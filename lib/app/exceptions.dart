class AppException implements Exception {
  AppException({
    required this.message,
    this.error,
    this.stackTrace,
    this.statusCode,
    this.details,
  });

  final String message;

  final Object? error;
  final StackTrace? stackTrace;

  final int? statusCode;

  final Map<String, Object?>? details;
}

final class AppUnknownException extends AppException {
  AppUnknownException({required super.message, super.error, super.stackTrace})
    : super();
}
