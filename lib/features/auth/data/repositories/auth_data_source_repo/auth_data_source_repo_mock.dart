import 'dart:async';

import 'package:locnet_app/features/auth/data/data.dart';
import 'package:locnet_app/features/auth/domain/domain.dart';

final class AuthDataSourceRepoMock implements IAuthDataSourceRepo {
  const AuthDataSourceRepoMock();

  @override
  Future<AuthPayload> getAuthPayload() async {
    return const TelegramAuthPayload(
      initData: 'mock_init_data_1234567890',
      userId: 'usr-admin',
      username: 'mock_user',
      data: '{"mock":true}',
    );
  }
}
