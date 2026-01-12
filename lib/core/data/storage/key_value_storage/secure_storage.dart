import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:locnet_app/core/data/storage/storage.dart';

class SecureStorage implements IKeyValueStorage {
  SecureStorage({required FlutterSecureStorage flutterSecureStorage})
    : _secureStorage = flutterSecureStorage;

  final FlutterSecureStorage _secureStorage;

  @override
  Future<bool> write<T>({required String key, required T value}) async {
    if (value is String) {
      await _secureStorage.write(key: key, value: value);
      return true;
    } else {
      // Поддерживаются только строки, обрабатываем отдельно
      throw ArgumentError('SecureStorage supports only String values');
    }
  }

  @override
  Future<T?> read<T>({required String key}) async {
    final value = await _secureStorage.read(key: key);
    if (value == null) return null;

    if (T == String) return value as T;
    throw ArgumentError('SecureStorage only supports reading String values');
  }

  @override
  Future<bool> delete({required String key}) async {
    await _secureStorage.delete(key: key);
    return true;
  }

  @override
  Future<bool> clear() async {
    await _secureStorage.deleteAll();
    return true;
  }
}
