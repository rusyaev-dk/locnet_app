part of 'private_conversation_bloc.dart';

sealed class PrivateConversationState extends Equatable {
  const PrivateConversationState({this.failure});

  final Object? failure;
}

final class PrivateConversationLoadingState extends PrivateConversationState {
  const PrivateConversationLoadingState({super.failure});

  @override
  List<Object?> get props => [failure];
}

final class PrivateConversationLoadedState extends PrivateConversationState {
  const PrivateConversationLoadedState({
    required this.messages,
    required this.conversation,
    required this.companionId,
    this.page = 1,
    super.failure,
  });

  final List<Message> messages;
  final Conversation conversation;
  final String companionId;
  final int page;

  PrivateConversationLoadedState copyWith({
    List<Message>? messages,
    Conversation? conversation,
    String? companionId,
    int? page,
    Object? failure,
  }) {
    return PrivateConversationLoadedState(
      messages: messages ?? this.messages,
      conversation: conversation ?? this.conversation,
      companionId: companionId ?? this.companionId,
      page: page ?? this.page,
      failure: failure,
    );
  }

  @override
  List<Object?> get props => [
    messages,
    conversation,
    companionId,
    page,
    failure,
  ];
}

final class PrivateConversationFailureState extends PrivateConversationState {
  const PrivateConversationFailureState({required super.failure});

  @override
  List<Object?> get props => [failure];
}
