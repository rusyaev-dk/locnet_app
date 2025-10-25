import 'package:locnet_app/features/auth/domain/domain.dart';

abstract interface class IAuthRepo {
  /// Perform login and return full authenticated session (with tokens).
  Future<AuthSession> login({required Object initData});

  /// Refresh access token using refresh token.
  Future<AuthSession> refresh({required String refreshToken});

  /// Logout and invalidate session.
  Future<void> logout({required Session session});
}
