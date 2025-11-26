import 'package:locnet_app/core/core.dart';

abstract class ConversationCreatorException extends DomainException {
  ConversationCreatorException({
    required super.message,
    super.error,
    super.stackTrace,
  });
}

final class ConversationEmptyFieldException
    extends ConversationCreatorException {
  ConversationEmptyFieldException({
    super.message = "This field can not be empty",
    super.error,
    super.stackTrace,
  });
}

final class ConversationDataTooLongException
    extends ConversationCreatorException {
  ConversationDataTooLongException({
    super.message = "Provided data is too long",
    super.error,
    super.stackTrace,
  });
}

final class ConversationCreateException
    extends ConversationCreatorException {
  ConversationCreateException({
    super.message = "Failed to create conversation",
    super.error,
    super.stackTrace,
  });
}