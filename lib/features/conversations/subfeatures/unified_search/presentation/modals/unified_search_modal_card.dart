import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/conversations/subfeatures/unified_search/domain/domain.dart';
import 'package:locnet_app/features/conversations/subfeatures/unified_search/presentation/presentation.dart';
import 'package:locnet_app/uikit/uikit.dart';

class UnifiedSearchModalCardWrapper extends StatelessWidget {
  const UnifiedSearchModalCardWrapper({required this.child, super.key});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return BlocProvider<UnifiedSearchBloc>(
      create: (context) => UnifiedSearchBloc(
        logger: context.read<ILogger>(),
        searchInteractor: context.read<UnifiedSearchInteractor>(),
      ),
      child: child,
    );
  }
}

class UnifiedSearchModalCard extends StatefulWidget {
  const UnifiedSearchModalCard({super.key});

  @override
  State<UnifiedSearchModalCard> createState() => _UnifiedSearchModalCardState();
}

class _UnifiedSearchModalCardState extends State<UnifiedSearchModalCard> {
  late final TextEditingController _queryController;

  @override
  void initState() {
    super.initState();
    _queryController = TextEditingController();

    final UnifiedSearchState state = context.read<UnifiedSearchBloc>().state;

    final String initialQuery = switch (state) {
      final UnifiedSearchLoadedState s => s.query,
      final UnifiedSearchLoadingState s => s.query,
      final UnifiedSearchFailureState s => s.query ?? '',
      _ => '',
    };

    if (initialQuery.isNotEmpty) {
      _queryController.text = initialQuery;
      _queryController.selection = TextSelection.fromPosition(
        TextPosition(offset: _queryController.text.length),
      );
    }
  }

  @override
  void dispose() {
    _queryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final searchBloc = context.read<UnifiedSearchBloc>();

    return AppModalCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const UnifiedSearchHeader(),
          Divider(height: 1, color: context.colorScheme.outlineVariant),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  CustomTextField(
                    controller: _queryController,
                    labelText: l10n.search,
                    textInputAction: TextInputAction.search,
                    maxSymbols: 200,
                    onChanged: (String? value) {
                      searchBloc.add(
                        LoadUnifiedSearchEvent(query: value ?? ''),
                      );
                    },
                    onFocusChange: (String? value) {
                      searchBloc.add(
                        LoadUnifiedSearchEvent(query: value ?? ''),
                      );
                    },
                    onSubmitted: (String? value) {
                      searchBloc.add(
                        LoadUnifiedSearchEvent(query: value ?? ''),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: BlocBuilder<UnifiedSearchBloc, UnifiedSearchState>(
                      builder:
                          (BuildContext context, UnifiedSearchState state) {
                            final Object? failure = state.failure;

                            if (failure != null &&
                                state is UnifiedSearchFailureState) {
                              return InfoWidget(
                                icon: Icons.error,
                                text: AppExceptionsTranslator.translate(
                                  context,
                                  failure,
                                ),
                                iconAnimationEffect: const ShakeEffect(),
                              );
                            }

                            return _UnifiedSearchBody(state: state);
                          },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _UnifiedSearchBody extends StatelessWidget {
  const _UnifiedSearchBody({required this.state});

  final UnifiedSearchState state;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final l10n = context.l10n;

    if (state is UnifiedSearchInitialState) {
      return _UnifiedSearchPlaceholder(
        icon: Icons.search,
        text: l10n.searchUsersAndChatsHint,
      );
    }

    if (state is UnifiedSearchLoadingState) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: CircularProgressIndicator(color: colorScheme.primary),
        ),
      );
    }

    if (state is! UnifiedSearchLoadedState) {
      return const SizedBox.shrink();
    }

    final UnifiedSearchLoadedState loadedState =
        state as UnifiedSearchLoadedState;

    final List<UnifiedSearchListItem> items = <UnifiedSearchListItem>[
      ...loadedState.result.users.map(UnifiedSearchListItem.user),
      ...loadedState.result.conversations.map(
        UnifiedSearchListItem.conversation,
      ),
    ];

    final bool isEmpty = items.isEmpty;

    if (isEmpty) {
      return _UnifiedSearchPlaceholder(
        icon: Icons.search_off,
        title: l10n.nothingFound,
        text: l10n.tryAnotherQuery,
      );
    }

    final bool shouldShowBottomLoader =
        loadedState.isLoadingMore || loadedState.hasMore;

    final int listItemsCount = items.length + (shouldShowBottomLoader ? 1 : 0);

    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification notification) {
        final bool isAtBottom =
            notification.metrics.pixels >=
            notification.metrics.maxScrollExtent - 32;

        final bool canLoadMore =
            loadedState.hasMore && !loadedState.isLoadingMore;

        if (isAtBottom && canLoadMore) {
          context.read<UnifiedSearchBloc>().add(
            const LoadMoreUnifiedSearchEvent(),
          );
        }

        return false;
      },
      child: ListView.separated(
        padding: const EdgeInsets.only(bottom: 16),
        itemCount: listItemsCount,
        separatorBuilder: (BuildContext context, int index) {
          final bool isLast = index == listItemsCount - 1;
          if (isLast) {
            return const SizedBox.shrink();
          }
          return const SizedBox(height: 6);
        },
        itemBuilder: (BuildContext context, int index) {
          if (index >= items.length) {
            if (!loadedState.isLoadingMore && loadedState.hasMore) {
              return const SizedBox(height: 10);
            }

            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: colorScheme.primary,
                  ),
                ),
              ),
            );
          }

          return UnifiedSearchResultTile(item: items[index], onPressed: () {});
        },
      ),
    );
  }
}

class _UnifiedSearchPlaceholder extends StatelessWidget {
  const _UnifiedSearchPlaceholder({
    required this.icon,
    required this.text,
    this.title,
  });

  final IconData icon;
  final String? title;
  final String text;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textScheme = context.textScheme;

    final bool hasTitle = title != null && title!.trim().isNotEmpty;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 34, color: colorScheme.onSurfaceVariant),
            if (hasTitle) ...[
              const SizedBox(height: 10),
              Text(
                title!,
                style: textScheme.display.copyWith(
                  color: colorScheme.onSurface,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            const SizedBox(height: 6),
            Text(
              text,
              style: textScheme.label.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
