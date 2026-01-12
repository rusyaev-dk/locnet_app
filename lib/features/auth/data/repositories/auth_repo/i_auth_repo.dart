import 'package:locnet_app/features/auth/domain/domain.dart';

abstract interface class IAuthRepo {
  Future<Session> logIn({required String username, required String password});

  Future<Session> register({
    required String username,
    required String firstName,
    required String lastName,
    required String password,
    String? patronymic,
    String? description,
  });

  Future<Session> refresh({
    required String refreshToken,
    required String sessionId,
  });

  Future<void> logOut({required String sessionId});
}
