// conversations_list_panel.dart

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/conversation/subfeatures/channel/presentation/presentation.dart';
import 'package:locnet_app/features/conversation/subfeatures/conversation_creator/presentation/modals/conversation_creator_modal_card.dart';
import 'package:locnet_app/features/conversation/subfeatures/group/presentation/presentation.dart';
import 'package:locnet_app/features/conversation/subfeatures/private/presentation/presentation.dart';
import 'package:locnet_app/features/conversations_list/data/data.dart';
import 'package:locnet_app/features/conversations_list/domain/domain.dart';
import 'package:locnet_app/features/conversations_list/presentation/presentation.dart';
import 'package:locnet_app/features/conversations_list/subfeatures/unified_search/presentation/presentation.dart';

class ConversationsPanelWrapper extends StatelessWidget {
  const ConversationsPanelWrapper({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<ConversationsListInteractor>(
          create: (BuildContext context) => ConversationsListInteractor(
            conversationsListRepo: context.read<IConversationsListRepo>(),
          ),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (BuildContext context) => AllConversationsListBloc(
              conversationsListInteractor: context
                  .read<ConversationsListInteractor>(),
              userInteractor: context.read<UserInteractor>(),
              logger: context.read<ILogger>(),
            )..add(const AllConversationsListLoadEvent()),
          ),
        ],
        child: child,
      ),
    );
  }
}

class ConversationsPanel extends StatefulWidget {
  const ConversationsPanel({
    super.key,
    this.selectedConversationId,
    this.draftCompanionId,
  });

  final String? selectedConversationId;
  final String? draftCompanionId;

  @override
  State<ConversationsPanel> createState() => _ConversationsPanelState();
}

class _ConversationsPanelState extends State<ConversationsPanel> {
  static const double _panelMaxWidth = 420;
  static const double _panelMinWidth = 64;
  static const double _panelCompactBreakpoint = 300;

  double _panelWidth = _panelCompactBreakpoint;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final spacing = context.designTokens.spacing;

    final bool isCompact = _panelWidth <= _panelMinWidth;

    return Row(
      children: [
        SizedBox(
          width: _panelWidth,
          child: _ConversationsListPanel(
            isCompact: isCompact,
            selectedConversationId: widget.selectedConversationId,
          ),
        ),
        SizedBox(
          width: context.borders.thin + 1,
          child: MouseRegion(
            cursor: SystemMouseCursors.resizeLeftRight,
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onHorizontalDragUpdate: (DragUpdateDetails details) {
                setState(() {
                  final double proposedWidth = _panelWidth + details.delta.dx;

                  final bool isCurrentlyCompact = _panelWidth <= _panelMinWidth;

                  if (!isCurrentlyCompact) {
                    final bool isAtCompactBreakpoint =
                        _panelWidth == _panelCompactBreakpoint;

                    if (isAtCompactBreakpoint &&
                        details.globalPosition.distance < 600) {
                      return;
                    }

                    if (proposedWidth <= _panelCompactBreakpoint) {
                      if (details.globalPosition.dx > 490) {
                        return;
                      }
                      _panelWidth = _panelMinWidth;
                    } else {
                      _panelWidth = proposedWidth.clamp(
                        _panelMinWidth,
                        _panelMaxWidth,
                      );
                    }

                    return;
                  }

                  // currently compact
                  if (details.delta.dx > 0) {
                    _panelWidth = _panelCompactBreakpoint;
                  }
                });
              },

              child: Align(
                alignment: Alignment.centerRight,
                child: VerticalDivider(
                  width: 0.45,
                  color: colorScheme.surfaceContainer.withAlpha(100),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Container(
            color: colorScheme.surface,
            child: widget.draftCompanionId != null
                ? PrivateConversationScreenWrapper(
                    key: ValueKey<String>('draft-${widget.draftCompanionId!}'),
                    draftCompanionId: widget.draftCompanionId!,
                    child: PrivateConversationScreen(
                      draftCompanionId: widget.draftCompanionId!,
                    ),
                  )
                : widget.selectedConversationId == null
                ? Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: spacing.xl),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.chat_bubble_outline,
                            size: spacing.xxl + spacing.xxs,
                            color: context.colorScheme.onSurfaceVariant,
                          ),
                          SizedBox(height: spacing.sm),
                          Text(
                            context.l10n.selectConversation,
                            style: context.textScheme.title.copyWith(
                              color: context.colorScheme.onSurface,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: spacing.xs - spacing.xxs / 2),
                          Text(
                            context.l10n.selectConversationSubtitle,
                            style: context.textScheme.caption.copyWith(
                              color: context.colorScheme.onSurfaceVariant,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  )
                : BlocBuilder<
                    AllConversationsListBloc,
                    AllConversationsListState
                  >(
                    builder: (context, state) {
                      if (state is! AllConversationsListLoadedState) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      final ConversationTile? selectedTile = state
                          .conversationTiles
                          .where(
                            (ConversationTile tile) =>
                                tile.id == widget.selectedConversationId,
                          )
                          .firstOrNull;

                      if (selectedTile == null) {
                        context.read<AllConversationsListBloc>().add(
                          const AllConversationsListLoadEvent(),
                        );
                        return const Center(child: CircularProgressIndicator());
                      }

                      final ConversationTileType conversationType =
                          selectedTile.type;

                      switch (conversationType) {
                        case ConversationTileType.private:
                          return PrivateConversationScreenWrapper(
                            key: ValueKey<String>(
                              widget.selectedConversationId!,
                            ),
                            conversationId: widget.selectedConversationId!,
                            initialCompanion: selectedTile.companion,
                            child: PrivateConversationScreen(
                              conversationId: widget.selectedConversationId!,
                              initialCompanion: selectedTile.companion,
                            ),
                          );

                        case ConversationTileType.group:
                          return GroupConversationScreenWrapper(
                            key: ValueKey<String>(
                              widget.selectedConversationId!,
                            ),
                            conversationId: widget.selectedConversationId!,
                            child: GroupConversationScreen(
                              conversationId: widget.selectedConversationId!,
                            ),
                          );

                        case ConversationTileType.channel:
                          return ChannelConversationScreenWrapper(
                            key: ValueKey<String>(
                              widget.selectedConversationId!,
                            ),
                            conversationId: widget.selectedConversationId!,
                            child: ChannelConversationScreen(
                              conversationId: widget.selectedConversationId!,
                            ),
                          );
                      }
                    },
                  ),
          ),
        ),
      ],
    );
  }
}

class _ConversationsListPanel extends StatelessWidget {
  const _ConversationsListPanel({
    required this.isCompact,
    this.selectedConversationId,
  });

  final bool isCompact;
  final String? selectedConversationId;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final spacing = context.designTokens.spacing;
    final l10n = context.l10n;

    return ToastListener<
      AllConversationsListBloc,
      AllConversationsListState,
      AllConversationsListState
    >(
      bloc: context.read<AllConversationsListBloc>(),
      messageOf: (BuildContext context, AllConversationsListState state) {
        return AppExceptionsTranslator.translate(context, state.failure);
      },
      child: BlocBuilder<AllConversationsListBloc, AllConversationsListState>(
        builder: (context, state) {
          switch (state) {
            case AllConversationsListLoadingState():
              return Container(
                decoration: BoxDecoration(color: colorScheme.surface),
                child: const Center(child: CircularProgressIndicator()),
              );

            case AllConversationsListFailureState():
              return InfoWidget(
                icon: Icons.error,
                text: AppExceptionsTranslator.translate(context, state.failure),
                useErrorStyle: true,
                iconAnimationEffect: const ShakeEffect(),
              );

            case AllConversationsListLoadedState():
              final List<ConversationTile> tiles = state.conversationTiles;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _ConversationsListHeader(isCompact: isCompact),
                  Expanded(
                    child: tiles.isEmpty
                        ? Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: spacing.lg,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.forum_outlined,
                                    size: spacing.xxl + spacing.xs,
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                  SizedBox(height: spacing.sm),
                                  Text(
                                    l10n.conversationsListEmptyTitle,
                                    style: context.textScheme.title.copyWith(
                                      color: colorScheme.onSurface,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(
                                    height: spacing.xs - spacing.xxs / 2,
                                  ),
                                  Text(
                                    l10n.conversationsListEmptySubtitle,
                                    style: context.textScheme.caption.copyWith(
                                      color: colorScheme.onSurfaceVariant,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          )
                        : NotificationListener<ScrollUpdateNotification>(
                            onNotification:
                                (ScrollUpdateNotification scrollInfo) {
                                  if (!state.hasMore || state.isLoadingMore) {
                                    return false;
                                  }

                                  if (scrollInfo.metrics.pixels >=
                                      scrollInfo.metrics.maxScrollExtent *
                                          0.8) {
                                    final int nextPage = state.page + 1;
                                    context
                                        .read<AllConversationsListBloc>()
                                        .add(
                                          AllConversationsListLoadMoreEvent(
                                            page: nextPage,
                                          ),
                                        );
                                  }

                                  return false;
                                },
                            child: ListView.builder(
                              itemCount:
                                  tiles.length + (state.isLoadingMore ? 1 : 0),
                              itemBuilder: (BuildContext context, int index) {
                                if (index == tiles.length) {
                                  return Padding(
                                    padding: EdgeInsets.all(spacing.md),
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        color: colorScheme.primary,
                                      ),
                                    ),
                                  );
                                }

                                final ConversationTile tile = tiles[index];

                                return ConversationListTile(
                                  key: ValueKey<String>(tile.id),
                                  conversationTile: tile,
                                  isSelected: tile.id == selectedConversationId,
                                  currentUserId: state.currentUserId,
                                  isCompact: isCompact,
                                  onTap: () {
                                    GoRouter.of(
                                      context,
                                    ).go(AppRoutes.conversation(tile.id));
                                  },
                                );
                              },
                            ),
                          ),
                  ),
                ],
              );

            case AllConversationsListInitial():
              return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}

class _ConversationsListHeader extends StatelessWidget {
  const _ConversationsListHeader({required this.isCompact});

  final bool isCompact;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final l10n = context.l10n;

    if (isCompact) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: IconButton(
          icon: Icon(
            Icons.search,
            color: colorScheme.onSurfaceVariant,
            size: 20,
          ),
          onPressed: () => _openUnifiedSearch(context),
        ),
      );
    }

    return Container(
      color: colorScheme.secondary,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 12, 10),
            child: Row(
              children: [
                Text(
                  l10n.conversations,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                    height: 1.2,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    showGeneralDialog(
                      context: context,
                      transitionBuilder: slideFadeDialogTransition,
                      pageBuilder: (_, _, _) {
                        return const ConversationCreatorModalWrapper(
                          child: ConversationCreatorModalCard(),
                        );
                      },
                    );
                  },
                  child: Icon(
                    Icons.edit_outlined,
                    size: 18,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
            child: GestureDetector(
              onTap: () => _openUnifiedSearch(context),
              child: Container(
                height: 34,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainer,
                  border: Border.all(color: colorScheme.outline, width: 1),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.search,
                      size: 16,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${l10n.search}…',
                      style: TextStyle(
                        fontSize: 13,
                        color: colorScheme.onSurfaceVariant,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _openUnifiedSearch(BuildContext context) {
    showGeneralDialog(
      context: context,
      transitionBuilder: slideFadeDialogTransition,
      pageBuilder: (_, _, _) {
        return const UnifiedSearchModalCardWrapper(
          child: UnifiedSearchModalCard(),
        );
      },
    );
  }
}
