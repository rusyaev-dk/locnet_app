part of 'registration_cubit.dart';

final class RegistrationState extends Equatable {
  const RegistrationState({
    this.firstName,
    this.firstNameException,
    this.lastName,
    this.lastNameException,
    this.jobPosition,
    this.jobPositionException,
    this.username,
    this.usernameException,
    this.password,
    this.passwordException,
    this.repeatPassword,
    this.repeatPasswordException,
    this.failure,
  });

  static const Object _noChange = Object();

  final String? firstName;
  final Object? firstNameException;

  final String? lastName;
  final Object? lastNameException;

  final String? jobPosition;
  final Object? jobPositionException;

  final String? username;
  final Object? usernameException;

  final String? password;
  final Object? passwordException;

  final String? repeatPassword;
  final Object? repeatPasswordException;

  final Object? failure;

  RegistrationState copyWith({
    String? firstName,
    Object? firstNameException = _noChange,
    String? lastName,
    Object? lastNameException = _noChange,
    String? jobPosition,
    Object? jobPositionException = _noChange,
    String? username,
    Object? usernameException = _noChange,
    String? password,
    Object? passwordException = _noChange,
    String? repeatPassword,
    Object? repeatPasswordException = _noChange,
    Object? failure = _noChange,
  }) {
    return RegistrationState(
      firstName: firstName ?? this.firstName,
      firstNameException: identical(firstNameException, _noChange)
          ? this.firstNameException
          : firstNameException,
      lastName: lastName ?? this.lastName,
      lastNameException: identical(lastNameException, _noChange)
          ? this.lastNameException
          : lastNameException,
      jobPosition: jobPosition ?? this.jobPosition,
      jobPositionException: identical(jobPositionException, _noChange)
          ? this.jobPositionException
          : jobPositionException,
      username: username ?? this.username,
      usernameException: identical(usernameException, _noChange)
          ? this.usernameException
          : usernameException,
      password: password ?? this.password,
      passwordException: identical(passwordException, _noChange)
          ? this.passwordException
          : passwordException,
      repeatPassword: repeatPassword ?? this.repeatPassword,
      repeatPasswordException: identical(repeatPasswordException, _noChange)
          ? this.repeatPasswordException
          : repeatPasswordException,
      failure: identical(failure, _noChange) ? this.failure : failure,
    );
  }

  @override
  List<Object?> get props => <Object?>[
        firstName,
        firstNameException,
        lastName,
        lastNameException,
        jobPosition,
        jobPositionException,
        username,
        usernameException,
        password,
        passwordException,
        repeatPassword,
        repeatPasswordException,
        failure,
      ];
}
