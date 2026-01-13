import 'package:locnet_app/app/app.dart';

final class AuthExceptionCodes {
  const AuthExceptionCodes._();

  static const AppExceptionCode invalidCredentials = AppExceptionCode(
    'auth.invalidCredentials',
  );

  static const AppExceptionCode expiredSession = AppExceptionCode(
    'auth.expiredSession',
  );

  static const AppExceptionCode passwordsDontMatch = AppExceptionCode(
    'auth.passwordsDontMatch',
  );

  static const AppExceptionCode usernameAlreadyTaken = AppExceptionCode(
    'auth.usernameAlreadyTaken',
  );

  static const AppExceptionCode registerFailed = AppExceptionCode(
    'auth.registerFailed',
  );

  static const AppExceptionCode loginFailed = AppExceptionCode(
    'auth.loginFailed',
  );
}
