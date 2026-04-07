import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/core/core.dart';

class HttpUserRepo implements IUserRepo {
  HttpUserRepo({required IHttpClient httpClient}) : _httpClient = httpClient;

  final IHttpClient _httpClient;

  @override
  Future<User> getUserById({required String userId}) async {
    try {
      final httpResponse = await _httpClient.get(
        path: '${ApiEndpoints.users}/$userId',
      );

      final Object? data = httpResponse.data;
      if (data is! Map<String, dynamic>) {
        throw AppUnknownException(
          message: 'Invalid API response format',
          error: data,
          stackTrace: StackTrace.current,
        );
      }

      return User.fromDto(UserDto.fromJson(data));
    } on AppException {
      rethrow;
    } catch (e, st) {
      throw AppUnknownException(
        message: 'Failed to fetch user by id',
        error: e,
        stackTrace: st,
      );
    }
  }

  @override
  Future<User> me() async {
    try {
      final httpResponse = await _httpClient.get(path: '${ApiEndpoints.users}/me');

      final Object? data = httpResponse.data;
      if (data is! Map<String, dynamic>) {
        throw AppUnknownException(
          message: 'Invalid API response format',
          error: data,
          stackTrace: StackTrace.current,
        );
      }

      return User.fromDto(UserDto.fromJson(data));
    } on AppException {
      rethrow;
    } catch (e, st) {
      throw AppUnknownException(
        message: 'Failed to fetch current user',
        error: e,
        stackTrace: st,
      );
    }
  }

  @override
  Future<User> updateUser({required User updatedUser}) async {
    try {
      final httpResponse = await _httpClient.put(
        path: '${ApiEndpoints.users}/${updatedUser.userId}',
        data: updatedUser.toDto().toJson(),
      );

      final Object? data = httpResponse.data;
      if (data is! Map<String, dynamic>) {
        throw AppUnknownException(
          message: 'Invalid API response format',
          error: data,
          stackTrace: StackTrace.current,
        );
      }

      return User.fromDto(UserDto.fromJson(data));
    } on AppException {
      rethrow;
    } catch (e, st) {
      throw AppUnknownException(
        message: 'Failed to update user',
        error: e,
        stackTrace: st,
      );
    }
  }
}
