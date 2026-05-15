import 'package:locnet_app/core/core.dart';

final class ProfileDataValidator {
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
}
