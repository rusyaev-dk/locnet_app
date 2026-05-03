import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/passcode/data/passcode_storage_keys.dart';
import 'package:locnet_app/features/passcode/domain/models/passcode_settings.dart';
import 'package:locnet_app/features/passcode/domain/repositories/i_passcode_repo.dart';

class LocalPasscodeRepo implements IPasscodeRepo {
  const LocalPasscodeRepo({
    required IKeyValueStorage secureStorage,
    required IKeyValueStorage localStorage,
  }) : _secure = secureStorage,
       _local = localStorage;

  final IKeyValueStorage _secure;
  final IKeyValueStorage _local;

  /// Stored in [PasscodeStorageKeys.timeoutMinutes] when [PasscodeSettings.timeoutMinutes] is null.
  static const int _neverTimeoutSentinel = -1;

  @override
  Future<PasscodeSettings> loadSettings() async {
    final bool? enabled = await _local.read<bool>(
      key: PasscodeStorageKeys.isEnabled,
    );
    final int? storedTimeout = await _local.read<int>(
      key: PasscodeStorageKeys.timeoutMinutes,
    );

    if (enabled == null && storedTimeout == null) {
      return PasscodeSettings.disabled;
    }

    final int? timeoutMinutes = switch (storedTimeout) {
      null => null,
      _neverTimeoutSentinel => null,
      final int v => v,
    };

    return PasscodeSettings(
      isEnabled: enabled ?? false,
      timeoutMinutes: timeoutMinutes,
    );
  }

  @override
  Future<void> saveSettings(PasscodeSettings settings) async {
    await _local.write<bool>(
      key: PasscodeStorageKeys.isEnabled,
      value: settings.isEnabled,
    );
    final int toStore = settings.timeoutMinutes ?? _neverTimeoutSentinel;
    await _local.write<int>(
      key: PasscodeStorageKeys.timeoutMinutes,
      value: toStore,
    );
  }

  @override
  Future<void> savePasscodeHash(String pin) async {
    final String hash = _sha256(pin);
    await _secure.write<String>(
      key: PasscodeStorageKeys.passcodeHash,
      value: hash,
    );
  }

  @override
  Future<bool> verifyPasscode(String pin) async {
    final String? stored = await _secure.read<String>(
      key: PasscodeStorageKeys.passcodeHash,
    );
    if (stored == null) return false;
    return _sha256(pin) == stored;
  }

  @override
  Future<void> clearPasscode() async {
    await _secure.delete(key: PasscodeStorageKeys.passcodeHash);
    await saveSettings(PasscodeSettings.disabled);
  }

  @override
  Future<void> saveLastBackgroundTime(DateTime time) async {
    await _local.write<int>(
      key: PasscodeStorageKeys.lastBackgroundMs,
      value: time.millisecondsSinceEpoch,
    );
  }

  @override
  Future<DateTime?> loadLastBackgroundTime() async {
    final int? ms = await _local.read<int>(
      key: PasscodeStorageKeys.lastBackgroundMs,
    );
    if (ms == null) return null;
    return DateTime.fromMillisecondsSinceEpoch(ms);
  }

  String _sha256(String pin) {
    return sha256.convert(utf8.encode(pin)).toString();
  }
}
