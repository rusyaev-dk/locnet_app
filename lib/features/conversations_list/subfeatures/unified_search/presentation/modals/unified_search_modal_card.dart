import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/conversations_list/subfeatures/unified_search/domain/domain.dart';
import 'package:locnet_app/features/conversations_list/subfeatures/unified_search/presentation/presentation.dart';
import 'package:locnet_app/features/conversations_list/domain/domain.dart';
import 'package:locnet_app/features/conversations_list/presentation/presentation.dart';
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
        userInteractor: context.read<UserInteractor>(),
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

enum _UnifiedSearchTab { users, groups, channels }

class _UnifiedSearchModalCardState extends State<UnifiedSearchModalCard> {
  late final TextEditingController _queryController;
  _UnifiedSearchTab _selectedTab = _UnifiedSearchTab.users;

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
    final colorScheme = context.colorScheme;
    final searchBloc = context.read<UnifiedSearchBloc>();

    return AppModalCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const UnifiedSearchHeader(),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
            child: CustomTextField(
              controller: _queryController,
              labelText: l10n.search,
              textInputAction: TextInputAction.search,
              maxSymbols: 200,
              onChanged: (String? value) {
                searchBloc.add(LoadUnifiedSearchEvent(query: value ?? ''));
              },
              onFocusChange: (String? value) {
                searchBloc.add(LoadUnifiedSearchEvent(query: value ?? ''));
              },
              onSubmitted: (String? value) {
                searchBloc.add(LoadUnifiedSearchEvent(query: value ?? ''));
              },
            ),
          ),
          Divider(height: 1, thickness: 1, color: colorScheme.outlineVariant),
          Expanded(
            child: BlocBuilder<UnifiedSearchBloc, UnifiedSearchState>(
              builder: (BuildContext context, UnifiedSearchState state) {
                final Object? failure = state.failure;

                if (failure != null && state is UnifiedSearchFailureState) {
                  return InfoWidget(
                    icon: Icons.error,
                    text: AppExceptionsTranslator.translate(context, failure),
                    useErrorStyle: true,
                    iconAnimationEffect: const ShakeEffect(),
                  );
                }

                final bool hasResults = switch (state) {
                  final UnifiedSearchLoadedState s =>
                    s.result.users.isNotEmpty ||
                        s.result.groups.isNotEmpty ||
                        s.result.channels.isNotEmpty ||
                        s.result.conversations.isNotEmpty,
                  _ => false,
                };

                final Widget body = _UnifiedSearchBody(
                  state: state,
                  selectedTab: _selectedTab,
                );

                if (!hasResults) {
                  return body;
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 10, 16, 6),
                      child: SegmentedControl(
                        compact: true,
                        segments: [
                          SegmentedControlSegment(
                            title: l10n.users,
                            icon: Icons.person_outline,
                          ),
                          SegmentedControlSegment(
                            title: l10n.conversationTypeGroup,
                            icon: Icons.group_outlined,
                          ),
                          SegmentedControlSegment(
                            title: l10n.conversationTypeChannel,
                            icon: Icons.campaign_outlined,
                          ),
                        ],
                        selectedIndex: _selectedTab.index,
                        onSelected: (int index) {
                          setState(() {
                            _selectedTab = _UnifiedSearchTab.values[index];
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: body,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _UnifiedSearchBody extends StatelessWidget {
  const _UnifiedSearchBody({required this.state, required this.selectedTab});

  final UnifiedSearchState state;
  final _UnifiedSearchTab selectedTab;

  String? _resolvePrivateConversationIdForUser(
    BuildContext context, {
    required String companionId,
  }) {
    // TODO: избавиться от этого блока и использовать api endpoint
    final AllConversationsListBloc? conversationsBloc = context
        .read<AllConversationsListBloc?>();
    if (conversationsBloc == null) {
      return null;
    }

    final AllConversationsListState conversationsState =
        conversationsBloc.state;

    if (conversationsState is! AllConversationsListLoadedState) {
      return null;
    }

    final ConversationTile? privateTile = conversationsState.conversationTiles
        .where(
          (ConversationTile tile) =>
              tile.type == ConversationTileType.private &&
              tile.companion?.userId == companionId,
        )
        .firstOrNull;

    return privateTile?.id;
  }

  List<UnifiedSearchListItem> _itemsForTab(
    UnifiedSearchLoadedState loadedState,
  ) {
    switch (selectedTab) {
      case _UnifiedSearchTab.users:
        final Map<String, UnifiedSearchConversation> conversationByCompanionId =
            <String, UnifiedSearchConversation>{};

        for (final UnifiedSearchConversation conversation
            in loadedState.result.conversations) {
          final String? companionId = conversation.companion?.userId;
          if (companionId == null || companionId.isEmpty) {
            continue;
          }
          conversationByCompanionId[companionId] = conversation;
        }

        return loadedState.result.users
            .map((User user) {
              final UnifiedSearchConversation? existingConversation =
                  conversationByCompanionId[user.userId];
              if (existingConversation != null) {
                return UnifiedSearchListItem.conversation(existingConversation);
              }
              return UnifiedSearchListItem.user(user);
            })
            .toList(growable: false);
      case _UnifiedSearchTab.groups:
        return loadedState.result.groups
            .map(UnifiedSearchListItem.conversation)
            .toList();
      case _UnifiedSearchTab.channels:
        return loadedState.result.channels
            .map(UnifiedSearchListItem.conversation)
            .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final l10n = context.l10n;

    if (state is UnifiedSearchInitialState) {
      return _UnifiedSearchPlaceholder(
        icon: Icons.search_rounded,
        text: l10n.searchUsersAndChatsHint,
      );
    }

    if (state is UnifiedSearchLoadingState) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 32),
          child: SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              color: colorScheme.primary,
            ),
          ),
        ),
      );
    }

    if (state is! UnifiedSearchLoadedState) {
      return const SizedBox.shrink();
    }

    final UnifiedSearchLoadedState loadedState =
        state as UnifiedSearchLoadedState;

    final List<UnifiedSearchListItem> items = _itemsForTab(loadedState);
    final bool isEmpty = items.isEmpty;

    if (isEmpty) {
      return _UnifiedSearchPlaceholder(
        icon: Icons.search_off_rounded,
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
      child: ListView.builder(
        padding: const EdgeInsets.only(top: 4, bottom: 16),
        itemCount: listItemsCount,
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

          return UnifiedSearchResultTile(
            item: items[index],
            onPressed: () {
              switch (items[index].type) {
                case UnifiedSearchListItemType.user:
                  final User? user = items[index].user;
                  if (user == null) {
                    return;
                  }
                  final String? existingConversationId =
                      _resolvePrivateConversationIdForUser(
                        context,
                        companionId: user.userId,
                      );
                  final GoRouter router = GoRouter.of(context);
                  Navigator.of(context).pop();
                  router.go(
                    existingConversationId == null
                        ? AppRoutes.conversationDraft(user.userId)
                        : AppRoutes.conversation(existingConversationId),
                  );
                case UnifiedSearchListItemType.conversation:
                  final UnifiedSearchConversation? conversation =
                      items[index].conversation;
                  if (conversation == null) {
                    return;
                  }
                  final GoRouter router = GoRouter.of(context);
                  Navigator.of(context).pop();
                  router.go(AppRoutes.conversation(conversation.id));
              }
            },
          );
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
        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 36, color: colorScheme.onSurfaceVariant),
            if (hasTitle) ...[
              const SizedBox(height: 12),
              Text(
                title!,
                style: textScheme.headline.copyWith(
                  color: colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            const SizedBox(height: 6),
            Text(
              text,
              style: textScheme.caption.copyWith(
                color: colorScheme.onSurfaceVariant,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
