part of 'unified_search_bloc.dart';

sealed class UnifiedSearchEvent extends Equatable {
  const UnifiedSearchEvent();
}

final class LoadUnifiedSearchEvent extends UnifiedSearchEvent {
  const LoadUnifiedSearchEvent({required this.query});

  final String query;

  @override
  List<Object?> get props => [query];
}

final class LoadMoreUnifiedSearchEvent extends UnifiedSearchEvent {
  const LoadMoreUnifiedSearchEvent();

  @override
  List<Object?> get props => [];
}

final class FailureUnifiedSearchEvent extends UnifiedSearchEvent {
  const FailureUnifiedSearchEvent({required this.failure});

  final Object failure;

  @override
  List<Object?> get props => [failure];
}
