import 'dart:convert';

import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/auth/data/data.dart';
import 'package:locnet_app/features/auth/domain/domain.dart';

final class LocalSessionCacheRepo implements ISessionCacheRepo {
  LocalSessionCacheRepo({required IKeyValueStorage storage})
    : _storage = storage;

  final IKeyValueStorage _storage;
  final String _sessionKey = 'session';

  @override
  Future<bool> saveSession({required Session session}) async {
    try {
      final Map<String, dynamic> jsonMap = session.toJson();
      final String jsonString = jsonEncode(jsonMap);

      return await _storage.write<String>(key: _sessionKey, value: jsonString);
    } on AppStorageException {
      rethrow;
    } on FormatException catch (e, st) {
      throw StorageSerializationException(
        message: 'Invalid session JSON format: ${e.message}',
        error: e,
        stackTrace: st,
      );
    } on Exception catch (e, st) {
      throw StorageWriteException(
        message: 'Failed to save session: $e',
        error: e,
        stackTrace: st,
      );
    } catch (e, st) {
      throw StorageUnknownException(
        message: 'Unexpected error while saving session: $e',
        error: e,
        stackTrace: st,
      );
    }
  }

  @override
  Future<Session> loadSession() async {
    try {
      final String? rawJson = await _storage.read<String>(key: _sessionKey);

      if (rawJson == null || rawJson.isEmpty) {
        throw StorageNotFoundException(
          message: 'No cached session found.',
          error: StateError('Session not found'),
          stackTrace: StackTrace.current,
        );
      }

      final dynamic decoded = jsonDecode(rawJson);
      final Map<String, dynamic> jsonMap = _asJsonObject(decoded);

      _validateSessionJson(jsonMap);

      return Session.fromJson(jsonMap);
    } on AppStorageException {
      rethrow;
    } on FormatException catch (e, st) {
      throw StorageSerializationException(
        message: 'Corrupted cached session JSON: ${e.message}',
        error: e,
        stackTrace: st,
      );
    } on Exception catch (e, st) {
      throw StorageReadException(
        message: 'Failed to load cached session: $e',
        error: e,
        stackTrace: st,
      );
    } catch (e, st) {
      throw StorageUnknownException(
        message: 'Unexpected error while loading session: $e',
        error: e,
        stackTrace: st,
      );
    }
  }

  @override
  Future<bool> clearSession() async {
    try {
      return await _storage.delete(key: _sessionKey);
    } on AppStorageException {
      rethrow;
    } on Exception catch (e, st) {
      throw StorageDeleteException(
        message: 'Failed to clear session: $e',
        error: e,
        stackTrace: st,
      );
    } catch (e, st) {
      throw StorageUnknownException(
        message: 'Unexpected error while clearing session: $e',
        error: e,
        stackTrace: st,
      );
    }
  }

  Map<String, dynamic> _asJsonObject(dynamic decoded) {
    if (decoded is Map<String, dynamic>) {
      return decoded;
    }

    throw StorageSerializationException(
      message: 'Cached session JSON is not an object.',
      error: decoded.runtimeType,
      stackTrace: StackTrace.current,
    );
  }

  void _validateSessionJson(Map<String, dynamic> json) {
    final List<String> missingKeys = <String>[
      if (!_hasNonEmptyString(json, 'sessionId')) 'sessionId',
      if (!_hasNonEmptyString(json, 'userId')) 'userId',
      if (!_hasNonEmptyString(json, 'refreshToken')) 'refreshToken',
      if (!_hasNonEmptyString(json, 'accessToken')) 'accessToken',
      if (!_hasIsoDateString(json, 'expiresAt')) 'expiresAt',
      if (!_hasBool(json, 'isExpired')) 'isExpired',
      if (!_hasIsoDateString(json, 'createdAt')) 'createdAt',
      if (!_hasIsoDateString(json, 'updatedAt')) 'updatedAt',
    ];

    if (missingKeys.isNotEmpty) {
      throw StorageSerializationException(
        message:
            'Cached session JSON misses required keys: ${missingKeys.join(', ')}',
        error: missingKeys,
        stackTrace: StackTrace.current,
      );
    }

    // Optional fields validation (only when present and non-null)
    _validateOptionalBool(json, 'isTerminated');
    _validateOptionalIsoDateString(json, 'terminatedAt');
    _validateOptionalString(json, 'ipAddress');
    _validateOptionalString(json, 'macAddress');
    _validateOptionalString(json, 'deviceName');
    _validateOptionalString(json, 'deviceType');
    _validateOptionalString(json, 'os');

    // Validate date strings are actually parseable (prevents DateTimeFormatter throwing later)
    _ensureParseableDate(json['expiresAt'] as String, fieldName: 'expiresAt');
    _ensureParseableDate(json['createdAt'] as String, fieldName: 'createdAt');
    _ensureParseableDate(json['updatedAt'] as String, fieldName: 'updatedAt');

    final dynamic terminatedAt = json['terminatedAt'];
    if (terminatedAt is String) {
      _ensureParseableDate(terminatedAt, fieldName: 'terminatedAt');
    }
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
      throw StorageSerializationException(
        message: 'Cached session JSON has invalid type for $key.',
        error: value.runtimeType,
        stackTrace: StackTrace.current,
      );
    }
  }

  void _validateOptionalBool(Map<String, dynamic> json, String key) {
    final dynamic value = json[key];
    if (value != null && value is! bool) {
      throw StorageSerializationException(
        message: 'Cached session JSON has invalid type for $key.',
        error: value.runtimeType,
        stackTrace: StackTrace.current,
      );
    }
  }

  void _validateOptionalIsoDateString(Map<String, dynamic> json, String key) {
    final dynamic value = json[key];
    if (value != null && value is! String) {
      throw StorageSerializationException(
        message: 'Cached session JSON has invalid type for $key.',
        error: value.runtimeType,
        stackTrace: StackTrace.current,
      );
    }
  }

  void _ensureParseableDate(String value, {required String fieldName}) {
    try {
      DateTimeFormatter.parse(value);
    } on Exception catch (e, st) {
      throw StorageSerializationException(
        message:
            'Cached session JSON has invalid datetime for $fieldName: $value',
        error: e,
        stackTrace: st,
      );
    }
  }
}
