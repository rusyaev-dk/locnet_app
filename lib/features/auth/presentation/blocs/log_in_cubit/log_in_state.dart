part of 'log_in_cubit.dart';

final class LogInState extends Equatable {
  const LogInState({
    this.username,
    this.usernameException,
    this.password,
    this.passwordException,
    this.failure,
  });

  static const Object _noChange = Object();

  final String? username;
  final Object? usernameException;

  final String? password;
  final Object? passwordException;

  final Object? failure;

  LogInState copyWith({
    Object? username = _noChange,
    Object? usernameException = _noChange,
    Object? password = _noChange,
    Object? passwordException = _noChange,
    Object? failure = _noChange,
  }) {
    return LogInState(
      username: identical(username, _noChange)
          ? this.username
          : username as String?,
      usernameException: identical(usernameException, _noChange)
          ? this.usernameException
          : usernameException,
      password: identical(password, _noChange)
          ? this.password
          : password as String?,
      passwordException: identical(passwordException, _noChange)
          ? this.passwordException
          : passwordException,
      failure: identical(failure, _noChange) ? this.failure : failure,
    );
  }

  @override
  List<Object?> get props => <Object?>[
    username,
    usernameException,
    password,
    passwordException,
    failure,
  ];
}
