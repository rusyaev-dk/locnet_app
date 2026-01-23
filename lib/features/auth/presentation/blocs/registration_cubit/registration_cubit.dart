import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/auth/domain/domain.dart';

part 'registration_state.dart';

class RegistrationCubit extends Cubit<RegistrationState> {
  RegistrationCubit({required ILogger logger})
    : _logger = logger,
      super(const RegistrationState());

  final ILogger _logger;

  Future<void> updateFirstName({String? newFirstName}) async {
    try {
      if (newFirstName == null || newFirstName.trim().isEmpty) {
        emit(
          state.copyWith(
            firstName: null,
            firstNameException: RequiredValueNotProvidedException(
              message: "Firstname cannot be empty",
            ),
          ),
        );
        return;
      }

      try {
        ProfileDataValidator.validateName(newFirstName);
      } catch (e) {
        emit(state.copyWith(firstName: newFirstName, firstNameException: e));
        return;
      }

      emit(state.copyWith(firstName: newFirstName, firstNameException: null));
    } catch (e, st) {
      _logger.exception(e, st);

      emit(
        state.copyWith(
          failure: e is AppException
              ? e
              : AppUnknownException(message: e.toString(), stackTrace: st),
        ),
      );
    }
  }

  Future<void> updateLastName({String? newLastName}) async {
    try {
      if (newLastName == null || newLastName.trim().isEmpty) {
        emit(
          state.copyWith(
            lastName: null,
            lastNameException: RequiredValueNotProvidedException(
              message: "Lastname cannot be empty",
            ),
          ),
        );
        return;
      }

      try {
        ProfileDataValidator.validateName(newLastName);
      } catch (e) {
        emit(state.copyWith(lastName: newLastName, lastNameException: e));
        return;
      }

      emit(state.copyWith(lastName: newLastName, lastNameException: null));
    } catch (e, st) {
      _logger.exception(e, st);

      emit(
        state.copyWith(
          failure: e is AppException
              ? e
              : AppUnknownException(message: e.toString(), stackTrace: st),
        ),
      );
    }
  }

  Future<void> updateDescription({String? newUserDescription}) async {
    try {
      if (newUserDescription == null || newUserDescription.trim().isEmpty) {
        emit(state.copyWith(description: null, descriptionException: null));
        return;
      }

      try {
        ProfileDataValidator.validateUserDescription(newUserDescription);
      } catch (e) {
        return emit(
          state.copyWith(
            description: newUserDescription,
            descriptionException: e,
          ),
        );
      }

      emit(
        state.copyWith(
          description: newUserDescription,
          descriptionException: null,
        ),
      );
    } catch (e, st) {
      _logger.exception(e, st);

      emit(
        state.copyWith(
          failure: e is AppException
              ? e
              : AppUnknownException(message: e.toString(), stackTrace: st),
        ),
      );
    }
  }

  Future<void> updateUsername({String? newUsername}) async {
    try {
      if (newUsername == null || newUsername.trim().isEmpty) {
        emit(
          state.copyWith(
            username: null,
            usernameException: RequiredValueNotProvidedException(
              message: "Username cannot be empty",
            ),
          ),
        );
        return;
      }

      try {
        ProfileDataValidator.validateUsername(newUsername);
      } catch (e) {
        emit(state.copyWith(username: newUsername, usernameException: e));
        return;
      }

      emit(state.copyWith(username: newUsername, usernameException: null));
    } catch (e, st) {
      _logger.exception(e, st);

      emit(
        state.copyWith(
          failure: e is AppException
              ? e
              : AppUnknownException(message: e.toString(), stackTrace: st),
        ),
      );
    }
  }

  Future<void> updatePassword({String? newPassword}) async {
    try {
      if (newPassword == null || newPassword.trim().isEmpty) {
        emit(
          state.copyWith(
            password: null,
            passwordException: RequiredValueNotProvidedException(
              message: "Password cannot be empty",
            ),
          ),
        );
        return;
      }

      final String? repeatPassword = state.repeatPassword;
      final String firstPasswordInput = newPassword;

      if (repeatPassword != null &&
          repeatPassword.isNotEmpty &&
          repeatPassword.length >= firstPasswordInput.length &&
          repeatPassword != firstPasswordInput) {
        emit(
          state.copyWith(
            password: newPassword,
            repeatPasswordException: PasswordsMismatchException(
              message: "Passwords don't match",
            ),
          ),
        );
        return;
      }

      if (repeatPassword != null &&
          repeatPassword.isNotEmpty &&
          repeatPassword == firstPasswordInput) {
        emit(
          state.copyWith(
            password: newPassword,
            repeatPasswordException: null,
            passwordException: null,
          ),
        );
        return;
      }

      try {
        PasswordValidator.validatePassword(newPassword);
      } catch (e) {
        emit(state.copyWith(password: newPassword, passwordException: e));
        return;
      }

      emit(state.copyWith(password: newPassword, passwordException: null));
    } catch (e, st) {
      _logger.exception(e, st);

      emit(
        state.copyWith(
          failure: e is AppException
              ? e
              : AppUnknownException(message: e.toString(), stackTrace: st),
        ),
      );
    }
  }

  Future<void> updateRepeatPassword({String? newRepeatPassword}) async {
    try {
      if (newRepeatPassword == null || newRepeatPassword.trim().isEmpty) {
        emit(
          state.copyWith(
            repeatPassword: null,
            repeatPasswordException: RequiredValueNotProvidedException(
              message: "Repeat password cannot be empty",
            ),
          ),
        );
        return;
      }

      try {
        final String? firstPassword = state.password;
        final String repeatPasswordInput = newRepeatPassword;

        if (firstPassword == null || firstPassword.isEmpty) {
          throw PasswordsMismatchException(
            message: "Passwords don't match",
            stackTrace: StackTrace.current,
          );
        }

        if (firstPassword.isNotEmpty &&
            (firstPassword.length != repeatPasswordInput.length ||
                firstPassword != repeatPasswordInput)) {
          throw PasswordsMismatchException(
            message: "Passwords don't match",
            stackTrace: StackTrace.current,
          );
        }
      } catch (e) {
        emit(
          state.copyWith(
            repeatPassword: newRepeatPassword,
            repeatPasswordException: e,
          ),
        );
        return;
      }

      emit(
        state.copyWith(
          repeatPassword: newRepeatPassword,
          repeatPasswordException: null,
        ),
      );
    } catch (e, st) {
      _logger.exception(e, st);

      emit(
        state.copyWith(
          failure: e is AppException
              ? e
              : AppUnknownException(message: e.toString(), stackTrace: st),
        ),
      );
    }
  }

  bool canRegister() {
    final String? firstName = state.firstName;
    final String? lastName = state.lastName;
    final String? description = state.description;
    final String? login = state.username;
    final String? password = state.password;
    final String? repeatPassword = state.repeatPassword;

    final bool hasAllFilled =
        firstName != null &&
        firstName.isNotEmpty &&
        lastName != null &&
        lastName.isNotEmpty &&
        description != null &&
        description.isNotEmpty &&
        login != null &&
        login.isNotEmpty &&
        password != null &&
        password.isNotEmpty &&
        repeatPassword != null &&
        repeatPassword.isNotEmpty;

    final bool passwordsMatch =
        password != null &&
        repeatPassword != null &&
        password == repeatPassword;

    final bool hasNoFieldExceptions =
        state.firstNameException == null &&
        state.lastNameException == null &&
        state.descriptionException == null &&
        state.usernameException == null &&
        state.passwordException == null &&
        state.repeatPasswordException == null;

    return hasAllFilled && passwordsMatch && hasNoFieldExceptions;
  }
}
