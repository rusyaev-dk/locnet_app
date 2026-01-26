part of 'channel_conversation_bloc.dart';

sealed class ChannelConversationState extends Equatable {
  const ChannelConversationState({this.failure});

  final Object? failure;
}

final class ChannelConversationLoadingState extends ChannelConversationState {
  const ChannelConversationLoadingState({super.failure});

  @override
  List<Object?> get props => [failure];
}

final class ChannelConversationLoadedState extends ChannelConversationState {
  const ChannelConversationLoadedState({
    required this.messages,
    required this.conversation,
    required this.subscribers,
    this.page = 1,
    super.failure,
  });

  final List<Message> messages;
  final Conversation conversation;
  final List<User> subscribers;
  final int page;

  ChannelConversationLoadedState copyWith({
    List<Message>? messages,
    Conversation? conversation,
    List<User>? subscribers,
    int? page,
    Object? failure,
  }) {
    return ChannelConversationLoadedState(
      messages: messages ?? this.messages,
      conversation: conversation ?? this.conversation,
      subscribers: subscribers ?? this.subscribers,
      page: page ?? this.page,
      failure: failure,
    );
  }

  @override
  List<Object?> get props => [
    messages,
    conversation,
    subscribers,
    page,
    failure,
  ];
}

final class ChannelConversationFailureState extends ChannelConversationState {
  const ChannelConversationFailureState({required super.failure});

  @override
  List<Object?> get props => [failure];
}
