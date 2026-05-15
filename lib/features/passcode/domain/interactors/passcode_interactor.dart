import 'package:locnet_app/features/passcode/domain/exceptions/passcode_exceptions.dart';
import 'package:locnet_app/features/passcode/domain/models/passcode_settings.dart';
import 'package:locnet_app/features/passcode/domain/repositories/i_passcode_repo.dart';

class PasscodeInteractor {
  PasscodeInteractor({required IPasscodeRepo passcodeRepo})
    : _repo = passcodeRepo;

  final IPasscodeRepo _repo;

  Future<PasscodeSettings> getSettings() => _repo.loadSettings();

  Future<void> enablePasscode(String pin) async {
    await _repo.savePasscodeHash(pin);
    final PasscodeSettings current = await _repo.loadSettings();
    await _repo.saveSettings(
      PasscodeSettings(
        isEnabled: true,
        timeoutMinutes: current.timeoutMinutes ?? 1,
      ),
    );
  }

  Future<void> disablePasscode(String pin) async {
    if (!await _repo.verifyPasscode(pin)) {
      throw const PasscodeWrongPinException();
    }
    await _repo.clearPasscode();
  }

  Future<void> changePasscode(String oldPin, String newPin) async {
    if (!await _repo.verifyPasscode(oldPin)) {
      throw const PasscodeWrongPinException();
    }
    await _repo.savePasscodeHash(newPin);
  }

  Future<bool> verifyPasscode(String pin) => _repo.verifyPasscode(pin);

  Future<void> updateTimeout(int? minutes) async {
    final PasscodeSettings current = await _repo.loadSettings();
    await _repo.saveSettings(
      PasscodeSettings(
        isEnabled: current.isEnabled,
        timeoutMinutes: minutes,
      ),
    );
  }

  Future<void> saveLastBackgroundTime(DateTime time) =>
      _repo.saveLastBackgroundTime(time);

  /// Called on app resume: returns whether the UI should show the lock screen.
  Future<bool> shouldLock() async {
    final PasscodeSettings settings = await _repo.loadSettings();
    if (!settings.isEnabled) return false;

    final int? timeout = settings.timeoutMinutes;
    if (timeout == null) return false; // "never" by inactivity
    if (timeout == 0) return true; // "immediately"

    final DateTime? lastBg = await _repo.loadLastBackgroundTime();
    if (lastBg == null) return false;

    final int elapsed = DateTime.now().difference(lastBg).inMinutes;
    return elapsed >= timeout;
  }
}
