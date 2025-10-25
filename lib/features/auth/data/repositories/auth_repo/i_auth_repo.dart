import 'package:locnet_app/features/auth/domain/domain.dart';

abstract interface class IAuthRepo {
  Future<Session> login({required Object initData});
  Future<Session> refresh({required String refreshToken});
  Future<void> logout({required Session session});
}
