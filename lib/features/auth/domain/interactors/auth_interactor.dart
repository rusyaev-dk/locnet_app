import 'package:locnet_app/core/domain/domain.dart';
import 'package:locnet_app/features/auth/domain/domain.dart';

final class AuthInteractor {
  AuthInteractor();

  Future<bool> hasValidSession() async {
    throw UnimplementedError();
  }

  Future<Session> getCachedSession() async {
    throw UnimplementedError();
  }

  Future<User> getCachedUser() async {
    throw UnimplementedError();
  }

  Future<(Session, User)> logIn() async {
    throw UnimplementedError();
  }

  Future<void> logOut() async {
    throw UnimplementedError();
  }
}
