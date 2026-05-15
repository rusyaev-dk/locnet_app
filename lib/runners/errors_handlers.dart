part of 'app_runner.dart';

/// Initializes global error handlers.
void _initErrorHandlers(ILogger logger, AppEnvType env) {
  // Handle Flutter framework errors.
  FlutterError.onError = (details) {
    _showErrorScreen(details.exception, env, details.stack);
    logger.error(
      'FlutterError.onError: ${details.exceptionAsString()} ${details.exception}',
      details.stack,
    );
  };
  // Handle uncaught async errors at the platform level.
  PlatformDispatcher.instance.onError = (error, stack) {
    _showErrorScreen(error, env, stack);
    logger.error('PlatformDispatcher.instance.onError $error', stack);
    return true;
  };
}

/// Pushes the error screen on top of the current navigator.
void _showErrorScreen(Object error, AppEnvType env, StackTrace? stackTrace) {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    AppRouter.rootNavigatorKey.currentState?.push(
      MaterialPageRoute(
        builder: (_) =>
            ErrorScreen(error: error, stackTrace: stackTrace, env: env),
      ),
    );
  });
}
