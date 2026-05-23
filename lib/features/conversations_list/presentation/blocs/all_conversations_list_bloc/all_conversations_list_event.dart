part of 'all_conversations_list_bloc.dart';

sealed class AllConversationsListEvent extends Equatable {
  const AllConversationsListEvent();

  @override
  List<Object?> get props => <Object?>[];
}

final class AllConversationsListLoadEvent extends AllConversationsListEvent {
  const AllConversationsListLoadEvent();

  @override
  List<Object?> get props => <Object?>[];
}

final class AllConversationsListLoadMoreEvent
    extends AllConversationsListEvent {
  const AllConversationsListLoadMoreEvent({required this.page});

  final int page;

  @override
  List<Object?> get props => <Object?>[page];
}

final class AllConversationsListConversationCreatedEvent
    extends AllConversationsListEvent {
  const AllConversationsListConversationCreatedEvent({
    required this.conversationTile,
  });

  final ConversationTile conversationTile;

  @override
  List<Object?> get props => <Object?>[conversationTile];
}

final class AllConversationsListConversationUpdatedEvent
    extends AllConversationsListEvent {
  const AllConversationsListConversationUpdatedEvent({
    required this.conversationTile,
  });

  final ConversationTile conversationTile;

  @override
  List<Object?> get props => <Object?>[conversationTile];
}

final class AllConversationsListConversationDeletedEvent
    extends AllConversationsListEvent {
  const AllConversationsListConversationDeletedEvent({
    required this.conversationId,
  });

  final String conversationId;

  @override
  List<Object?> get props => <Object?>[conversationId];
}

final class AllConversationsListSocketErrorEvent
    extends AllConversationsListEvent {
  const AllConversationsListSocketErrorEvent({required this.failure});

  final AppException failure;

  @override
  List<Object?> get props => <Object?>[failure];
}

/// Dispatched internally when network connectivity is restored.
final class _AllConversationsListNetworkRestoredEvent
    extends AllConversationsListEvent {
  const _AllConversationsListNetworkRestoredEvent();
}
