import 'dart:async';

import 'package:locnet_app/features/auth/data/data.dart';
import 'package:locnet_app/features/auth/domain/domain.dart';
import 'package:locnet_app/mock/mock.dart';

final class MockAuthRepo implements IAuthRepo {
  MockAuthRepo();

  final Session _mockSession = Session(
    sessionId: "mock_session_id",
    userId: MockUsers.adminUser.userId,
    refreshToken: "mock_refresh_token",
    accessToken: "mock_access_token",
    accessExpiresAt: DateTime.now().add(const Duration(minutes: 15)),
    refreshExpiresAt: DateTime.now().add(const Duration(hours: 30)),
    isExpired: false,
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );

  final _delay = const Duration(milliseconds: 300);

  @override
  Future<Session> logIn({
    required String username,
    required String password,
    DeviceInfo? deviceInfo,
  }) async {
    await Future.delayed(_delay);
    return _mockSession;
  }

  @override
  Future<void> logOut({required String sessionId}) async {
    return;
  }

  @override
  Future<Session> refresh({
    required String refreshToken,
    required String sessionId,
    DeviceInfo? deviceInfo,
  }) async {
    return _mockSession;
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
    return _mockSession;
  }
}
