import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/conversation/presentation/presentation.dart';
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

class _UnifiedSearchModalCardState extends State<UnifiedSearchModalCard> {
  late final TextEditingController _queryController;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _queryController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onQueryChanged(String value) {
    context.read<UnifiedSearchBloc>().add(LoadUnifiedSearchEvent(query: value));
  }

  void _clearQuery() {
    _queryController.clear();
    _onQueryChanged('');
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.escape): () =>
            Navigator.of(context).pop(),
      },
      child: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: 700,
              maxHeight: MediaQuery.of(context).size.height - 48,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Material(
                color: colorScheme.secondary,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // ── Search bar ───────────────────────────────────────
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: colorScheme.outline,
                            width: 1,
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.search,
                            size: 20,
                            color: colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              controller: _queryController,
                              focusNode: _focusNode,
                              onChanged: _onQueryChanged,
                              onSubmitted: _onQueryChanged,
                              style: TextStyle(
                                fontSize: 15,
                                color: colorScheme.onSurface,
                                height: 1.2,
                              ),
                              decoration: InputDecoration(
                                hintText: 'Search people and messages…',
                                hintStyle: TextStyle(
                                  fontSize: 15,
                                  color: colorScheme.onSurfaceVariant,
                                  height: 1.2,
                                ),
                                border: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          ValueListenableBuilder<TextEditingValue>(
                            valueListenable: _queryController,
                            builder: (_, value, __) {
                              if (value.text.isEmpty) {
                                return const SizedBox.shrink();
                              }
                              return GestureDetector(
                                onTap: _clearQuery,
                                child: Container(
                                  width: 28,
                                  height: 28,
                                  margin: const EdgeInsets.only(right: 6),
                                  decoration: BoxDecoration(
                                    color: colorScheme.surfaceContainer,
                                    border: Border.all(
                                      color: colorScheme.outline,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(7),
                                  ),
                                  child: Icon(
                                    Icons.close,
                                    size: 13,
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              );
                            },
                          ),
                          SurfaceIconButton(
                            variant: SurfaceIconVariant.ghost,
                            icon: Icons.close,
                            onPressed: () => Navigator.of(context).pop(),
                            dimension: 28,
                            iconSize: 18,
                            margin: EdgeInsets.zero,
                            tooltip: context.l10n.close,
                            foregroundColor: colorScheme.onSurfaceVariant,
                          ),
                        ],
                      ),
                    ),

                    // ── Results ──────────────────────────────────────────
                    Expanded(
                      child: BlocBuilder<UnifiedSearchBloc, UnifiedSearchState>(
                        builder: (context, state) {
                          if (state is UnifiedSearchFailureState &&
                              state.failure != null) {
                            return InfoWidget(
                              icon: Icons.error,
                              text: AppExceptionsTranslator.translate(
                                context,
                                state.failure!,
                              ),
                              useErrorStyle: true,
                              iconAnimationEffect: const ShakeEffect(),
                            );
                          }

                          if (state is UnifiedSearchInitialState) {
                            return _SearchPlaceholder(colorScheme: colorScheme);
                          }

                          if (state is UnifiedSearchLoadingState) {
                            return Center(
                              child: Padding(
                                padding: const EdgeInsets.all(32),
                                child: SizedBox(
                                  width: 22,
                                  height: 22,
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

                          final UnifiedSearchLoadedState loaded = state;
                          final List<User> people = loaded.result.users;
                          final List<UnifiedSearchConversation> messages =
                              loaded.result.conversations;

                          if (people.isEmpty && messages.isEmpty) {
                            return _SearchPlaceholder(
                              colorScheme: colorScheme,
                              isEmpty: true,
                            );
                          }

                          return _SearchResults(
                            people: people,
                            conversations: messages,
                            query: loaded.query,
                            colorScheme: colorScheme,
                            onPersonTap: (user) {
                              final String? conversationId =
                                  _resolvePrivateConversationIdForUser(
                                    context,
                                    companionId: user.userId,
                                  );
                              final router = GoRouter.of(context);
                              Navigator.of(context).pop();
                              router.go(
                                conversationId == null
                                    ? AppRoutes.conversationDraft(user.userId)
                                    : AppRoutes.conversation(conversationId),
                              );
                            },
                            onConversationTap: (conversation) {
                              final router = GoRouter.of(context);
                              Navigator.of(context).pop();
                              router.go(
                                AppRoutes.conversation(conversation.id),
                              );
                            },
                          );
                        },
                      ),
                    ),

                    // ── Keyboard hints footer ────────────────────────────
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(color: colorScheme.outline, width: 1),
                        ),
                      ),
                      child: const Row(
                        children: [
                          ModalKeyboardHint(
                            keyLabel: '↵',
                            description: 'Select',
                          ),
                          SizedBox(width: 12),
                          ModalKeyboardHint(
                            keyLabel: '↑↓',
                            description: 'Navigate',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String? _resolvePrivateConversationIdForUser(
    BuildContext context, {
    required String companionId,
  }) {
    final AllConversationsListBloc? conversationsBloc = context
        .read<AllConversationsListBloc?>();
    if (conversationsBloc == null) return null;

    final AllConversationsListState conversationsState =
        conversationsBloc.state;
    if (conversationsState is! AllConversationsListLoadedState) return null;

    final ConversationTile? privateTile = conversationsState.conversationTiles
        .where(
          (tile) =>
              tile.type == ConversationTileType.private &&
              tile.companion?.userId == companionId,
        )
        .firstOrNull;

    return privateTile?.id;
  }
}

// ── Section results widget ────────────────────────────────────────────────────

class _SearchResults extends StatelessWidget {
  const _SearchResults({
    required this.people,
    required this.conversations,
    required this.query,
    required this.colorScheme,
    required this.onPersonTap,
    required this.onConversationTap,
  });

  final List<User> people;
  final List<UnifiedSearchConversation> conversations;
  final String query;
  final AppColorScheme colorScheme;
  final ValueChanged<User> onPersonTap;
  final ValueChanged<UnifiedSearchConversation> onConversationTap;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(bottom: 8),
      children: [
        if (people.isNotEmpty) ...[
          _SectionHeader(label: 'PEOPLE', colorScheme: colorScheme),
          ...people.map(
            (user) => _PersonTile(
              user: user,
              query: query,
              colorScheme: colorScheme,
              onTap: () => onPersonTap(user),
            ),
          ),
        ],
        if (conversations.isNotEmpty) ...[
          _SectionHeader(label: 'MESSAGES', colorScheme: colorScheme),
          ...conversations.map(
            (conversation) => _ConversationMessageTile(
              conversation: conversation,
              query: query,
              colorScheme: colorScheme,
              onTap: () => onConversationTap(conversation),
            ),
          ),
        ],
      ],
    );
  }
}

// ── Section header ────────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.label, required this.colorScheme});

  final String label;
  final AppColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 6),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: colorScheme.onSurfaceVariant,
          letterSpacing: 0.8,
          height: 1.2,
        ),
      ),
    );
  }
}

// ── Person tile ───────────────────────────────────────────────────────────────

class _PersonTile extends StatelessWidget {
  const _PersonTile({
    required this.user,
    required this.query,
    required this.colorScheme,
    required this.onTap,
  });

  final User user;
  final String query;
  final AppColorScheme colorScheme;
  final VoidCallback onTap;

  static const Color _onlineColor = Color(0xFF4CAF79);

  @override
  Widget build(BuildContext context) {
    final String fullName = ProfileDataExtractor.extractUserFullName(user);
    final String initials = ProfileDataExtractor.extractUserInitials(user);
    final String role =
        (user.description != null && user.description!.isNotEmpty)
        ? user.description!
        : (user.username.isNotEmpty ? '@${user.username}' : '');

    final radii = context.radii;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: radii.defaultRadiusValue,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            children: [
              Stack(
                children: [
                  ConversationAvatar(text: initials, size: 42, isOnline: true),
                ],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _HighlightedText(
                      text: fullName,
                      query: query,
                      baseStyle: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                        height: 1.2,
                      ),
                      highlightColor: colorScheme.primary,
                    ),
                    if (role.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        role,
                        style: TextStyle(
                          fontSize: 12,
                          color: colorScheme.onSurfaceVariant,
                          height: 1.2,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: _onlineColor,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Conversation/message tile ─────────────────────────────────────────────────

class _ConversationMessageTile extends StatelessWidget {
  const _ConversationMessageTile({
    required this.conversation,
    required this.query,
    required this.colorScheme,
    required this.onTap,
  });

  final UnifiedSearchConversation conversation;
  final String query;
  final AppColorScheme colorScheme;
  final VoidCallback onTap;

  static const Color _onlineColor = Color(0xFF4CAF79);

  @override
  Widget build(BuildContext context) {
    final String title = conversation.title;
    final String initials = title.length >= 2
        ? title.substring(0, 2).toUpperCase()
        : title.toUpperCase();

    final String? companionName = conversation.companion != null
        ? ProfileDataExtractor.extractUserFullName(conversation.companion!)
        : null;
    final String senderName = companionName ?? title;

    final radii = context.radii;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: radii.defaultRadiusValue,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  ConversationAvatar(text: initials, size: 40, isOnline: true),
                ],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _HighlightedText(
                            text: senderName,
                            query: query,
                            baseStyle: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: colorScheme.onSurface,
                              height: 1.2,
                            ),
                            highlightColor: colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    _HighlightedText(
                      text: title,
                      query: query,
                      baseStyle: TextStyle(
                        fontSize: 13,
                        color: colorScheme.onSurfaceVariant,
                        height: 1.3,
                      ),
                      highlightColor: colorScheme.primary,
                      maxLines: 2,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 7,
                height: 7,
                margin: const EdgeInsets.only(top: 4),
                decoration: const BoxDecoration(
                  color: _onlineColor,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Highlighted text (search term bold/colored) ───────────────────────────────

class _HighlightedText extends StatelessWidget {
  const _HighlightedText({
    required this.text,
    required this.query,
    required this.baseStyle,
    required this.highlightColor,
    this.maxLines,
  });

  final String text;
  final String query;
  final TextStyle baseStyle;
  final Color highlightColor;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    if (query.isEmpty) {
      return Text(
        text,
        style: baseStyle,
        maxLines: maxLines,
        overflow: maxLines != null ? TextOverflow.ellipsis : null,
      );
    }

    final List<TextSpan> spans = <TextSpan>[];
    final String lowerText = text.toLowerCase();
    final String lowerQuery = query.toLowerCase();
    int start = 0;

    while (true) {
      final int idx = lowerText.indexOf(lowerQuery, start);
      if (idx == -1) {
        spans.add(TextSpan(text: text.substring(start)));
        break;
      }
      if (idx > start) {
        spans.add(TextSpan(text: text.substring(start, idx)));
      }
      spans.add(
        TextSpan(
          text: text.substring(idx, idx + query.length),
          style: TextStyle(
            color: highlightColor,
            fontWeight: FontWeight.w600,
            backgroundColor: highlightColor.withAlpha(30),
          ),
        ),
      );
      start = idx + query.length;
    }

    return RichText(
      text: TextSpan(style: baseStyle, children: spans),
      maxLines: maxLines,
      overflow: maxLines != null ? TextOverflow.ellipsis : TextOverflow.clip,
    );
  }
}

// ── Keyboard hint chip ────────────────────────────────────────────────────────

// ── Empty / initial placeholder ───────────────────────────────────────────────

class _SearchPlaceholder extends StatelessWidget {
  const _SearchPlaceholder({required this.colorScheme, this.isEmpty = false});

  final AppColorScheme colorScheme;
  final bool isEmpty;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isEmpty ? Icons.search_off_rounded : Icons.search_rounded,
              size: 36,
              color: colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 12),
            Text(
              isEmpty ? 'Nothing found' : 'Search people and messages',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              isEmpty
                  ? 'Try a different search term'
                  : 'Start typing to search across conversations',
              style: TextStyle(
                fontSize: 12,
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
