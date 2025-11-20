import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/auth/domain/domain.dart';
import 'package:locnet_app/features/profile/domain/domain.dart';

part 'profile_editor_state.dart';

class ProfileEditorCubit extends Cubit<ProfileEditorState> {
  ProfileEditorCubit({
    required ProfileInteractor profileInteractor,
    required ILogger logger,
  })  : _profileInteractor = profileInteractor,
        _logger = logger,
        super(const ProfileEditorInitialState());

  final ProfileInteractor _profileInteractor;
  final ILogger _logger;

  Future<void> updateFirstName({String? newFirstName}) async {
    try {
      if (state is! ProfileEditorLoadedState) {
        return;
      }

      final ProfileEditorLoadedState prevState =
          state as ProfileEditorLoadedState;

      if (newFirstName == null || newFirstName.isEmpty) {
        emit(
          prevState.copyWith(
            newFirstName: newFirstName,
            firstNameException: RegistrationEmptyFieldException(
              message: "First name can not be empty",
            ),
          ),
        );
        return;
      }

      try {
        ProfileDataFormatter.validateName(newFirstName);
      } catch (e) {
        emit(
          prevState.copyWith(
            newFirstName: newFirstName,
            firstNameException: e,
          ),
        );
        return;
      }

      emit(
        prevState.copyWith(
          newFirstName: newFirstName,
          firstNameException: null,
        ),
      );
    } catch (e, st) {
      _logger.exception(e, st);

      emit(
        ProfileEditorFailureState(
          failure: e is AppException
              ? e
              : AppUnknownException(
                  message: e.toString(),
                  stackTrace: st,
                ),
        ),
      );
    }
  }

  Future<void> updateLastName({String? newLastName}) async {
    try {
      if (state is! ProfileEditorLoadedState) {
        return;
      }

      final ProfileEditorLoadedState prevState =
          state as ProfileEditorLoadedState;

      if (newLastName == null || newLastName.isEmpty) {
        emit(
          prevState.copyWith(
            newLastName: newLastName,
            lastNameException: RegistrationEmptyFieldException(
              message: "Last name can not be empty",
            ),
          ),
        );
        return;
      }

      try {
        ProfileDataFormatter.validateName(newLastName);
      } catch (e) {
        emit(
          prevState.copyWith(
            newLastName: newLastName,
            lastNameException: e,
          ),
        );
        return;
      }

      emit(
        prevState.copyWith(
          newLastName: newLastName,
          lastNameException: null,
        ),
      );
    } catch (e, st) {
      _logger.exception(e, st);

      emit(
        ProfileEditorFailureState(
          failure: e is AppException
              ? e
              : AppUnknownException(
                  message: e.toString(),
                  stackTrace: st,
                ),
        ),
      );
    }
  }

  Future<void> updateUsername({String? newUsername}) async {
    try {
      if (state is! ProfileEditorLoadedState) {
        return;
      }

      final ProfileEditorLoadedState prevState =
          state as ProfileEditorLoadedState;

      if (newUsername == null || newUsername.isEmpty) {
        emit(
          prevState.copyWith(
            newUsername: newUsername,
            usernameException: RegistrationEmptyFieldException(
              message: "Username can not be empty",
            ),
          ),
        );
        return;
      }

      try {
        ProfileDataFormatter.validateUsername(newUsername);
      } catch (e) {
        emit(
          prevState.copyWith(
            newUsername: newUsername,
            usernameException: e,
          ),
        );
        return;
      }

      emit(
        prevState.copyWith(
          newUsername: newUsername,
          usernameException: null,
        ),
      );
    } catch (e, st) {
      _logger.exception(e, st);

      emit(
        ProfileEditorFailureState(
          failure: e is AppException
              ? e
              : AppUnknownException(
                  message: e.toString(),
                  stackTrace: st,
                ),
        ),
      );
    }
  }

  Future<void> resetUpdates() async {
  try {
    if (state is! ProfileEditorLoadedState) {
      return;
    }

    final ProfileEditorLoadedState prevState =
        state as ProfileEditorLoadedState;

    emit(
      prevState.copyWith(
        newFirstName: null,
        firstNameException: null,
        newLastName: null,
        lastNameException: null,
        newUsername: null,
        usernameException: null,
        failure: null,
      ),
    );
  } catch (e, st) {
    _logger.exception(e, st);

    emit(
      ProfileEditorFailureState(
        failure: e is AppException
            ? e
            : AppUnknownException(
                message: e.toString(),
                stackTrace: st,
              ),
      ),
    );
  }
}


  bool canApplyUpdates() {
    if (state is! ProfileEditorLoadedState) {
      return false;
    }

    final ProfileEditorLoadedState currentState =
        state as ProfileEditorLoadedState;

    final String effectiveFirstName =
        currentState.newFirstName ?? currentState.initialUser.firstName;
    final String effectiveLastName =
        currentState.newLastName ?? currentState.initialUser.lastName;
    final String effectiveUsername =
        currentState.newUsername ?? currentState.initialUser.username;

    final bool hasAllFilled =
        effectiveFirstName.isNotEmpty &&
        effectiveLastName.isNotEmpty &&
        effectiveUsername.isNotEmpty;

    final bool hasNoFieldExceptions =
        currentState.firstNameException == null &&
        currentState.lastNameException == null &&
        currentState.usernameException == null;

    return hasAllFilled && hasNoFieldExceptions;
  }

  Future<void> applyUpdates() async {
    try {
      if (state is! ProfileEditorLoadedState) {
        return;
      }

      final ProfileEditorLoadedState prevState =
          state as ProfileEditorLoadedState;

      if (!canApplyUpdates()) {
        return;
      }

      emit(const ProfileEditorPendingState());

      // TODO: remove the delay
      await Future<void>.delayed(const Duration(milliseconds: 4000));

      final User updatedUser = prevState.initialUser.copyWith(
        firstName: prevState.newFirstName ?? prevState.initialUser.firstName,
        lastName: prevState.newLastName ?? prevState.initialUser.lastName,
        username: prevState.newUsername ?? prevState.initialUser.username,
      );

      await _profileInteractor.udpateUserData(updatedUser: updatedUser);

      emit(const ProfileEditorSuccessState());
      emit(const ProfileEditorInitialState());
    } catch (e, st) {
      _logger.exception(e, st);

      emit(
        ProfileEditorFailureState(
          failure: e is AppException
              ? e
              : AppUnknownException(
                  message: e.toString(),
                  stackTrace: st,
                ),
        ),
      );
    }
  }

  Future<void> loadUserData() async {
    try {
      if (state is! ProfileEditorLoadingState) {
        emit(const ProfileEditorLoadingState());
      }

      final User user = await _profileInteractor.loadUserData();

      emit(ProfileEditorLoadedState(initialUser: user));
    } catch (e, st) {
      _logger.exception(e, st);

      emit(
        ProfileEditorFailureState(
          failure: e is AppException
              ? e
              : AppUnknownException(
                  message: e.toString(),
                  stackTrace: st,
                ),
        ),
      );
    }
  }
}
