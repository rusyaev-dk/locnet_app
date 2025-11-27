part of 'private_conversation_bloc.dart';

sealed class PrivateConversationEvent extends Equatable {
  const PrivateConversationEvent();

  @override
  List<Object> get props => [];
}

final class PrivateConversationStartedEvent extends PrivateConversationEvent {
  const PrivateConversationStartedEvent({
    required this.conversationId,
    required this.companionId,
  });

  final String conversationId;
  final String companionId;

  @override
  List<Object> get props => [conversationId, companionId];
}

final class PrivateConversationMessageUpdateReceivedEvent
    extends PrivateConversationEvent {
  const PrivateConversationMessageUpdateReceivedEvent({required this.update});

  final PrivateConversationMessageUpdateRec update;

  @override
  List<Object> get props => [update];
}
