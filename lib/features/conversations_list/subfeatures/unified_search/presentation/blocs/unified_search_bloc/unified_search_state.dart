part of 'unified_search_bloc.dart';

sealed class UnifiedSearchState extends Equatable {
  const UnifiedSearchState({required this.failure});

  final Object? failure;
}

final class UnifiedSearchInitialState extends UnifiedSearchState {
  const UnifiedSearchInitialState({super.failure});

  @override
  List<Object?> get props => [failure];
}

final class UnifiedSearchLoadingState extends UnifiedSearchState {
  const UnifiedSearchLoadingState({required this.query, super.failure});

  final String query;

  @override
  List<Object?> get props => [query, failure];
}

final class UnifiedSearchLoadedState extends UnifiedSearchState {
  const UnifiedSearchLoadedState({
    required this.query,
    required this.result,
    required this.currentPage,
    required this.hasMore,
    this.isLoadingMore = false,
    super.failure,
  });

  final String query;
  final UnifiedSearchResult result;
  final int currentPage;
  final bool hasMore;
  final bool isLoadingMore;

  UnifiedSearchLoadedState copyWith({
    String? query,
    UnifiedSearchResult? result,
    int? currentPage,
    bool? hasMore,
    bool? isLoadingMore,
    Object? failure,
  }) {
    return UnifiedSearchLoadedState(
      query: query ?? this.query,
      result: result ?? this.result,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      failure: failure,
    );
  }

  @override
  List<Object?> get props => [
        query,
        result,
        currentPage,
        hasMore,
        isLoadingMore,
        failure,
      ];
}

final class UnifiedSearchFailureState extends UnifiedSearchState {
  const UnifiedSearchFailureState({
    required this.query,
    required super.failure,
  });

  final String? query;

  @override
  List<Object?> get props => [query, failure];
}
