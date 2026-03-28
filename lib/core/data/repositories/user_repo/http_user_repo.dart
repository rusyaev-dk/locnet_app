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

      final Map<String, dynamic> responseJson = _asJsonMap(httpResponse.data);
      return User.fromJson(_extractUserJson(responseJson));
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

      final Map<String, dynamic> responseJson = _asJsonMap(httpResponse.data);
      return User.fromJson(_extractUserJson(responseJson));
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
        data: _buildUpdatePayload(updatedUser),
      );

      final Map<String, dynamic> responseJson = _asJsonMap(httpResponse.data);
      return User.fromJson(_extractUserJson(responseJson));
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

  Map<String, dynamic> _buildUpdatePayload(User user) {
    return <String, dynamic>{
      'username': user.username,
      'firstName': user.firstName,
      'lastName': user.lastName,
      'patronymic': user.patronymic,
      'languageCode': user.languageCode,
      'description': user.description,
      'avatarId': user.avatarId,
    };
  }

  Map<String, dynamic> _extractUserJson(Map<String, dynamic> responseJson) {
    final Map<String, dynamic> rawUserJson = _asJsonMap(
      responseJson['user'] ?? responseJson,
    );

    return <String, dynamic>{
      ...rawUserJson,
      'userId': rawUserJson['userId'] ?? rawUserJson['id'],
      // Backend may omit languageCode in auth-related responses.
      'languageCode': rawUserJson['languageCode'] ?? 'en',
    };
  }

  Map<String, dynamic> _asJsonMap(dynamic value) {
    if (value is Map<String, dynamic>) {
      return value;
    }

    throw AppUnknownException(
      message: 'Invalid API response format',
      error: value,
      stackTrace: StackTrace.current,
    );
  }
}
