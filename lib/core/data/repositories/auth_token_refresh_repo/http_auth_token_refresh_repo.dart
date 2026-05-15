import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/auth/data/data.dart';
import 'package:locnet_app/features/auth/domain/domain.dart';

final class HttpAuthTokenRefreshRepo implements IAuthTokenRefreshRepo {
  HttpAuthTokenRefreshRepo({
    required IHttpClient httpClient,
    required IDeviceInfoRepo deviceInfoRepo,
  }) : _httpClient = httpClient,
       _deviceInfoRepo = deviceInfoRepo;

  final IHttpClient _httpClient;
  final IDeviceInfoRepo _deviceInfoRepo;

  @override
  Future<Session> refresh(Session session) async {
    try {
      final DeviceInfo deviceInfo = await _deviceInfoRepo.getDeviceInfo();
      final httpResponse = await _httpClient.post(
        path: ApiEndpoints.refresh,
        data: <String, dynamic>{
          'refreshToken': session.refreshToken,
          'sessionId': session.sessionId,
          'deviceInfo': _mapDeviceInfo(deviceInfo),
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
