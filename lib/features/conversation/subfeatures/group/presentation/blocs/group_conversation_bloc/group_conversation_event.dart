part of 'group_conversation_bloc.dart';

sealed class GroupConversationEvent extends Equatable {
  const GroupConversationEvent();

  @override
  List<Object> get props => [];
}

final class GroupConversationStartedEvent extends GroupConversationEvent {
  const GroupConversationStartedEvent({required this.conversationId});

  final String conversationId;

  @override
  List<Object> get props => [conversationId];
}
