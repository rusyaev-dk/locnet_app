part of 'registration_cubit.dart';

final class RegistrationState extends Equatable {
  const RegistrationState({
    this.firstName,
    this.firstNameException,
    this.lastName,
    this.lastNameException,
    this.description,
    this.descriptionException,
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

  final String? description;
  final Object? descriptionException;

  final String? username;
  final Object? usernameException;

  final String? password;
  final Object? passwordException;

  final String? repeatPassword;
  final Object? repeatPasswordException;

  final Object? failure;

  RegistrationState copyWith({
    Object? firstName = _noChange,
    Object? firstNameException = _noChange,
    Object? lastName = _noChange,
    Object? lastNameException = _noChange,
    Object? description = _noChange,
    Object? descriptionException = _noChange,
    Object? username = _noChange,
    Object? usernameException = _noChange,
    Object? password = _noChange,
    Object? passwordException = _noChange,
    Object? repeatPassword = _noChange,
    Object? repeatPasswordException = _noChange,
    Object? failure = _noChange,
  }) {
    return RegistrationState(
      firstName: identical(firstName, _noChange)
          ? this.firstName
          : firstName as String?,
      firstNameException: identical(firstNameException, _noChange)
          ? this.firstNameException
          : firstNameException,
      lastName: identical(lastName, _noChange)
          ? this.lastName
          : lastName as String?,
      lastNameException: identical(lastNameException, _noChange)
          ? this.lastNameException
          : lastNameException,
      description: identical(description, _noChange)
          ? this.description
          : description as String?,
      descriptionException: identical(descriptionException, _noChange)
          ? this.descriptionException
          : descriptionException,
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
      repeatPassword: identical(repeatPassword, _noChange)
          ? this.repeatPassword
          : repeatPassword as String?,
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
    description,
    descriptionException,
    username,
    usernameException,
    password,
    passwordException,
    repeatPassword,
    repeatPasswordException,
    failure,
  ];
}
