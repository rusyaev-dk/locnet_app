import 'package:locnet_app/core/domain/domain.dart';
import 'package:locnet_app/features/auth/domain/domain.dart';

final class ProfileDataFormatter {
  static void validateName(String name) {
    final RegExp pattern = RegExp(r'^[A-Za-z]+$');
    if (!pattern.hasMatch(name)) {
      throw InvalidCharactersException(
        message: "Name contains invalid characters",
      );
    }
  }

  static void validateUsername(String username) {
    final RegExp pattern = RegExp(r'^[A-Za-z0-9_]+$');
    if (!pattern.hasMatch(username)) {
      throw InvalidCharactersException(
        message: "Username contains invalid characters",
      );
    }
  }

  static void validateUserDescription(String description) {
    if (description.length > 200) {
      throw CharactersCountViolationException(
        message: "User description contains too much characters (max 200)",
      );
    }
  }

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

    if (!RegExp(r'^[A-Za-z0-9!?@#$%^&*()_\-{}]+$').hasMatch(password)) {
      throw PasswordTooWeakException(
        message:
            "Password must contain at least one special symbol (like !@#\$%^&*())",
      );
    }
  }
}
