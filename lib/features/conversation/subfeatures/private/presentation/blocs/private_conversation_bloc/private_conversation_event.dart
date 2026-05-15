part of 'private_conversation_bloc.dart';

sealed class PrivateConversationEvent extends Equatable {
  const PrivateConversationEvent();

  @override
  List<Object?> get props => [];
}

final class PrivateConversationStartedEvent extends PrivateConversationEvent {
  const PrivateConversationStartedEvent({
    required this.conversationId,
    this.initialCompanion,
  });

  final String conversationId;
  final User? initialCompanion;

  @override
  List<Object?> get props => [conversationId, initialCompanion];
}

final class PrivateConversationDraftStartedEvent
    extends PrivateConversationEvent {
  const PrivateConversationDraftStartedEvent({
    required this.companionId,
    this.initialCompanion,
  });

  final String companionId;
  final User? initialCompanion;

  @override
  List<Object?> get props => [companionId, initialCompanion];
}

final class PrivateConversationSendMessageEvent
    extends PrivateConversationEvent {
  const PrivateConversationSendMessageEvent({
    required this.text,
    required this.attachedFiles,
    this.replyToMessageId,
  });

  final String text;
  final List<UploadableFile> attachedFiles;
  final String? replyToMessageId;

  @override
  List<Object?> get props => [text, attachedFiles, replyToMessageId];
}

final class PrivateConversationMessageUpdateReceivedEvent
    extends PrivateConversationEvent {
  const PrivateConversationMessageUpdateReceivedEvent({required this.update});

  final PrivateConversationMessageUpdateRec update;

  @override
  List<Object> get props => [update];
}

final class PrivateConversationMessageDeletedLocallyEvent
    extends PrivateConversationEvent {
  const PrivateConversationMessageDeletedLocallyEvent({
    required this.messageId,
  });

  final String messageId;

  @override
  List<Object> get props => [messageId];
}

final class PrivateConversationMarkMessageReadEvent
    extends PrivateConversationEvent {
  const PrivateConversationMarkMessageReadEvent({
    required this.conversationId,
    required this.messageId,
  });

  final String conversationId;
  final String messageId;

  @override
  List<Object?> get props => [conversationId, messageId];
}
