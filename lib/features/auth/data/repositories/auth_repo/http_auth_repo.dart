import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/auth/data/data.dart';
import 'package:locnet_app/features/auth/domain/domain.dart';

final class HttpAuthRepo implements IAuthRepo {
  HttpAuthRepo({required IHttpClient httpClient}) : _httpClient = httpClient;

  final IHttpClient _httpClient;

  @override
  Future<Session> logIn({
    required String username,
    required String password,
    DeviceInfo? deviceInfo,
  }) async {
    try {
      final httpResponse = await _httpClient.post(
        path: ApiEndpoints.logIn,
        data: <String, dynamic>{
          'username': username,
          'password': password,
          if (deviceInfo != null) 'deviceInfo': _mapDeviceInfo(deviceInfo),
        },
      );

      final Map<String, dynamic> responseJson = _asJsonMap(httpResponse.data);
      return Session.fromJson(_extractSessionJson(responseJson));
    } on AppException {
      rethrow;
    } catch (e, st) {
      throw AppUnknownException(
        message: 'Failed to login',
        error: e,
        stackTrace: st,
      );
    }
  }

  @override
  Future<Session> register({
    required String username,
    required String firstName,
    required String lastName,
    required String password,
    String? patronymic,
    String? description,
    DeviceInfo? deviceInfo,
  }) async {
    try {
      final httpResponse = await _httpClient.post(
        path: ApiEndpoints.register,
        data: <String, dynamic>{
          'username': username,
          'firstName': firstName,
          'lastName': lastName,
          'patronymic': patronymic,
          'description': description,
          'password': password,
          if (deviceInfo != null) 'deviceInfo': _mapDeviceInfo(deviceInfo),
        },
      );

      final Map<String, dynamic> responseJson = _asJsonMap(httpResponse.data);
      return Session.fromJson(_extractSessionJson(responseJson));
    } on AppException {
      rethrow;
    } catch (e, st) {
      throw AppUnknownException(
        message: 'Failed to register',
        error: e,
        stackTrace: st,
      );
    }
  }

  @override
  Future<Session> refresh({
    required String refreshToken,
    required String sessionId,
    DeviceInfo? deviceInfo,
  }) async {
    try {
      final httpResponse = await _httpClient.post(
        path: ApiEndpoints.refresh,
        data: <String, dynamic>{
          'refreshToken': refreshToken,
          'sessionId': sessionId,
          if (deviceInfo != null) 'deviceInfo': _mapDeviceInfo(deviceInfo),
        },
      );

      final Map<String, dynamic> responseJson = _asJsonMap(httpResponse.data);
      return Session.fromJson(_extractSessionJson(responseJson));
    } on AppException {
      rethrow;
    } catch (e, st) {
      throw AppUnknownException(
        message: 'Failed to refresh session',
        error: e,
        stackTrace: st,
      );
    }
  }

  @override
  Future<void> logOut({required String sessionId}) async {
    try {
      await _httpClient.post(
        path: ApiEndpoints.logOut,
        data: <String, dynamic>{'sessionId': sessionId},
      );
    } on AppException {
      rethrow;
    } catch (e, st) {
      throw AppUnknownException(
        message: 'Failed to logout',
        error: e,
        stackTrace: st,
      );
    }
  }

  Map<String, dynamic> _mapDeviceInfo(DeviceInfo deviceInfo) {
    return DeviceInfoDto(
      ipAddress: deviceInfo.ipAddress,
      macAddress: deviceInfo.macAddress,
      deviceName: deviceInfo.deviceName,
      deviceType: deviceInfo.deviceType,
      operatingSystem: deviceInfo.operatingSystem,
    ).toJson();
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

  Map<String, dynamic> _extractSessionJson(Map<String, dynamic> responseJson) {
    final dynamic sessionDynamic = responseJson['session'];
    final Map<String, dynamic> sessionJson = sessionDynamic != null
        ? _asJsonMap(sessionDynamic)
        : responseJson;

    final String? rootAccess = responseJson['accessExpiresAt'] as String?;
    final String? rootRefresh = responseJson['refreshExpiresAt'] as String?;

    return <String, dynamic>{
      ...sessionJson,
      // Some endpoints duplicate tokens on root level.
      // Keep root values as a fallback if session fields are missing.
      'accessToken': sessionJson['accessToken'] ?? responseJson['accessToken'],
      'refreshToken': sessionJson['refreshToken'] ?? responseJson['refreshToken'],
      'accessExpiresAt':
          rootAccess ??
          sessionJson['accessExpiresAt'] as String? ??
          sessionJson['expiresAt'] as String?,
      'refreshExpiresAt':
          rootRefresh ??
          sessionJson['refreshExpiresAt'] as String? ??
          sessionJson['expiresAt'] as String?,
    };
  }
}
