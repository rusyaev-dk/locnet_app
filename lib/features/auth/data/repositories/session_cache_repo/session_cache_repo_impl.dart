import 'dart:convert';

import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/auth/data/data.dart';

final class SessionCacheRepo implements ISessionCacheRepo {
  SessionCacheRepo({required IKeyValueStorage storage}) : _storage = storage;

  final IKeyValueStorage _storage;
  static const String _sessionKey = 'session_dto';

  @override
  Future<bool> saveSession({required SessionDTO sessionDTO}) async {
    try {
      final String jsonString = jsonEncode(sessionDTO.toJson());
      return await _storage.save<String>(key: _sessionKey, value: jsonString);
    } catch (error) {
      throw Exception('Failed to save session: $error');
    }
  }

  @override
  Future<SessionDTO> loadSession() async {
    try {
      final String? rawJson = await _storage.get<String>(key: _sessionKey);

      if (rawJson == null || rawJson.isEmpty) {
        throw StateError('No cached session found');
      }

      final Map<String, dynamic> jsonMap =
          jsonDecode(rawJson) as Map<String, dynamic>;

      return SessionDTO.fromJson(jsonMap);
    } on FormatException catch (error) {
      throw FormatException('Invalid cached session JSON: ${error.message}');
    } catch (error) {
      throw Exception('Failed to load session: $error');
    }
  }

  @override
  Future<bool> clearSession() async {
    try {
      return await _storage.delete(key: _sessionKey);
    } catch (error) {
      throw Exception('Failed to clear session: $error');
    }
  }
}
