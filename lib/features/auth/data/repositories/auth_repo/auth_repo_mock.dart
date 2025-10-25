import 'dart:async';

import 'package:locnet_app/features/auth/data/data.dart';
import 'package:locnet_app/features/auth/domain/domain.dart';
import 'package:locnet_app/features/auth/domain/models/session.dart';

final class AuthRepoMock implements IAuthRepo {
  const AuthRepoMock();

  @override
  Future<Session> login({required Object initData}) async {
    // Simulate backend delay
    await Future<void>.delayed(const Duration(milliseconds: 250));

    // Normally you'd parse initData; here we just ignore it
    return const Session(
      sessionToken: 'mock_session_token_123',
      refreshToken: 'mock_refresh_token_456',
      userId: 'usr-admin',
    );
  }

  @override
  Future<Session> refresh({required String refreshToken}) async {
    await Future<void>.delayed(const Duration(milliseconds: 150));

    // Simulate refresh producing a new session token
    return Session(
      sessionToken: 'mock_session_token_refreshed',
      refreshToken: refreshToken,
      userId: 'usr-admin',
    );
  }

  @override
  Future<void> logout({required Session session}) async {
    await Future<void>.delayed(const Duration(milliseconds: 100));
    // Nothing to do — pretend session was revoked
  }
}
