part of 'private_conversation_bloc.dart';

sealed class PrivateConversationEvent extends Equatable {
  const PrivateConversationEvent();

  @override
  List<Object> get props => [];
}

final class PrivateConversationStartedEvent extends PrivateConversationEvent {
  const PrivateConversationStartedEvent({required this.conversationId});

  final String conversationId;

  @override
  List<Object> get props => [conversationId];
}

final class PrivateConversationMessageUpdateReceivedEvent
    extends PrivateConversationEvent {
  const PrivateConversationMessageUpdateReceivedEvent({required this.update});

  final PrivateConversationMessageUpdateRec update;

  @override
  List<Object> get props => [update];
}
