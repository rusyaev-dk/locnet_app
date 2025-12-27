import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/auth/domain/domain.dart';

part 'auth_state.dart';

final class AuthCubit extends Cubit<AuthState> {
  AuthCubit({
    required AuthInteractor authInteractor,
    required UserInteractor userInteractor,
    required ILogger logger,
  }) : _authInteractor = authInteractor,
       _userInteractor = userInteractor,
       _logger = logger,
       super(const AuthInitialState()) {
    _restoreOrFetch();
  }

  final AuthInteractor _authInteractor;
  final UserInteractor _userInteractor;
  final ILogger _logger;

  Future<void> logIn({
    required String username,
    required String password,
  }) async {
    try {
      if (state is! AuthLoadingState) {
        emit(const AuthLoadingState());
      }
      _logger.info("Trying to login...");

      final _ = await _authInteractor.logIn();
      final user = await _userInteractor.getCurrentUser();

      emit(AuthAuthenticatedState(user: user));
    } catch (e, st) {
      _logger.exception(e, st);
      emit(
        AuthFailureState(
          failure: e is AppException
              ? e
              : AppUnknownException(message: e.toString(), stackTrace: st),
        ),
      );
    }
  }

  Future<void> register({
    required String firstName,
    required String lastName,
    required String jobPosition,
    required String username,
    required String password,
  }) async {
    try {
      if (state is! AuthLoadingState) {
        emit(const AuthLoadingState());
      }
      _logger.info("Trying to register...");

      // TODO: implement
    } catch (e, st) {
      _logger.exception(e, st);
      emit(
        AuthFailureState(
          failure: e is AppException
              ? e
              : AppUnknownException(message: e.toString(), stackTrace: st),
        ),
      );
    }
  }

  Future<void> _restoreOrFetch() async {
    try {
      if (state is! AuthLoadingState) {
        emit(const AuthLoadingState());
      }
      _logger.info("Trying to restore auth session...");

      // final Session _ = await _authInteractor.logIn();
      // final User user = await _authInteractor.getUser();

      // emit(AuthAuthenticatedState(user: user));
      emit(const AuthUnauthenticatedState());
    } catch (e, st) {
      _logger.exception(e, st);
      emit(
        AuthFailureState(
          failure: e is AppException
              ? e
              : AppUnknownException(message: e.toString(), stackTrace: st),
        ),
      );
    }
  }

  Future<void> logOut() async {
    try {
      await _authInteractor.logOut();
      emit(const AuthUnauthenticatedState());
    } catch (e, st) {
      _logger.exception(e, st);
      emit(const AuthUnauthenticatedState());
    }
  }
}
