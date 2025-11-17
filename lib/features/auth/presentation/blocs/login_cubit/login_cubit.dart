import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/core/core.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit({required ILogger logger})
    : _logger = logger,
      super(const LoginState());

  final ILogger _logger;

  Future<void> updateLogin({required String newLogin}) async {
    try {
      // TODO: implement login validation
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
      // TODO: implement login validation
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

  bool canLogIn() {
    return (state.login != null && state.login!.isNotEmpty) &&
        (state.password != null && state.password!.isNotEmpty);
  }
}
