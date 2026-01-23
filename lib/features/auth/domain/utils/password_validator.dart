import 'package:locnet_app/features/auth/domain/domain.dart';

final class PasswordValidator {
  static void validatePassword(String password) {
    if (password.length < 14) {
      throw PasswordTooWeakException(
        message: "Password contains too less characters",
      );
    }

    if (!RegExp(r'[A-Z]').hasMatch(password)) {
      throw PasswordTooWeakException(
        message: "Password must contain uppercase letters",
      );
    }

    if (!RegExp(r'[a-z]').hasMatch(password)) {
      throw PasswordTooWeakException(
        message: "Password must contain lowercase letters",
      );
    }

    if (!RegExp(r'\d').hasMatch(password)) {
      throw PasswordTooWeakException(
        message: "Password must contain at least one digit",
      );
    }

    final RegExp allowed = RegExp(r'^[A-Za-z0-9!?@#$%^&*()_\-{}]+$');
    if (!allowed.hasMatch(password)) {
      throw PasswordTooWeakException(
        message: "Password contains forbidden characters",
      );
    }

    final RegExp special = RegExp(r'[!?@#$%^&*()_\-{}]');
    if (!special.hasMatch(password)) {
      throw PasswordTooWeakException(
        message:
            "Password must contain at least one special symbol (like !@#\$%^&*())",
      );
    }
  }
}
