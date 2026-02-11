part of 'all_conversations_list_bloc.dart';

sealed class AllConversationsListState extends Equatable {
  const AllConversationsListState({this.failure});

  final Object? failure;

  @override
  List<Object?> get props => <Object?>[failure];
}

final class AllConversationsListInitial extends AllConversationsListState {
  const AllConversationsListInitial({super.failure});

  @override
  List<Object?> get props => <Object?>[failure];
}

final class AllConversationsListLoadingState extends AllConversationsListState {
  const AllConversationsListLoadingState({required this.page, super.failure});

  final int page;

  @override
  List<Object?> get props => <Object?>[page, failure];
}

final class AllConversationsListLoadedState extends AllConversationsListState {
  const AllConversationsListLoadedState({
    required this.conversationTiles,
    required this.currentUserId,
    this.page = 1,
    this.isLoadingMore = false,
    this.hasMore = true,
    super.failure,
  });

  final int page;
  final List<ConversationTile> conversationTiles;
  final bool isLoadingMore;
  final bool hasMore;
  final String currentUserId;

  AllConversationsListLoadedState copyWith({
    int? page,
    List<ConversationTile>? conversationTiles,
    bool? isLoadingMore,
    bool? hasMore,
  }) {
    return AllConversationsListLoadedState(
      page: page ?? this.page,
      conversationTiles: conversationTiles ?? this.conversationTiles,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      failure: failure,
      currentUserId: currentUserId,
    );
  }

  @override
  List<Object?> get props => <Object?>[
    conversationTiles,
    currentUserId,
    page,
    isLoadingMore,
    hasMore,
    failure,
  ];
}

final class AllConversationsListFailureState extends AllConversationsListState {
  const AllConversationsListFailureState({required super.failure});

  @override
  List<Object?> get props => <Object?>[failure];
}
