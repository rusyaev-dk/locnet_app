import 'package:locnet_app/app/app.dart';

final class SettingsExceptionCodes {
  const SettingsExceptionCodes._();

  static const AppExceptionCode localeChangeFailed = AppExceptionCode(
    'settings.localeChangeFailed',
  );

  static const AppExceptionCode themeModeChangeFailed = AppExceptionCode(
    'settings.themeModeChangeFailed',
  );

  static const AppExceptionCode restoreLocaleFailed = AppExceptionCode(
    'settings.restoreLocaleFailed',
  );

  static const AppExceptionCode restoreThemeModeFailed = AppExceptionCode(
    'settings.restoreThemeModeFailed',
  );
}
