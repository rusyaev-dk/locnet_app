part of 'channel_conversation_bloc.dart';

sealed class ChannelConversationEvent extends Equatable {
  const ChannelConversationEvent();

  @override
  List<Object> get props => [];
}

final class ChannelConversationStartedEvent extends ChannelConversationEvent {
  const ChannelConversationStartedEvent({required this.conversationId});

  final String conversationId;

  @override
  List<Object> get props => [conversationId];
}

final class ChannelConversationPublicationUpdateReceivedEvent
    extends ChannelConversationEvent {
  const ChannelConversationPublicationUpdateReceivedEvent({
    required this.update,
  });

  final ChannelPublicationUpdateRec update;

  @override
  List<Object> get props => [update];
}
