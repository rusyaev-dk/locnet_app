import 'package:locnet_app/core/domain/domain.dart';

final class ConversationDataValidator {
  static void validateTitle(String title) {
    final String trimmedTitle = title.trim();

    if (trimmedTitle.isEmpty) {
      throw CharactersCountViolationException(
        message: "Conversation title cannot be empty",
      );
    }

    if (trimmedTitle.length > 120) {
      throw CharactersCountViolationException(
        message: "Conversation title contains too much characters (max 120)",
      );
    }
  }

  static void validateDescription(String description) {
    final String trimmedDescription = description.trim();

    if (trimmedDescription.isEmpty) {
      throw RequiredValueNotProvidedException(
        message: 'Conversation description cannot be empty',
      );
    }

    if (trimmedDescription.length > 1000) {
      throw CharactersCountViolationException(
        message:
            'Conversation description contains too much characters (max 1000)',
      );
    }
  }
}
