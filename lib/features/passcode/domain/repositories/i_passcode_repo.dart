import 'package:locnet_app/features/passcode/domain/models/passcode_settings.dart';

abstract interface class IPasscodeRepo {
  Future<PasscodeSettings> loadSettings();
  Future<void> saveSettings(PasscodeSettings settings);

  /// Persists SHA-256 hash of the PIN in secure storage.
  Future<void> savePasscodeHash(String pin);

  /// Returns true when SHA-256(pin) matches stored hash.
  Future<bool> verifyPasscode(String pin);

  /// Removes PIN hash and disables passcode settings.
  Future<void> clearPasscode();

  Future<void> saveLastBackgroundTime(DateTime time);
  Future<DateTime?> loadLastBackgroundTime();
}
