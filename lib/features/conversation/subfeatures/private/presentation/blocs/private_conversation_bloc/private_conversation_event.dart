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
  const PrivateConversationDraftStartedEvent({required this.companionId});

  final String companionId;

  @override
  List<Object> get props => [companionId];
}

final class PrivateConversationSendMessageEvent
    extends PrivateConversationEvent {
  const PrivateConversationSendMessageEvent({
    required this.text,
    this.replyToMessageId,
  });

  final String text;
  final String? replyToMessageId;

  @override
  List<Object?> get props => [text, replyToMessageId];
}

final class PrivateConversationMessageUpdateReceivedEvent
    extends PrivateConversationEvent {
  const PrivateConversationMessageUpdateReceivedEvent({required this.update});

  final PrivateConversationMessageUpdateRec update;

  @override
  List<Object> get props => [update];
}
