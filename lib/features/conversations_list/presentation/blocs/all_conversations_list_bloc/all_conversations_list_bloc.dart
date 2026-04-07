import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/conversations_list/data/data.dart';
import 'package:locnet_app/features/conversations_list/domain/domain.dart';

part 'all_conversations_list_event.dart';
part 'all_conversations_list_state.dart';

class AllConversationsListBloc
    extends Bloc<AllConversationsListEvent, AllConversationsListState> {
  AllConversationsListBloc({
    required ConversationsListInteractor conversationsListInteractor,
    required UserInteractor userInteractor,
    required ILogger logger,
  }) : _conversationsListInteractor = conversationsListInteractor,
       _userInteractor = userInteractor,
       _logger = logger,
       super(const AllConversationsListInitial()) {
    on<AllConversationsListLoadEvent>(_onLoad);
    on<AllConversationsListLoadMoreEvent>(_onLoadMore);
    on<AllConversationsListConversationCreatedEvent>(_onConversationCreated);
    on<AllConversationsListConversationUpdatedEvent>(_onConversationUpdated);
    on<AllConversationsListConversationDeletedEvent>(_onConversationDeleted);

    // TODO: Handle updates
    // _conversationsUpdatesSub = _conversationsListInteractor.conversationsUpdates
    //     .listen(_onIncomingChange);
  }

  final ConversationsListInteractor _conversationsListInteractor;
  final UserInteractor _userInteractor;
  final ILogger _logger;

  late final StreamSubscription<ConversationsListUpdateRec>
  _conversationsUpdatesSub;

  static const int _pageSize = 20;

  Future<void> _safeLoadConversations({
    required int page,
    required Emitter<AllConversationsListState> emit,
    required bool isLoadMore,
  }) async {
    try {
      if (!isLoadMore) {
        emit(AllConversationsListLoadingState(page: page));
      } else {
        final AllConversationsListState currentState = state;
        if (currentState is AllConversationsListLoadedState) {
          emit(currentState.copyWith(isLoadingMore: true));
        }
      }

      final List<ConversationTile> loadedConversations =
          await _conversationsListInteractor.loadConversations(page: page);

      // Sort conversations by last message time (most recent first)
      final List<ConversationTile> sortedConversations =
          _sortConversationsByLastMessage(loadedConversations);

      final AllConversationsListState currentState = state;

      final cachedUser = await _userInteractor.getCachedUser();

      // Determine if there are more pages to load
      final bool hasMore = sortedConversations.length >= _pageSize;

      if (!isLoadMore || currentState is! AllConversationsListLoadedState) {
        emit(
          AllConversationsListLoadedState(
            conversationTiles: sortedConversations,
            currentUserId: cachedUser.userId,
            page: page,
            hasMore: hasMore,
          ),
        );
        return;
      }

      final AllConversationsListLoadedState loadedState = currentState;

      // Combine and sort all conversations
      final List<ConversationTile> combinedConversations = <ConversationTile>[
        ...loadedState.conversationTiles,
        ...sortedConversations,
      ];
      final List<ConversationTile> sortedCombined =
          _sortConversationsByLastMessage(combinedConversations);

      emit(
        loadedState.copyWith(
          page: page,
          isLoadingMore: false,
          hasMore: hasMore,
          conversationTiles: sortedCombined,
        ),
      );
    } catch (e, st) {
      _logger.exception(e, st);

      final AppException appException = e is AppException
          ? e
          : AppUnknownException(
              message: e.toString(),
              error: e,
              stackTrace: st,
            );

      emit(AllConversationsListFailureState(failure: appException));
    }
  }

  Future<void> _onLoad(
    AllConversationsListLoadEvent event,
    Emitter<AllConversationsListState> emit,
  ) async {
    final AllConversationsListState currentState = state;
    if (currentState is AllConversationsListLoadingState) {
      return;
    }
    await _safeLoadConversations(page: 1, emit: emit, isLoadMore: false);
  }

  Future<void> _onLoadMore(
    AllConversationsListLoadMoreEvent event,
    Emitter<AllConversationsListState> emit,
  ) async {
    final AllConversationsListState currentState = state;

    if (currentState is! AllConversationsListLoadedState) {
      return;
    }

    if (currentState.isLoadingMore) {
      return;
    }

    final int nextPage = event.page;

    await _safeLoadConversations(page: nextPage, emit: emit, isLoadMore: true);
  }

  void _onIncomingChange(ConversationsListUpdateRec update) {
    switch (update.updateType) {
      case ConversationTileUpdateType.created:
        add(
          AllConversationsListConversationCreatedEvent(
            conversationTile: update.conversationTile,
          ),
        );
        break;
      case ConversationTileUpdateType.updated:
        add(
          AllConversationsListConversationUpdatedEvent(
            conversationTile: update.conversationTile,
          ),
        );
        break;
      case ConversationTileUpdateType.deleted:
        add(
          AllConversationsListConversationDeletedEvent(
            conversationId: update.conversationTile.id,
          ),
        );
        break;
    }
  }

  Future<void> _onConversationCreated(
    AllConversationsListConversationCreatedEvent event,
    Emitter<AllConversationsListState> emit,
  ) async {
    final AllConversationsListState currentState = state;

    if (currentState is! AllConversationsListLoadedState) {
      return;
    }

    final List<ConversationTile> updatedConversations = <ConversationTile>[
      event.conversationTile,
      ...currentState.conversationTiles,
    ];

    // Sort conversations by last message time
    final List<ConversationTile> sortedConversations =
        _sortConversationsByLastMessage(updatedConversations);

    emit(currentState.copyWith(conversationTiles: sortedConversations));
  }

  Future<void> _onConversationUpdated(
    AllConversationsListConversationUpdatedEvent event,
    Emitter<AllConversationsListState> emit,
  ) async {
    final AllConversationsListState currentState = state;

    if (currentState is! AllConversationsListLoadedState) {
      return;
    }

    final List<ConversationTile> updatedConversations = currentState
        .conversationTiles
        .map((ConversationTile tile) {
          if (tile.id == event.conversationTile.id) {
            return event.conversationTile;
          }
          return tile;
        })
        .toList();

    // Sort conversations by last message time
    final List<ConversationTile> sortedConversations =
        _sortConversationsByLastMessage(updatedConversations);

    emit(currentState.copyWith(conversationTiles: sortedConversations));
  }

  Future<void> _onConversationDeleted(
    AllConversationsListConversationDeletedEvent event,
    Emitter<AllConversationsListState> emit,
  ) async {
    final AllConversationsListState currentState = state;

    if (currentState is! AllConversationsListLoadedState) {
      return;
    }

    final List<ConversationTile> updatedConversations = currentState
        .conversationTiles
        .where((ConversationTile tile) => tile.id != event.conversationId)
        .toList();

    emit(currentState.copyWith(conversationTiles: updatedConversations));
  }

  List<ConversationTile> _sortConversationsByLastMessage(
    List<ConversationTile> conversations,
  ) {
    final List<ConversationTile> sorted =
        List<ConversationTile>.from(conversations)
          ..sort((ConversationTile a, ConversationTile b) {
            // Get timestamp for last message or tile update
            final DateTime aTime = a.lastMessageAt ?? a.updatedAt;
            final DateTime bTime = b.lastMessageAt ?? b.updatedAt;

            // Sort in descending order (most recent first)
            return bTime.compareTo(aTime);
          });

    return sorted;
  }

  @override
  Future<void> close() async {
    await _conversationsUpdatesSub.cancel();
    return super.close();
  }
}
