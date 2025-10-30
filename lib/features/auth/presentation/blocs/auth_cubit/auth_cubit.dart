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
      super(const AuthInitialState(message: null)) {
    _restoreOrFetch();
  }

  final AuthInteractor _authInteractor;
  final ILogger _logger;

  Future<void> login({required String login, required String password}) async {
    try {
      if (state is! AuthLoadingState) {
        emit(const AuthLoadingState(message: null));
      }
      _logger.info("Trying to login...");

      // TODO: implement

    } catch (e, st) {
      emit(
        AuthFailureState(
          failure: e,
          message: AppMessage(key: SessionMessageType.unauthorized),
        ),
      );
      _logger.exception(e, st);
    }
  }

  Future<void> _restoreOrFetch() async {
    try {
      if (state is! AuthLoadingState) {
        emit(const AuthLoadingState(message: null));
      }
      _logger.info("Trying to restore auth session...");

      // TODO: remove the delay
      await Future.delayed(const Duration(seconds: 7));

      final (Session, User) bundle = await _authInteractor.login();

      emit(AuthAuthenticatedState(user: bundle.$2));
    } catch (e, st) {
      emit(
        AuthFailureState(
          failure: e,
          message: AppMessage(key: SessionMessageType.loadFail),
        ),
      );
      _logger.exception(e, st);
    }
  }

  Future<void> signOut() async {
    try {
      await _authInteractor.signOut();
      emit(const AuthUnauthenticatedState(message: null));
    } catch (e, st) {
      emit(const AuthUnauthenticatedState(message: null));
      _logger.exception(e, st);
    }
  }
}
