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
      final String jsonString = jsonEncode(session.toJson());
      final bool isSaved = await _storage.write<String>(
        key: _sessionKey,
        value: jsonString,
      );
      return isSaved;
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

      final Map<String, dynamic> jsonMap =
          jsonDecode(rawJson) as Map<String, dynamic>;
      return Session.fromJson(jsonMap);
    } on FormatException catch (e, st) {
      throw StorageReadException(
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
}
