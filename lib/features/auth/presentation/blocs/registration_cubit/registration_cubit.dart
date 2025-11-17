import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/core/core.dart';

part 'registration_state.dart';

class RegistrationCubit extends Cubit<RegistrationState> {
  RegistrationCubit({required ILogger logger})
    : _logger = logger,
      super(const RegistrationState());

  final ILogger _logger;

  Future<void> updateFirstName({required String newFirstName}) async {
    try {
      emit(state.copyWith(firstName: newFirstName));
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

  Future<void> updateLastName({required String newLastName}) async {
    try {
      emit(state.copyWith(lastName: newLastName));
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

  Future<void> updateJobPosition({required String newJobPosition}) async {
    try {
      emit(state.copyWith(jobPosition: newJobPosition));
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

  Future<void> updateLogin({required String newLogin}) async {
    try {
      emit(state.copyWith(login: newLogin));
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

  Future<void> updatePassword({required String newPassword}) async {
    try {
      emit(state.copyWith(password: newPassword));
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

  Future<void> updateRepeatPassword({required String newRepeatPassword}) async {
    try {
      emit(state.copyWith(repeatPassword: newRepeatPassword));
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
    final String? jobPosition = state.jobPosition;
    final String? login = state.login;
    final String? password = state.password;
    final String? repeatPassword = state.repeatPassword;

    final bool hasAllFilled =
        firstName != null &&
        firstName.isNotEmpty &&
        lastName != null &&
        lastName.isNotEmpty &&
        jobPosition != null &&
        jobPosition.isNotEmpty &&
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

    return hasAllFilled && passwordsMatch;
  }
}
