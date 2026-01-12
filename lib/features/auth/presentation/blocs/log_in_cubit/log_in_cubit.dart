import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/core/core.dart';

part 'log_in_state.dart';

class LogInCubit extends Cubit<LogInState> {
  LogInCubit({required ILogger logger})
    : _logger = logger,
      super(const LogInState());

  final ILogger _logger;

  Future<void> updateUsername({String? updatedUsername}) async {
    try {
      if (updatedUsername == null || updatedUsername.isEmpty) {
        emit(
          state.copyWith(
            username: updatedUsername,
            usernameException: EmptyFieldException(
              message: "Username can not be empty",
            ),
          ),
        );
        return;
      }

      emit(state.copyWith(username: updatedUsername, usernameException: null));
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

  Future<void> updatePassword({String? updatedPassword}) async {
    try {
      if (updatedPassword == null || updatedPassword.isEmpty) {
        emit(
          state.copyWith(
            password: updatedPassword,
            passwordException: EmptyFieldException(
              message: "Password can not be empty",
            ),
          ),
        );
        return;
      }

      emit(state.copyWith(password: updatedPassword, passwordException: null));
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

  bool canLogIn() {
    final String? username = state.username;
    final String? password = state.password;

    final bool hasAllFilled =
        username != null &&
        username.isNotEmpty &&
        password != null &&
        password.isNotEmpty;

    final bool hasNoFieldExceptions =
        state.usernameException == null && state.passwordException == null;

    return hasAllFilled && hasNoFieldExceptions;
  }
}
