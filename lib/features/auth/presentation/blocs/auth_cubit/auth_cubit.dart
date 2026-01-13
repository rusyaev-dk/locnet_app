import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/auth/domain/domain.dart';

part 'auth_state.dart';

final class AuthCubit extends Cubit<AuthState> {
  AuthCubit({required AuthInteractor authInteractor, required ILogger logger})
    : _authInteractor = authInteractor,
      _logger = logger,
      super(const AuthInitialState());

  final AuthInteractor _authInteractor;
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

      final result = await _authInteractor.logIn(
        username: username,
        password: password,
      );
      final user = result.$2;

      _logger.info("LogIn successful");
      emit(AuthAuthenticatedState(user: user));
    } catch (e, st) {
      _logger.exception("LogIn failed: $e", st);
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
    required String username,
    required String password,
    String? description,
  }) async {
    try {
      if (state is! AuthLoadingState) {
        emit(const AuthLoadingState());
      }
      _logger.info("Trying to register new user...");

      final res = await _authInteractor.register(
        username: username,
        firstName: firstName,
        lastName: lastName,
        password: password,
        description: description,
      );

      _logger.info("Registration successful");
      emit(AuthAuthenticatedState(user: res.$2));
    } catch (e, st) {
      _logger.exception("Register failed: $e", st);
      emit(
        AuthFailureState(
          failure: e is AppException
              ? e
              : AppUnknownException(message: e.toString(), stackTrace: st),
        ),
      );
    }
  }

  Future<void> tryRestoreSession() async {
    try {
      if (state is! AuthLoadingState) {
        emit(const AuthLoadingState());
      }

      _logger.info("Trying to restore session...");
      final (Session, User)? restored = await _authInteractor.restoreSession();

      if (restored == null) {
        emit(const AuthUnauthenticatedState());
        return;
      }

      emit(AuthAuthenticatedState(user: restored.$2));
    } catch (e, st) {
      _logger.exception("Restore session failed: $e", st);
      emit(const AuthUnauthenticatedState());
    }
  }

  Future<void> logOut() async {
    try {
      _logger.info("LogOut...");
      await _authInteractor.logOut();
      emit(const AuthUnauthenticatedState());
    } catch (e, st) {
      _logger.exception(e, st);
      emit(const AuthUnauthenticatedState());
    }
  }
}
