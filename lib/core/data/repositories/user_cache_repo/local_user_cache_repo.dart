import 'dart:convert';

import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/core/core.dart';

final class LocalUserCacheRepo implements IUserCacheRepo {
  LocalUserCacheRepo({required IKeyValueStorage storage}) : _storage = storage;

  final IKeyValueStorage _storage;
  final String _userKey = 'user';

  @override
  Future<bool> saveUser({required User user}) async {
    try {
      final Map<String, dynamic> jsonMap = user.toJson();
      final String jsonString = jsonEncode(jsonMap);

      return await _storage.write<String>(key: _userKey, value: jsonString);
    } on StorageException {
      rethrow;
    } on FormatException catch (e, st) {
      throw StorageException(
        message: 'Invalid JSON format while saving user: ${e.message}',
        error: e,
        stackTrace: st,
      );
    } on Exception catch (e, st) {
      throw StorageIOException(
        message: 'Failed to save user',
        error: e,
        stackTrace: st,
      );
    } catch (e, st) {
      throw AppUnknownException(
        message: 'Unexpected error while saving user: $e',
        error: e,
        stackTrace: st,
      );
    }
  }

  @override
  Future<User> loadUser() async {
    try {
      final String? rawJson = await _storage.read<String>(key: _userKey);

      if (rawJson == null || rawJson.isEmpty) {
        throw StorageException(
          message: 'No cached user found.',
          error: StateError('User not found'),
          stackTrace: StackTrace.current,
        );
      }

      final dynamic decoded = jsonDecode(rawJson);
      final Map<String, dynamic> jsonMap = _asJsonObject(decoded);

      _validateUserJson(jsonMap);

      return User.fromJson(jsonMap);
    } on StorageException {
      rethrow;
    } on FormatException catch (e, st) {
      throw StorageException(
        message: 'Corrupted cached user JSON: ${e.message}',
        error: e,
        stackTrace: st,
      );
    } on Exception catch (e, st) {
      throw StorageIOException(
        message: 'Failed to load cached user',
        error: e,
        stackTrace: st,
      );
    } catch (e, st) {
      throw AppUnknownException(
        message: 'Unexpected error while loading user: $e',
        error: e,
        stackTrace: st,
      );
    }
  }

  @override
  Future<bool> clearUser() async {
    try {
      return await _storage.delete(key: _userKey);
    } on StorageException {
      rethrow;
    } on Exception catch (e, st) {
      throw StorageIOException(
        message: 'Failed to delete cached user',
        error: e,
        stackTrace: st,
      );
    } catch (e, st) {
      throw AppUnknownException(
        message: 'Unexpected error while deleting cached user: $e',
        error: e,
        stackTrace: st,
      );
    }
  }

  Map<String, dynamic> _asJsonObject(dynamic decoded) {
    if (decoded is Map<String, dynamic>) {
      return decoded;
    }

    throw StorageException(
      message: 'Cached user JSON is not an object.',
      error: decoded.runtimeType,
      stackTrace: StackTrace.current,
    );
  }

  void _validateUserJson(Map<String, dynamic> json) {
    final List<String> missingOrInvalid = <String>[
      if (!_hasNonEmptyString(json, 'userId')) 'userId',
      if (!_hasNonEmptyString(json, 'username')) 'username',
      if (!_hasNonEmptyString(json, 'firstName')) 'firstName',
      if (!_hasNonEmptyString(json, 'patronymic')) 'patronymic',
      if (!_hasNonEmptyString(json, 'lastName')) 'lastName',
      if (!_hasNonEmptyString(json, 'languageCode')) 'languageCode',
      if (!_hasBool(json, 'isDeleted')) 'isDeleted',
      if (!_hasBool(json, 'isBanned')) 'isBanned',
      if (!_hasIsoDateString(json, 'createdAt')) 'createdAt',
      if (!_hasIsoDateString(json, 'updatedAt')) 'updatedAt',
    ];

    if (missingOrInvalid.isNotEmpty) {
      throw StorageException(
        message:
            'Cached user JSON misses required keys or has invalid types: ${missingOrInvalid.join(', ')}',
        error: missingOrInvalid,
        stackTrace: StackTrace.current,
      );
    }

    _validateOptionalString(json, 'description');
    _validateOptionalString(json, 'avatarId');

    _ensureParseableDate(json['createdAt'] as String, fieldName: 'createdAt');
    _ensureParseableDate(json['updatedAt'] as String, fieldName: 'updatedAt');
  }

  bool _hasNonEmptyString(Map<String, dynamic> json, String key) {
    final dynamic value = json[key];
    return value is String && value.isNotEmpty;
  }

  bool _hasBool(Map<String, dynamic> json, String key) {
    final dynamic value = json[key];
    return value is bool;
  }

  bool _hasIsoDateString(Map<String, dynamic> json, String key) {
    final dynamic value = json[key];
    return value is String && value.isNotEmpty;
  }

  void _validateOptionalString(Map<String, dynamic> json, String key) {
    final dynamic value = json[key];
    if (value != null && value is! String) {
      throw StorageException(
        message: 'Cached user JSON has invalid type for $key.',
        error: value.runtimeType,
        stackTrace: StackTrace.current,
      );
    }
  }

  void _ensureParseableDate(String value, {required String fieldName}) {
    try {
      DateTimeFormatter.parse(value);
    } on Exception catch (e, st) {
      throw StorageException(
        message: 'Cached user JSON has invalid datetime for $fieldName: $value',
        error: e,
        stackTrace: st,
      );
    }
  }
}
