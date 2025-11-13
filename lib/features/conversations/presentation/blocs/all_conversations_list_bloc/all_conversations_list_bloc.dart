import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/conversation/data/data.dart';
import 'package:locnet_app/features/conversation/domain/domain.dart';
import 'package:locnet_app/features/conversations/domain/domain.dart';

part 'all_conversations_list_event.dart';
part 'all_conversations_list_state.dart';

class AllConversationsListBloc
    extends Bloc<AllConversationsListEvent, AllConversationsListState> {
  AllConversationsListBloc({
    required ConversationsListInteractor feedInteractor,
    required ILogger logger,
    required IConversationRepo conversationRepo,
  }) : _feedInteractor = feedInteractor,
       _logger = logger,
       _conversationRepo = conversationRepo,
       super(const AllConversationsListInitial()) {
    on<AllConversationsListLoadEvent>(_onLoad);
    on<AllConversationsListLoadMoreEvent>(_onLoadMore);
    on<AllConversationsListConversationCreatedEvent>(_onConversationCreated);
    on<AllConversationsListConversationUpdatedEvent>(_onConversationUpdated);
    on<AllConversationsListConversationDeletedEvent>(_onConversationDeleted);

    _conversationsUpdatesSub = _conversationRepo.conversationsUpdates.listen(
      _onIncomingChange,
    );
  }

  final ConversationsListInteractor _feedInteractor;
  final ILogger _logger;
  final IConversationRepo _conversationRepo;

  late final StreamSubscription<ConversationsUpdateRec>
  _conversationsUpdatesSub;

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

      final List<Conversation> loadedConversations = await _feedInteractor
          .loadConversations(page: page);

      final AllConversationsListState currentState = state;

      if (!isLoadMore || currentState is! AllConversationsListLoadedState) {
        emit(
          AllConversationsListLoadedState(
            conversations: loadedConversations,
            page: page,
          ),
        );
        return;
      }

      final AllConversationsListLoadedState loadedState = currentState;

      emit(
        loadedState.copyWith(
          page: page,
          isLoadingMore: false,
          conversations: <Conversation>[
            ...loadedState.conversations,
            ...loadedConversations,
          ],
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

  void _onIncomingChange(ConversationsUpdateRec update) {
    switch (update.kind) {
      case ConversationUpdateType.created:
        add(
          AllConversationsListConversationCreatedEvent(
            conversation: update.conversation,
          ),
        );
        break;
      case ConversationUpdateType.updated:
        add(
          AllConversationsListConversationUpdatedEvent(
            conversation: update.conversation,
          ),
        );
        break;
      case ConversationUpdateType.deleted:
        add(
          AllConversationsListConversationDeletedEvent(
            conversationId: update.conversation.id,
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

    final List<Conversation> updatedConversations = <Conversation>[
      event.conversation,
      ...currentState.conversations,
    ];

    emit(currentState.copyWith(conversations: updatedConversations));
  }

  Future<void> _onConversationUpdated(
    AllConversationsListConversationUpdatedEvent event,
    Emitter<AllConversationsListState> emit,
  ) async {
    final AllConversationsListState currentState = state;

    if (currentState is! AllConversationsListLoadedState) {
      return;
    }

    final List<Conversation> updatedConversations = currentState.conversations
        .map((Conversation conversation) {
          if (conversation.id == event.conversation.id) {
            return event.conversation;
          }
          return conversation;
        })
        .toList();

    emit(currentState.copyWith(conversations: updatedConversations));
  }

  Future<void> _onConversationDeleted(
    AllConversationsListConversationDeletedEvent event,
    Emitter<AllConversationsListState> emit,
  ) async {
    final AllConversationsListState currentState = state;

    if (currentState is! AllConversationsListLoadedState) {
      return;
    }

    final List<Conversation> updatedConversations = currentState.conversations
        .where(
          (Conversation conversation) =>
              conversation.id != event.conversationId,
        )
        .toList();

    emit(currentState.copyWith(conversations: updatedConversations));
  }

  // _safeLoad, _onLoad, _onLoadMore остаются

  @override
  Future<void> close() async {
    await _conversationsUpdatesSub.cancel();
    return super.close();
  }
}
