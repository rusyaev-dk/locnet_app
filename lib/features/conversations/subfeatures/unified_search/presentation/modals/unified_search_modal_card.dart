import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/conversation/domain/domain.dart';
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
                  _UnifiedSearchField(controller: _queryController),
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

class _UnifiedSearchField extends StatelessWidget {
  const _UnifiedSearchField({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final UnifiedSearchBloc bloc = context.read<UnifiedSearchBloc>();

    return CustomTextField(
      controller: controller,
      labelText: l10n.search,
      textInputAction: TextInputAction.search,
      maxSymbols: 200,
      onChanged: (String? value) {
        bloc.add(LoadUnifiedSearchEvent(query: value ?? ''));
      },
      onFocusChange: (String? value) {
        bloc.add(LoadUnifiedSearchEvent(query: value ?? ''));
      },
      onSubmitted: (String? value) {
        bloc.add(LoadUnifiedSearchEvent(query: value ?? ''));
      },
    );
  }
}

class _UnifiedSearchBody extends StatelessWidget {
  const _UnifiedSearchBody({required this.state});

  final UnifiedSearchState state;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textScheme = context.textScheme;
    final l10n = context.l10n;

    if (state is UnifiedSearchInitialState) {
      return _UnifiedSearchPlaceholder(
        icon: Icons.search,
        title: l10n.search,
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

    final List<User> users = loadedState.result.users;
    final List<Conversation> conversations = loadedState.result.conversations;

    final bool isEmpty = users.isEmpty && conversations.isEmpty;

    if (isEmpty) {
      return _UnifiedSearchPlaceholder(
        icon: Icons.search_off,
        title: l10n.nothingFound,
        text: l10n.tryAnotherQuery,
      );
    }

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
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (users.isNotEmpty) ...[
              const SizedBox(height: 6),
              Text(
                l10n.users,
                style: textScheme.label.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 8),
              AppTileButtonGroupCard(
                children: users
                    .map((User user) {
                      return UnifiedSearchResultTile(
                        icon: Icons.person_outline,
                        title: _resolveUserTitle(user),
                        subtitle: _resolveUserSubtitle(user),
                        onPressed: () {
                          // Handle navigation outside or via callback if needed
                        },
                      );
                    })
                    .toList(growable: false),
              ),
            ],
            if (conversations.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(
                l10n.chats,
                style: textScheme.label.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 8),
              AppTileButtonGroupCard(
                children: conversations
                    .map((Conversation conversation) {
                      return UnifiedSearchResultTile(
                        icon: Icons.forum_outlined,
                        title: _resolveConversationTitle(conversation),
                        subtitle: _resolveConversationSubtitle(conversation),
                        onPressed: () {
                          // Handle navigation outside or via callback if needed
                        },
                      );
                    })
                    .toList(growable: false),
              ),
            ],
            if (loadedState.isLoadingMore) ...[
              const SizedBox(height: 14),
              Center(
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
              ),
            ] else if (loadedState.hasMore) ...[
              const SizedBox(height: 10),
            ],
          ],
        ),
      ),
    );
  }

  String _resolveUserTitle(User user) {
    // Replace with your real fields, e.g. user.displayName / user.username.
    return user.toString();
  }

  String? _resolveUserSubtitle(User user) {
    // Example: return user.username != null ? '@${user.username}' : null;
    return null;
  }

  String _resolveConversationTitle(Conversation conversation) {
    // Replace with your real fields, e.g. conversation.title.
    return conversation.toString();
  }

  String? _resolveConversationSubtitle(Conversation conversation) {
    // Example: return conversation.type == ConversationType.channel ? 'Канал' : 'Группа';
    return null;
  }
}

class _UnifiedSearchPlaceholder extends StatelessWidget {
  const _UnifiedSearchPlaceholder({
    required this.icon,
    required this.title,
    required this.text,
  });

  final IconData icon;
  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textScheme = context.textScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 34, color: colorScheme.onSurfaceVariant),
            const SizedBox(height: 10),
            Text(
              title,
              style: textScheme.display.copyWith(
                color: colorScheme.onSurface,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
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
