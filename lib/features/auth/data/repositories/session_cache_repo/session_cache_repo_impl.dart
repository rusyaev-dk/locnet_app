import 'dart:convert';

import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/auth/data/data.dart';
import 'package:locnet_app/features/auth/domain/domain.dart';

final class SessionCacheRepo implements ISessionCacheRepo {
  SessionCacheRepo({required IKeyValueStorage storage}) : _storage = storage;

  final IKeyValueStorage _storage;
  final String _sessionKey = "session";

  @override
  Future<bool> saveSession({required Session session}) async {
    try {
      final String jsonString = jsonEncode(session.toJson());
      final bool isSaved = await _storage.save<String>(
        key: _sessionKey,
        value: jsonString,
      );
      return isSaved;
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<Session> loadSession() async {
    try {
      final String? rawJson = await _storage.get<String>(key: _sessionKey);

      if (rawJson != null && rawJson.isNotEmpty) {
        final Map<String, dynamic> jsonMap =
            jsonDecode(rawJson) as Map<String, dynamic>;
        return Session.fromJson(jsonMap);
      }

      throw StateError("No Session object cached!");
    } on FormatException catch (error) {
      throw FormatException('Corrupted cached session JSON: ${error.message}');
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<bool> clearSession() async {
    try {
      return await _storage.delete(key: _sessionKey);
    } catch (e) {
      rethrow;
    }
  }
}
