import 'dart:convert';

import 'package:locnet_app/core/core.dart';

final class LocalUserCacheRepo implements IUserCacheRepo {
  LocalUserCacheRepo({required IKeyValueStorage storage}) : _storage = storage;

  final IKeyValueStorage _storage;
  final String _userKey = 'user';

  @override
  Future<bool> saveUser({required User user}) async {
    try {
      final String jsonString = jsonEncode(user.toJson());
      final bool isSaved = await _storage.write<String>(
        key: _userKey,
        value: jsonString,
      );
      return isSaved;
    } on FormatException catch (e, st) {
      throw StorageSerializationException(
        message: 'Invalid JSON format while saving user: ${e.message}',
        error: e,
        stackTrace: st,
      );
    } on Exception catch (e, st) {
      throw StorageWriteException(
        message: 'Failed to save user: $e',
        error: e,
        stackTrace: st,
      );
    } catch (e, st) {
      throw StorageUnknownException(
        message: 'Unexpected error while saving user: $e',
        error: e,
        stackTrace: st,
      );
    }
  }

  @override
  Future<User> loadUser() async {
    try {
      final String? jsonString = await _storage.read<String>(key: _userKey);

      if (jsonString == null || jsonString.isEmpty) {
        throw StorageNotFoundException(
          message: 'No cached user found.',
          error: StateError('User not found'),
          stackTrace: StackTrace.current,
        );
      }

      final Map<String, dynamic> jsonMap =
          jsonDecode(jsonString) as Map<String, dynamic>;
      return User.fromJson(jsonMap);
    } on FormatException catch (e, st) {
      throw StorageReadException(
        message: 'Corrupted cached user JSON: ${e.message}',
        error: e,
        stackTrace: st,
      );
    } on Exception catch (e, st) {
      throw StorageReadException(
        message: 'Failed to load cached user: $e',
        error: e,
        stackTrace: st,
      );
    } catch (e, st) {
      throw StorageUnknownException(
        message: 'Unexpected error while loading user: $e',
        error: e,
        stackTrace: st,
      );
    }
  }
}
