import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/auth/domain/domain.dart';
import 'package:locnet_app/features/auth/presentation/presentation.dart';
import 'package:locnet_app/features/settings/subfeatures/profile/domain/profile_interactor.dart';

part 'profile_editor_state.dart';

class ProfileEditorCubit extends Cubit<ProfileEditorState> {
  ProfileEditorCubit({
    required ProfileInteractor profileInteractor,
    required AuthInteractor authInteractor,
    required AuthCubit authCubit,
    required ILogger logger,
  }) : _profileInteractor = profileInteractor,
       _authInteractor = authInteractor,
       _authCubit = authCubit,
       _logger = logger,
       super(const ProfileEditorState());

  final ProfileInteractor _profileInteractor;
  final AuthInteractor _authInteractor;
  final AuthCubit _authCubit;
  final ILogger _logger;

  Future<void> loadProfile() async {
    emit(state.copyWith(isLoading: true, failure: null));
    try {
      final User loadedUser = await _profileInteractor.loadUserData();
      emit(
        state.copyWith(
          isLoading: false,
          user: loadedUser,
          isEditing: false,
          isSubmitting: false,
          firstName: loadedUser.firstName,
          lastName: loadedUser.lastName,
          username: loadedUser.username,
          description: loadedUser.description ?? '',
          firstNameException: null,
          lastNameException: null,
          usernameException: null,
          failure: null,
        ),
      );
    } catch (e, st) {
      _logger.exception(e, st);
      final AppException appException = e is AppException
          ? e
          : AppUnknownException(
              message: e.toString(),
              error: e,
              stackTrace: st,
            );
      emit(state.copyWith(isLoading: false, failure: appException));
    }
  }

  void startEditing() {
    final User? user = state.user;
    if (user == null) return;
    emit(
      state.copyWith(
        isEditing: true,
        firstName: user.firstName,
        lastName: user.lastName,
        username: user.username,
        description: user.description ?? '',
        firstNameException: null,
        lastNameException: null,
        usernameException: null,
        failure: null,
      ),
    );
  }

  void cancelEditing() {
    final User? user = state.user;
    if (user == null) return;
    emit(
      state.copyWith(
        isEditing: false,
        isSubmitting: false,
        firstName: user.firstName,
        lastName: user.lastName,
        username: user.username,
        description: user.description ?? '',
        firstNameException: null,
        lastNameException: null,
        usernameException: null,
        failure: null,
      ),
    );
  }

  void updateFirstName({required String? value}) {
    try {
      final String normalized = value?.trim() ?? '';
      if (normalized.isEmpty) {
        emit(
          state.copyWith(
            firstName: normalized,
            firstNameException: RequiredValueNotProvidedException(
              message: 'Firstname cannot be empty',
            ),
          ),
        );
        return;
      }
      try {
        ProfileDataValidator.validateName(normalized);
      } catch (e) {
        emit(state.copyWith(firstName: normalized, firstNameException: e));
        return;
      }
      emit(state.copyWith(firstName: normalized, firstNameException: null));
    } catch (e, st) {
      _emitUnknownFailure(error: e, stackTrace: st);
    }
  }

  void updateLastName({required String? value}) {
    try {
      final String normalized = value?.trim() ?? '';
      if (normalized.isEmpty) {
        emit(
          state.copyWith(
            lastName: normalized,
            lastNameException: RequiredValueNotProvidedException(
              message: 'Lastname cannot be empty',
            ),
          ),
        );
        return;
      }
      try {
        ProfileDataValidator.validateName(normalized);
      } catch (e) {
        emit(state.copyWith(lastName: normalized, lastNameException: e));
        return;
      }
      emit(state.copyWith(lastName: normalized, lastNameException: null));
    } catch (e, st) {
      _emitUnknownFailure(error: e, stackTrace: st);
    }
  }

  void updateUsername({required String? value}) {
    try {
      final String normalized = value?.trim() ?? '';
      if (normalized.isEmpty) {
        emit(
          state.copyWith(
            username: normalized,
            usernameException: RequiredValueNotProvidedException(
              message: 'Username cannot be empty',
            ),
          ),
        );
        return;
      }
      try {
        ProfileDataValidator.validateUsername(normalized);
      } catch (e) {
        emit(state.copyWith(username: normalized, usernameException: e));
        return;
      }
      emit(state.copyWith(username: normalized, usernameException: null));
    } catch (e, st) {
      _emitUnknownFailure(error: e, stackTrace: st);
    }
  }

  void updateDescription({required String? value}) {
    emit(state.copyWith(description: value?.trim() ?? ''));
  }

  Future<void> submitChanges() async {
    final User? currentUser = state.user;
    if (currentUser == null || state.isSubmitting) return;

    final String firstName = (state.firstName ?? '').trim();
    final String lastName = (state.lastName ?? '').trim();
    final String username = (state.username ?? '').trim();
    final String description = (state.description ?? '').trim();

    updateFirstName(value: firstName);
    updateLastName(value: lastName);
    updateUsername(value: username);

    if (state.firstNameException != null ||
        state.lastNameException != null ||
        state.usernameException != null) {
      return;
    }

    emit(state.copyWith(isSubmitting: true, failure: null));
    try {
      if (username != currentUser.username) {
        final bool isAvailable = await _authInteractor.validateRegisterLogin(
          login: username,
        );
        if (!isAvailable) {
          emit(
            state.copyWith(
              isSubmitting: false,
              usernameException: AuthLoginAlreadyTakenException(
                message: 'Username already taken',
              ),
            ),
          );
          return;
        }
      }

      final User updatedUser = currentUser.copyWith(
        firstName: firstName,
        lastName: lastName,
        username: username,
        description: description.isEmpty ? null : description,
      );
      final User savedUser = await _profileInteractor.udpateUserData(
        updatedUser: updatedUser,
      );
      await _authCubit.syncAuthenticatedUser(savedUser);
      emit(
        state.copyWith(
          user: savedUser,
          firstName: savedUser.firstName,
          lastName: savedUser.lastName,
          username: savedUser.username,
          description: savedUser.description ?? '',
          isEditing: false,
          isSubmitting: false,
          firstNameException: null,
          lastNameException: null,
          usernameException: null,
          failure: null,
        ),
      );
    } catch (e, st) {
      _logger.exception(e, st);
      final AppException appException = e is AppException
          ? e
          : AppUnknownException(
              message: e.toString(),
              error: e,
              stackTrace: st,
            );
      emit(state.copyWith(isSubmitting: false, failure: appException));
    }
  }

  void _emitUnknownFailure({
    required Object error,
    required StackTrace stackTrace,
  }) {
    _logger.exception(error, stackTrace);
    final AppException appException = error is AppException
        ? error
        : AppUnknownException(
            message: error.toString(),
            error: error,
            stackTrace: stackTrace,
          );
    emit(state.copyWith(failure: appException));
  }
}
