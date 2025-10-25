import 'package:locnet_app/core/data/storage/storage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage implements IKeyValueStorage {
  SecureStorage({required FlutterSecureStorage secureStorage})
    : _secureStorage = secureStorage;

  final FlutterSecureStorage _secureStorage;

  @override
  Future<bool> save<T>({required String key, required T value}) async {
    if (value is String) {
      await _secureStorage.write(key: key, value: value);
      return true;
    } else {
      // Поддерживаются только строки, обрабатываем отдельно
      throw ArgumentError('SecureStorage supports only String values');
    }
  }

  @override
  Future<T?> get<T>({required String key}) async {
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
