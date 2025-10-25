import 'package:locnet_app/core/core.dart';

enum SettingsErrorType implements IMessageKey {
  localeChangeFail('locale_change_fail'),
  themeModeChangeFail('theme_mode_change_fail'),
  restoreLocaleFail('restore_locale_fail'),
  restoreThemeModeFail('restore_theme_mode_fail');

  const SettingsErrorType(this.value);

  factory SettingsErrorType.fromString(String value) =>
      SettingsErrorType.values.firstWhere(
        (e) => e.value == value,
        orElse: () => throw ArgumentError('Unknown SettingsErrorType: $value'),
      );

  final String value;

  @override
  String toString() => value;
}
