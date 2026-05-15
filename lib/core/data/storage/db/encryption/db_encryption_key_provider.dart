import 'dart:math';

import 'package:locnet_app/core/core.dart';

import 'package:locnet_app/core/data/storage/db/encryption/i_db_encryption_key_provider.dart';

class DbEncryptionKeyProvider implements IDbEncryptionKeyProvider {
  DbEncryptionKeyProvider({required IKeyValueStorage secureStorage})
    : _secureStorage = secureStorage;

  final IKeyValueStorage _secureStorage;

  static const String _storageKey = 'db_encryption_key_v1';

  @override
  Future<String> getOrCreateKey() async {
    final existing = await _secureStorage.read<String>(key: _storageKey);
    if (existing != null && existing.isNotEmpty) return existing;

    final newKey = _generateHexKey();
    await _secureStorage.write(key: _storageKey, value: newKey);
    return newKey;
  }

  String _generateHexKey() {
    final rng = Random.secure();
    final bytes = List<int>.generate(32, (_) => rng.nextInt(256));
    return bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
  }
}
