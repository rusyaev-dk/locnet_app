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
    String? username,
    Object? usernameException = _noChange,
    String? password,
    Object? passwordException = _noChange,
    Object? failure = _noChange,
  }) {
    return LogInState(
      username: username ?? this.username,
      usernameException: identical(usernameException, _noChange)
          ? this.usernameException
          : usernameException,
      password: password ?? this.password,
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
