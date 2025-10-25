import 'package:locnet_app/features/auth/data/data.dart';

abstract interface class ISessionCacheRepo {
  Future<bool> saveSession({required SessionDTO sessionDTO});

  Future<SessionDTO> loadSession();

  Future<bool> clearSession();
}
