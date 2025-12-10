// conversations_list_panel.dart

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/conversation/subfeatures/private/presentation/presentation.dart';
import 'package:locnet_app/features/conversations/data/data.dart';
import 'package:locnet_app/features/conversations/domain/domain.dart';
import 'package:locnet_app/features/conversations/presentation/presentation.dart';

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
              conversationsListRepo: context.read<IConversationsListRepo>(),
              conversationsListInteractor: context
                  .read<ConversationsListInteractor>(),
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
  const ConversationsPanel({super.key, this.selectedConversationId});

  final String? selectedConversationId;

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
    final textScheme = context.textScheme;

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
          width: 2,
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
            child: widget.selectedConversationId == null
                ? Center(
                    child: Text(
                      'Select a conversation to start chatting',
                      style: textScheme.label,
                      textAlign: TextAlign.center,
                    ),
                  )
                : PrivateConversationScreenWrapper(
                    key: ValueKey<String>(widget.selectedConversationId!),
                    conversationId: widget.selectedConversationId!,
                    child: PrivateConversationScreen(
                      conversationId: widget.selectedConversationId!,
                    ),
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
    return BlocBuilder<AllConversationsListBloc, AllConversationsListState>(
      builder: (context, state) {
        switch (state) {
          case AllConversationsListLoadingState():
            return const Center(child: CircularProgressIndicator());

          case AllConversationsListFailureState():
            return InfoWidget(
              icon: Icons.error,
              text: state.failure.toString(),
              iconAnimationEffect: const ShakeEffect(),
            );

          case AllConversationsListLoadedState():
            final List<ConversationTile> tiles = state.conversationTiles;

            if (tiles.isEmpty) {
              return const Center(child: Text('Empty here...'));
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!isCompact) const ChipsBar(),
                Expanded(
                  child: ListView.separated(
                    itemCount: tiles.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 5),
                    itemBuilder: (BuildContext context, int index) {
                      final ConversationTile tile = tiles[index];

                      return Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: isCompact ? 4 : 7,
                        ),
                        child: ConversationListTile(
                          conversationTile: tile,
                          isSelected:
                              tile.conversation.conversationId ==
                              selectedConversationId,
                          isCompact: isCompact,
                          onTap: () {
                            GoRouter.of(context).go(
                              AppRoutes.conversation(
                                tile.conversation.conversationId,
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            );

          case AllConversationsListInitial():
            return const SizedBox.shrink();
        }
      },
    );
  }
}
