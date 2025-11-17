part of 'registration_cubit.dart';

final class RegistrationState extends Equatable {
  const RegistrationState({
    this.firstName,
    this.lastName,
    this.jobPosition,
    this.login,
    this.password,
    this.repeatPassword,
    this.failure,
  });

  final String? firstName;
  final String? lastName;
  final String? jobPosition;
  final String? login;
  final String? password;
  final String? repeatPassword;
  final Object? failure;

  RegistrationState copyWith({
    String? firstName,
    String? lastName,
    String? jobPosition,
    String? login,
    String? password,
    String? repeatPassword,
    Object? failure,
  }) {
    return RegistrationState(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      jobPosition: jobPosition ?? this.jobPosition,
      login: login ?? this.login,
      password: password ?? this.password,
      repeatPassword: repeatPassword ?? this.repeatPassword,
      failure: failure,
    );
  }

  @override
  List<Object?> get props => <Object?>[
        firstName,
        lastName,
        jobPosition,
        login,
        password,
        repeatPassword,
        failure,
      ];
}
