import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/core/data/data.dart';

class SecureStorage implements IKeyValueStorage {
  SecureStorage({required FlutterSecureStorage flutterSecureStorage})
    : _secureStorage = flutterSecureStorage;

  final FlutterSecureStorage _secureStorage;

  @override
  Future<bool> write<T>({required String key, required T value}) async {
    _ensureValidKey(key);

    if (value is! String) {
      throw StorageException(
        message:
            'SecureStorage supports only String values, got ${value.runtimeType}',
        error: value.runtimeType,
        stackTrace: StackTrace.current,
      );
    }

    try {
      await _secureStorage.write(key: key, value: value);
      return true;
    } on StorageException {
      rethrow;
    } on Exception catch (e, st) {
      throw StorageIOException(
        message: 'Failed to write secure value for key "$key"',
        error: e,
        stackTrace: st,
      );
    } catch (e, st) {
      throw AppUnknownException(
        message:
            'Unexpected error while writing secure value for key "$key": $e',
        error: e,
        stackTrace: st,
      );
    }
  }

  @override
  Future<T?> read<T>({required String key}) async {
    _ensureValidKey(key);

    if (T != String) {
      throw StorageException(
        message: 'SecureStorage supports only String values, requested $T',
        error: T.toString(),
        stackTrace: StackTrace.current,
      );
    }

    try {
      final String? value = await _secureStorage.read(key: key);
      return value as T?;
    } on StorageException {
      rethrow;
    } on Exception catch (e, st) {
      throw StorageIOException(
        message: 'Failed to read secure value for key "$key"',
        error: e,
        stackTrace: st,
      );
    } catch (e, st) {
      throw AppUnknownException(
        message:
            'Unexpected error while reading secure value for key "$key": $e',
        error: e,
        stackTrace: st,
      );
    }
  }

  @override
  Future<bool> delete({required String key}) async {
    _ensureValidKey(key);

    try {
      await _secureStorage.delete(key: key);
      return true;
    } on Exception catch (e, st) {
      throw StorageIOException(
        message: 'Failed to delete secure value for key "$key"',
        error: e,
        stackTrace: st,
      );
    } catch (e, st) {
      throw AppUnknownException(
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
      throw StorageIOException(
        message: 'Failed to clear secure storage',
        error: e,
        stackTrace: st,
      );
    } catch (e, st) {
      throw AppUnknownException(
        message: 'Unexpected error while clearing secure storage: $e',
        error: e,
        stackTrace: st,
      );
    }
  }

  void _ensureValidKey(String key) {
    if (key.trim().isEmpty) {
      throw StorageException(
        message: 'Key cannot be empty',
        error: ArgumentError('Key cannot be empty'),
        stackTrace: StackTrace.current,
      );
    }
  }
}
