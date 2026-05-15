import 'package:locnet_app/features/auth/domain/domain.dart';

abstract interface class ISessionCacheRepo {
  Future<bool> saveSession({
    required Session session,
  });
  Future<Session> loadSession();
  Future<bool> clearSession();
}
