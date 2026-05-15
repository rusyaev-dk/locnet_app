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
      return User.fromJson(decoded as Map<String, dynamic>);
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

}
