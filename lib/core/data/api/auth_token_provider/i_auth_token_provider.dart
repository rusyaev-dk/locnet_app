abstract interface class IAuthTokenProvider {
  Future<String?> getToken();
  Future<bool> refreshToken();
}
