part of 'group_conversation_bloc.dart';

sealed class GroupConversationState extends Equatable {
  const GroupConversationState({this.failure});

  final Object? failure;
}

final class GroupConversationLoadingState extends GroupConversationState {
  const GroupConversationLoadingState({super.failure});

  @override
  List<Object?> get props => [failure];
}

final class GroupConversationLoadedState extends GroupConversationState {
  const GroupConversationLoadedState({
    required this.messages,
    required this.conversation,
    required this.participants,
    this.page = 1,
    super.failure,
  });

  final List<Message> messages;
  final Conversation conversation;
  final List<User> participants;
  final int page;

  GroupConversationLoadedState copyWith({
    List<Message>? messages,
    Conversation? conversation,
    List<User>? participants,
    int? page,
    Object? failure,
  }) {
    return GroupConversationLoadedState(
      messages: messages ?? this.messages,
      conversation: conversation ?? this.conversation,
      participants: participants ?? this.participants,
      page: page ?? this.page,
      failure: failure,
    );
  }

  @override
  List<Object?> get props => [
    messages,
    conversation,
    participants,
    page,
    failure,
  ];
}

final class GroupConversationFailureState extends GroupConversationState {
  const GroupConversationFailureState({required super.failure});

  @override
  List<Object?> get props => [failure];
}
