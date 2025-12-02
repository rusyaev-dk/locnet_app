part of 'private_conversation_options_cubit.dart';

sealed class PrivateConversationOptionsState extends Equatable {
  const PrivateConversationOptionsState({this.failure});

  final Object? failure;
}

final class PrivateConversationOptionsInitialState
    extends PrivateConversationOptionsState {
  const PrivateConversationOptionsInitialState({
    required this.conversationId,
    super.failure,
  });

  final String conversationId;

  @override
  List<Object?> get props => [failure, conversationId];
}

final class PrivateConversationOptionsLoadingState
    extends PrivateConversationOptionsState {
  const PrivateConversationOptionsLoadingState({super.failure});

  @override
  List<Object?> get props => [failure];
}

final class PrivateConversationOptionsLoadedState
    extends PrivateConversationOptionsState {
  const PrivateConversationOptionsLoadedState({
    required this.conversationId,
    required this.companionId,
    super.failure,
  });

  final String conversationId;
  final String companionId;

  PrivateConversationOptionsLoadedState copyWith({
    String? conversationId,
    String? companionId,
    AppException? failure,
  }) {
    return PrivateConversationOptionsLoadedState(
      conversationId: conversationId ?? this.conversationId,
      companionId: companionId ?? this.companionId,
      failure: failure ?? this.failure,
    );
  }

  @override
  List<Object?> get props => [
        failure,
        conversationId,
        companionId,
      ];
}


final class PrivateConversationOptionsFailureState
    extends PrivateConversationOptionsState {
  const PrivateConversationOptionsFailureState({required super.failure});

  @override
  List<Object?> get props => [failure];
}
