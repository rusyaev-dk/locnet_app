part of 'profile_editor_cubit.dart';

sealed class ProfileEditorState extends Equatable {
  const ProfileEditorState({this.failure});

  final Object? failure;
}

final class ProfileEditorInitialState extends ProfileEditorState {
  const ProfileEditorInitialState({super.failure});

  @override
  List<Object?> get props => <Object?>[failure];
}

final class ProfileEditorLoadingState extends ProfileEditorState {
  const ProfileEditorLoadingState({super.failure});

  @override
  List<Object?> get props => <Object?>[failure];
}

final class ProfileEditorLoadedState extends ProfileEditorState {
  const ProfileEditorLoadedState({
    required this.initialUser,
    this.newFirstName,
    this.firstNameException,
    this.newLastName,
    this.lastNameException,
    this.newUsername,
    this.usernameException,
    super.failure,
  });

  static const Object _noChange = Object();

  final User initialUser;

  final String? newFirstName;
  final Object? firstNameException;

  final String? newLastName;
  final Object? lastNameException;

  final String? newUsername;
  final Object? usernameException;

  ProfileEditorLoadedState copyWith({
    User? initialUser,
    String? newFirstName,
    Object? firstNameException = _noChange,
    String? newLastName,
    Object? lastNameException = _noChange,
    String? newUsername,
    Object? usernameException = _noChange,
    Object? failure = _noChange,
  }) {
    return ProfileEditorLoadedState(
      initialUser: initialUser ?? this.initialUser,
      newFirstName: newFirstName ?? this.newFirstName,
      firstNameException: identical(firstNameException, _noChange)
          ? this.firstNameException
          : firstNameException,
      newLastName: newLastName ?? this.newLastName,
      lastNameException: identical(lastNameException, _noChange)
          ? this.lastNameException
          : lastNameException,
      newUsername: newUsername ?? this.newUsername,
      usernameException: identical(usernameException, _noChange)
          ? this.usernameException
          : usernameException,
      failure: identical(failure, _noChange) ? this.failure : failure,
    );
  }

  @override
  List<Object?> get props => <Object?>[
        initialUser,
        newFirstName,
        firstNameException,
        newLastName,
        lastNameException,
        newUsername,
        usernameException,
        failure,
      ];
}

final class ProfileEditorPendingState extends ProfileEditorState {
  const ProfileEditorPendingState({super.failure});

  @override
  List<Object?> get props => <Object?>[failure];
}

final class ProfileEditorSuccessState extends ProfileEditorState {
  const ProfileEditorSuccessState({super.failure});

  @override
  List<Object?> get props => <Object?>[failure];
}

final class ProfileEditorFailureState extends ProfileEditorState {
  const ProfileEditorFailureState({required super.failure});

  @override
  List<Object?> get props => <Object?>[failure];
}
