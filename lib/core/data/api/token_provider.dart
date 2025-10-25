import 'package:locnet_app/core/data/data.dart';

class AuthTokenProvider implements IAuthTokenProvider {
  AuthTokenProvider({
    required IHttpClient httpClient,
    required IKeyValueStorage tokenStorage,
  }) : _httpClient = httpClient,
       _tokenStorage = tokenStorage;

  final IHttpClient _httpClient;
  final IKeyValueStorage _tokenStorage;

  static const _accessTokenKey = 'access_token';
  static const _refreshTokenKey = 'refresh_token';

  @override
  Future<String?> getToken() async {
    return await _tokenStorage.get<String>(key: _accessTokenKey);
  }

  @override
  Future<bool> refreshToken() async {
    final refreshToken = await _tokenStorage.get<String>(key: _refreshTokenKey);
    if (refreshToken == null) return false;

    try {
      final response = await _httpClient.post(
        path: '/auth/refresh',
        data: {'refresh_token': refreshToken},
      );

      final newAccessToken = response.data['access_token'];
      final newRefreshToken = response.data['refresh_token'];

      if (newAccessToken != null && newRefreshToken != null) {
        await _tokenStorage.save(key: _accessTokenKey, value: newAccessToken);
        await _tokenStorage.save(key: _refreshTokenKey, value: newRefreshToken);
        return true;
      }

      return false;
    } catch (e) {
      return false;
    }
  }

  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await _tokenStorage.save(key: _accessTokenKey, value: accessToken);
    await _tokenStorage.save(key: _refreshTokenKey, value: refreshToken);
  }

  Future<void> clearTokens() async {
    await _tokenStorage.delete(key: _accessTokenKey);
    await _tokenStorage.delete(key: _refreshTokenKey);
  }
}
