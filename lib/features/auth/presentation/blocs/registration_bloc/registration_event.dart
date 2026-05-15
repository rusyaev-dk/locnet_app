part of 'registration_bloc.dart';

sealed class RegistrationEvent extends Equatable {
  const RegistrationEvent();

  @override
  List<Object?> get props => <Object?>[];
}

final class RegistrationFirstNameUpdated extends RegistrationEvent {
  const RegistrationFirstNameUpdated({required this.newFirstName});

  final String? newFirstName;

  @override
  List<Object?> get props => <Object?>[newFirstName];
}

final class RegistrationLastNameUpdated extends RegistrationEvent {
  const RegistrationLastNameUpdated({required this.newLastName});

  final String? newLastName;

  @override
  List<Object?> get props => <Object?>[newLastName];
}

final class RegistrationDescriptionUpdated extends RegistrationEvent {
  const RegistrationDescriptionUpdated({required this.newUserDescription});

  final String? newUserDescription;

  @override
  List<Object?> get props => <Object?>[newUserDescription];
}

final class RegistrationUsernameUpdated extends RegistrationEvent {
  const RegistrationUsernameUpdated({required this.newUsername});

  final String? newUsername;

  @override
  List<Object?> get props => <Object?>[newUsername];
}

final class RegistrationPasswordUpdated extends RegistrationEvent {
  const RegistrationPasswordUpdated({required this.newPassword});

  final String? newPassword;

  @override
  List<Object?> get props => <Object?>[newPassword];
}

final class RegistrationRepeatPasswordUpdated extends RegistrationEvent {
  const RegistrationRepeatPasswordUpdated({required this.newRepeatPassword});

  final String? newRepeatPassword;

  @override
  List<Object?> get props => <Object?>[newRepeatPassword];
}
