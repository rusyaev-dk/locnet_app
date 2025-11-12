
import 'package:locnet_app/core/core.dart';

/// Base exception for all settings-related domain errors.
abstract class AppSettingsException extends DomainException {
  AppSettingsException({required super.message, super.error, super.stackTrace});
}

/// Thrown when locale (language) change fails.
final class SettingsLocaleChangeException extends AppSettingsException {
  SettingsLocaleChangeException({
    required super.message,
    super.error,
    super.stackTrace,
  });
}

/// Thrown when theme mode change fails.
final class SettingsThemeModeChangeException extends AppSettingsException {
  SettingsThemeModeChangeException({
    required super.message,
    super.error,
    super.stackTrace,
  });
}

/// Thrown when restoring locale fails.
final class SettingsRestoreLocaleException extends AppSettingsException {
  SettingsRestoreLocaleException({
    required super.message,
    super.error,
    super.stackTrace,
  });
}

/// Thrown when restoring theme mode fails.
final class SettingsRestoreThemeModeException extends AppSettingsException {
  SettingsRestoreThemeModeException({
    required super.message,
    super.error,
    super.stackTrace,
  });
}
