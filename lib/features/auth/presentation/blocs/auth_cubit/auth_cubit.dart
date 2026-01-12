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
       super(const AuthInitialState());

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

      final result = await _authInteractor.logIn(
        username: username,
        password: password,
      );
      final user = result.$2;

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

      emit(AuthAuthenticatedState(user: res.$2));
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

  Future<void> checkSessionValidation() async {
    try {
      if (state is! AuthLoadingState) {
        emit(const AuthLoadingState());
      }
      _logger.info("Checking session validation...");

      final isSessionFresh = await _authInteractor
          .checkCachedSessionFreshness();
      if (!isSessionFresh) {
        emit(const AuthUnauthenticatedState());
      }

      final cachedSession = await _authInteractor.getCachedSession();
      final user = await _userInteractor.getUserById(
        userId: cachedSession.userId,
      );

      emit(AuthAuthenticatedState(user: user));
    } catch (e, st) {
      _logger.exception(e, st);
      emit(const AuthUnauthenticatedState());
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
