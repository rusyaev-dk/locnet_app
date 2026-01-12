import 'package:locnet_app/core/core.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalKeyValueStorage implements IKeyValueStorage {
  LocalKeyValueStorage({required SharedPreferences sharedPreferences})
    : _sharedPreferences = sharedPreferences;

  final SharedPreferences _sharedPreferences;

  @override
  Future<bool> write<T>({required String key, required T value}) async {
    if (key.trim().isEmpty) {
      throw ArgumentError('Key cannot be empty');
    }

    final bool isSupportedType =
        value is String ||
        value is int ||
        value is double ||
        value is bool ||
        value is List<String>;

    if (!isSupportedType) {
      throw ArgumentError('Unsupported type: ${value.runtimeType}');
    }

    try {
      if (value is String) {
        return await _sharedPreferences.setString(key, value);
      }
      if (value is int) {
        return await _sharedPreferences.setInt(key, value);
      }
      if (value is double) {
        return await _sharedPreferences.setDouble(key, value);
      }
      if (value is bool) {
        return await _sharedPreferences.setBool(key, value);
      }
      return await _sharedPreferences.setStringList(key, value as List<String>);
    } on Exception catch (e, st) {
      throw StorageWriteException(
        message: 'Failed to write value for key "$key": $e',
        error: e,
        stackTrace: st,
      );
    } catch (e, st) {
      throw StorageUnknownException(
        message: 'Unexpected error while writing value for key "$key": $e',
        error: e,
        stackTrace: st,
      );
    }
  }

  @override
  Future<T?> read<T>({required String key}) async {
    if (key.trim().isEmpty) {
      throw ArgumentError('Key cannot be empty');
    }

    try {
      final Object? value = _sharedPreferences.get(key);

      if (value == null) {
        return null;
      }

      if (value is T) {
        return value as T;
      }

      return null;
    } on Exception catch (e, st) {
      throw StorageReadException(
        message: 'Failed to read value for key "$key": $e',
        error: e,
        stackTrace: st,
      );
    } catch (e, st) {
      throw StorageUnknownException(
        message: 'Unexpected error while reading value for key "$key": $e',
        error: e,
        stackTrace: st,
      );
    }
  }

  @override
  Future<bool> delete({required String key}) async {
    if (key.trim().isEmpty) {
      throw ArgumentError('Key cannot be empty');
    }

    try {
      return await _sharedPreferences.remove(key);
    } on Exception catch (e, st) {
      throw StorageDeleteException(
        message: 'Failed to delete value for key "$key": $e',
        error: e,
        stackTrace: st,
      );
    } catch (e, st) {
      throw StorageUnknownException(
        message: 'Unexpected error while deleting value for key "$key": $e',
        error: e,
        stackTrace: st,
      );
    }
  }

  @override
  Future<bool> clear() async {
    try {
      return await _sharedPreferences.clear();
    } on Exception catch (e, st) {
      throw StorageDeleteException(
        message: 'Failed to clear local storage: $e',
        error: e,
        stackTrace: st,
      );
    } catch (e, st) {
      throw StorageUnknownException(
        message: 'Unexpected error while clearing local storage: $e',
        error: e,
        stackTrace: st,
      );
    }
  }
}
