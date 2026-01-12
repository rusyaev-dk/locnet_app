import 'dart:async';

import 'package:locnet_app/features/auth/data/data.dart';
import 'package:locnet_app/features/auth/domain/domain.dart';

final class MockAuthRepo implements IAuthRepo {
  const MockAuthRepo();

  @override
  Future<Session> logIn({required Object initData}) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));

    // Create mock DTO as if returned by backend
    final SessionDto dto = SessionDto(
      sessionId: 'session_001',
      userId: 'usr-adm',
      refreshToken: 'mock_refresh_token_456',
      accessToken: 'mock_access_token_123',
      expiresAt: DateTime.now().add(const Duration(hours: 1)),
      isExpired: false,
      isTerminated: false,
      ipAddress: '192.168.0.100',
      macAddress: '00:1B:44:11:3A:B7',
      deviceName: 'MacBook Pro',
      deviceType: 'laptop',
      os: 'macOS',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    // Convert DTO → domain
    return Session.fromDto(dto);
  }

  @override
  Future<Session> refresh({required String refreshToken}) async {
    await Future<void>.delayed(const Duration(milliseconds: 150));

    final SessionDto dto = SessionDto(
      sessionId: 'session_001',
      userId: 'usr-adm',
      refreshToken: refreshToken,
      accessToken: 'mock_access_token_refreshed',
      expiresAt: DateTime.now().add(const Duration(hours: 1)),
      isExpired: false,
      isTerminated: false,
      ipAddress: '192.168.0.100',
      macAddress: '00:1B:44:11:3A:B7',
      deviceName: 'MacBook Pro',
      deviceType: 'laptop',
      os: 'macOS',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    return Session.fromDto(dto);
  }

  @override
  Future<void> logOut({required Session session}) async {
    await Future<void>.delayed(const Duration(milliseconds: 100));
    // Nothing to do in mock — just simulate logout.
  }
}
