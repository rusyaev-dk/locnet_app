import 'package:locnet_app/features/auth/data/data.dart';
import 'package:locnet_app/features/auth/domain/models/session.dart';

class HttpAuthRepo implements IAuthRepo {
  @override
  Future<Session> logIn({required String username, required String password}) {
    // TODO: implement logIn
    throw UnimplementedError();
  }

  @override
  Future<void> logOut({required String sessionId}) {
    // TODO: implement logOut
    throw UnimplementedError();
  }

  @override
  Future<Session> refresh({
    required String refreshToken,
    required String sessionId,
  }) {
    // TODO: implement refresh
    throw UnimplementedError();
  }

  @override
  Future<Session> register({
    required String username,
    required String firstName,
    required String lastName,
    required String password,
    String? patronymic,
    String? description,
  }) {
    // TODO: implement register
    throw UnimplementedError();
  }
}
