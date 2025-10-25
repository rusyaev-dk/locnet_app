import 'package:locnet_app/features/auth/domain/domain.dart';

abstract interface class IAuthDataSourceRepo {
  Future<AuthPayload> getAuthPayload();
}
