part of 'profile_editor_cubit.dart';

final class ProfileEditorState extends Equatable {
  const ProfileEditorState({
    this.user,
    this.isLoading = true,
    this.isEditing = false,
    this.isSubmitting = false,
    this.firstName,
    this.firstNameException,
    this.lastName,
    this.lastNameException,
    this.username,
    this.usernameException,
    this.description,
    this.failure,
  });

  static const Object _noChange = Object();

  final User? user;
  final bool isLoading;
  final bool isEditing;
  final bool isSubmitting;
  final String? firstName;
  final Object? firstNameException;
  final String? lastName;
  final Object? lastNameException;
  final String? username;
  final Object? usernameException;
  final String? description;
  final Object? failure;

  ProfileEditorState copyWith({
    Object? user = _noChange,
    Object? isLoading = _noChange,
    Object? isEditing = _noChange,
    Object? isSubmitting = _noChange,
    Object? firstName = _noChange,
    Object? firstNameException = _noChange,
    Object? lastName = _noChange,
    Object? lastNameException = _noChange,
    Object? username = _noChange,
    Object? usernameException = _noChange,
    Object? description = _noChange,
    Object? failure = _noChange,
  }) {
    return ProfileEditorState(
      user: identical(user, _noChange) ? this.user : user as User?,
      isLoading: identical(isLoading, _noChange)
          ? this.isLoading
          : isLoading as bool,
      isEditing: identical(isEditing, _noChange)
          ? this.isEditing
          : isEditing as bool,
      isSubmitting: identical(isSubmitting, _noChange)
          ? this.isSubmitting
          : isSubmitting as bool,
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
      username: identical(username, _noChange)
          ? this.username
          : username as String?,
      usernameException: identical(usernameException, _noChange)
          ? this.usernameException
          : usernameException,
      description: identical(description, _noChange)
          ? this.description
          : description as String?,
      failure: identical(failure, _noChange) ? this.failure : failure,
    );
  }

  @override
  List<Object?> get props => <Object?>[
    user,
    isLoading,
    isEditing,
    isSubmitting,
    firstName,
    firstNameException,
    lastName,
    lastNameException,
    username,
    usernameException,
    description,
    failure,
  ];
}
