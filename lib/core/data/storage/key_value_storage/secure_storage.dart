import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:locnet_app/core/data/data.dart';

class SecureStorage implements IKeyValueStorage {
  SecureStorage({required FlutterSecureStorage flutterSecureStorage})
    : _secureStorage = flutterSecureStorage;

  final FlutterSecureStorage _secureStorage;

  @override
  Future<bool> write<T>({required String key, required T value}) async {
    if (value is! String) {
      throw ArgumentError(
        'SecureStorage supports only String values, got ${value.runtimeType}',
      );
    }

    if (key.trim().isEmpty) {
      throw ArgumentError('Key cannot be empty');
    }

    try {
      await _secureStorage.write(key: key, value: value);
      return true;
    } on Exception catch (e, st) {
      throw StorageWriteException(
        message: 'Failed to write secure value for key "$key": $e',
        error: e,
        stackTrace: st,
      );
    } catch (e, st) {
      throw StorageUnknownException(
        message:
            'Unexpected error while writing secure value for key "$key": $e',
        error: e,
        stackTrace: st,
      );
    }
  }

  @override
  Future<T?> read<T>({required String key}) async {
    if (T != String) {
      throw ArgumentError(
        'SecureStorage supports only String values, requested $T',
      );
    }

    if (key.trim().isEmpty) {
      throw ArgumentError('Key cannot be empty');
    }

    try {
      final String? value = await _secureStorage.read(key: key);
      return value as T?;
    } on Exception catch (e, st) {
      throw StorageReadException(
        message: 'Failed to read secure value for key "$key": $e',
        error: e,
        stackTrace: st,
      );
    } catch (e, st) {
      throw StorageUnknownException(
        message:
            'Unexpected error while reading secure value for key "$key": $e',
        error: e,
        stackTrace: st,
      );
    }
  }

  @override
  Future<bool> delete({required String key}) async {
    try {
      await _secureStorage.delete(key: key);
      return true;
    } on Exception catch (e, st) {
      throw StorageDeleteException(
        message: 'Failed to delete secure value for key "$key": $e',
        error: e,
        stackTrace: st,
      );
    } catch (e, st) {
      throw StorageUnknownException(
        message:
            'Unexpected error while deleting secure value for key "$key": $e',
        error: e,
        stackTrace: st,
      );
    }
  }

  @override
  Future<bool> clear() async {
    try {
      await _secureStorage.deleteAll();
      return true;
    } on Exception catch (e, st) {
      throw StorageDeleteException(
        message: 'Failed to clear secure storage: $e',
        error: e,
        stackTrace: st,
      );
    } catch (e, st) {
      throw StorageUnknownException(
        message: 'Unexpected error while clearing secure storage: $e',
        error: e,
        stackTrace: st,
      );
    }
  }
}
