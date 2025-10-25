import 'package:locnet_app/core/utils/utils.dart';

/// A simple stopwatch helper to measure app startup time.
class TimerRunner {
  TimerRunner({required ILogger logger}) : _logger = logger {
    _stopwatch.start();
  }

  final ILogger _logger;

  /// Stopwatch used to measure initialization duration.
  final _stopwatch = Stopwatch();

  /// Stops the stopwatch and logs the total initialization time.
  void stop() {
    _stopwatch.stop();
    _logger.log(
      'Application initialization time: ${_stopwatch.elapsedMilliseconds} ms',
    );
  }

  /// Logs a progress checkpoint for dependency initialization.
  void logOnProgress(String name) {
    _logger.log(
      '$name successful initialization, progress: ${_stopwatch.elapsedMilliseconds} ms',
    );
  }

  /// Logs a completion message for a specific initialization stage.
  void logOnComplete(String message) {
    _logger.log('$message, progress: ${_stopwatch.elapsedMilliseconds} ms');
  }

  /// Logs an error that occurred during initialization.
  void logOnError(String message, Object error, [StackTrace? stackTrace]) {
    _logger.error(error, stackTrace);
  }
}
