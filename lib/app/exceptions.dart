// Core app exceptions

abstract class AppException implements Exception {
  AppException({
    required this.message,
    required this.error,
    required this.stackTrace,
  });

  final String message;
  final Object? error;
  final StackTrace? stackTrace;

  @override
  String toString() => 'AppException: $message';
}

class AppUnknownException extends AppException {
  AppUnknownException({
    required super.message,
    super.error,
    super.stackTrace,
  });
}