part of 'login_cubit.dart';

final class LoginState extends Equatable {
  const LoginState({this.login, this.password, this.failure});

  final String? login;
  final String? password;
  final Object? failure;

  LoginState copyWith({String? login, String? password, Object? failure}) {
    return LoginState(
      login: login ?? this.login,
      password: password ?? this.password,
      failure: failure,
    );
  }

  @override
  List<Object?> get props => [login, password, failure];
}
