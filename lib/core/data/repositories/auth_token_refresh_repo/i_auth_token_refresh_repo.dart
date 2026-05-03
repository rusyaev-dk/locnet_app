import 'package:locnet_app/features/auth/domain/domain.dart';

abstract interface class IAuthTokenRefreshRepo {
  Future<Session> refresh(Session session);
}
