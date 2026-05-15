import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/conversations_list/subfeatures/unified_search/domain/domain.dart';
import 'package:stream_transform/stream_transform.dart';

part 'unified_search_event.dart';
part 'unified_search_state.dart';

EventTransformer<E> debounceDroppable<E>(Duration duration) {
  return (Stream<E> events, EventMapper<E> mapper) {
    return droppable<E>().call(events.debounce(duration), mapper);
  };
}

class UnifiedSearchBloc extends Bloc<UnifiedSearchEvent, UnifiedSearchState> {
  UnifiedSearchBloc({
    required UnifiedSearchInteractor searchInteractor,
    required UserInteractor userInteractor,
    required ILogger logger,
  }) : _logger = logger,
       _userInteractor = userInteractor,
       _searchInteractor = searchInteractor,
       super(const UnifiedSearchInitialState()) {
    on<LoadUnifiedSearchEvent>(
      _onLoad,
      transformer: debounceDroppable<LoadUnifiedSearchEvent>(
        const Duration(milliseconds: 350),
      ),
    );

    on<LoadMoreUnifiedSearchEvent>(
      _onLoadMore,
      transformer: droppable<LoadMoreUnifiedSearchEvent>(),
    );

    on<FailureUnifiedSearchEvent>(_onFailure);
  }

  final UnifiedSearchInteractor _searchInteractor;
  final UserInteractor _userInteractor;
  final ILogger _logger;

  final int _pageSize = 20;

  Future<void> _onLoad(
    LoadUnifiedSearchEvent event,
    Emitter<UnifiedSearchState> emit,
  ) async {
    try {
      final String normalizedQuery = event.query.trim();

      if (normalizedQuery.isEmpty) {
        emit(const UnifiedSearchInitialState());
        return;
      }

      emit(UnifiedSearchLoadingState(query: normalizedQuery));

      final UnifiedSearchResult page1 = await _searchInteractor.search(
        query: normalizedQuery,
      );
      final User currentUser = await _userInteractor.getCachedUser();
      final UnifiedSearchResult filteredResult = _filterCurrentUser(
        result: page1,
        currentUserId: currentUser.userId,
      );

      final bool hasMore = _calculateHasMore(filteredResult);

      emit(
        UnifiedSearchLoadedState(
          query: normalizedQuery,
          result: filteredResult,
          currentPage: 1,
          hasMore: hasMore,
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

      emit(
        UnifiedSearchFailureState(query: event.query, failure: appException),
      );
    }
  }

  Future<void> _onLoadMore(
    LoadMoreUnifiedSearchEvent event,
    Emitter<UnifiedSearchState> emit,
  ) async {
    try {
      if (state is! UnifiedSearchLoadedState) {
        return;
      }

      final UnifiedSearchLoadedState prevState =
          state as UnifiedSearchLoadedState;

      if (!prevState.hasMore || prevState.isLoadingMore) {
        return;
      }

      emit(prevState.copyWith(isLoadingMore: true));

      final int nextPage = prevState.currentPage + 1;

      final UnifiedSearchResult fetched = await _searchInteractor.search(
        query: prevState.query,
        page: nextPage,
      );
      final User currentUser = await _userInteractor.getCachedUser();
      final UnifiedSearchResult filteredFetched = _filterCurrentUser(
        result: fetched,
        currentUserId: currentUser.userId,
      );

      final UnifiedSearchResult merged = _mergeAndDeduplicate(
        current: prevState.result,
        fetched: filteredFetched,
      );

      final bool hasMore = _calculateHasMore(filteredFetched);

      emit(
        prevState.copyWith(
          result: merged,
          currentPage: nextPage,
          hasMore: hasMore,
          isLoadingMore: false,
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

      emit(
        UnifiedSearchFailureState(
          query: switch (state) {
            final UnifiedSearchLoadedState s => s.query,
            final UnifiedSearchLoadingState s => s.query,
            _ => null,
          },
          failure: appException,
        ),
      );
    }
  }

  bool _calculateHasMore(UnifiedSearchResult fetched) {
    final bool usersHasMore = fetched.users.length >= _pageSize;
    final bool groupsHasMore = fetched.groups.length >= _pageSize;
    final bool channelsHasMore = fetched.channels.length >= _pageSize;
    final bool conversationsHasMore = fetched.conversations.length >= _pageSize;
    return usersHasMore ||
        groupsHasMore ||
        channelsHasMore ||
        conversationsHasMore;
  }

  UnifiedSearchResult _mergeAndDeduplicate({
    required UnifiedSearchResult current,
    required UnifiedSearchResult fetched,
  }) {
    final List<User> mergedUsers = <User>[...current.users, ...fetched.users];
    final List<UnifiedSearchConversation> mergedGroups =
        <UnifiedSearchConversation>[...current.groups, ...fetched.groups];
    final List<UnifiedSearchConversation> mergedChannels =
        <UnifiedSearchConversation>[...current.channels, ...fetched.channels];
    final List<UnifiedSearchConversation> mergedConversations =
        <UnifiedSearchConversation>[
          ...current.conversations,
          ...fetched.conversations,
        ];

    final Map<String, User> usersById = <String, User>{};
    for (final User user in mergedUsers) {
      usersById[user.userId] = user;
    }

    final Map<String, UnifiedSearchConversation> groupsById =
        <String, UnifiedSearchConversation>{};
    for (final UnifiedSearchConversation conversation in mergedGroups) {
      groupsById[conversation.id] = conversation;
    }

    final Map<String, UnifiedSearchConversation> channelsById =
        <String, UnifiedSearchConversation>{};
    for (final UnifiedSearchConversation conversation in mergedChannels) {
      channelsById[conversation.id] = conversation;
    }

    final Map<String, UnifiedSearchConversation> conversationsById =
        <String, UnifiedSearchConversation>{};
    for (final UnifiedSearchConversation conversation in mergedConversations) {
      conversationsById[conversation.id] = conversation;
    }

    return UnifiedSearchResult(
      users: usersById.values.toList(growable: false),
      groups: groupsById.values.toList(growable: false),
      channels: channelsById.values.toList(growable: false),
      conversations: conversationsById.values.toList(growable: false),
    );
  }

  UnifiedSearchResult _filterCurrentUser({
    required UnifiedSearchResult result,
    required String currentUserId,
  }) {
    return UnifiedSearchResult(
      users: result.users
          .where((User user) => user.userId != currentUserId)
          .toList(growable: false),
      groups: result.groups,
      channels: result.channels,
      conversations: result.conversations,
    );
  }

  Future<void> _onFailure(
    FailureUnifiedSearchEvent event,
    Emitter<UnifiedSearchState> emit,
  ) async {
    emit(UnifiedSearchFailureState(query: null, failure: event.failure));
  }
}
