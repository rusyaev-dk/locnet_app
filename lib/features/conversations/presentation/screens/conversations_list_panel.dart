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

class ConversationsPanel extends StatelessWidget {
  const ConversationsPanel({super.key, this.selectedTile});

  final ConversationTile? selectedTile;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textScheme = context.textScheme;

    return Row(
      children: [
        const SizedBox(width: 320, child: _ConversationsListPanel()),
        VerticalDivider(
          width: 0.45,
          color: colorScheme.surfaceContainer.withAlpha(100),
        ),
        Expanded(
          child: selectedTile == null
              ? Center(
                  child: Text(
                    'Select a conversation to start chatting',
                    style: textScheme.label,
                    textAlign: TextAlign.center,
                  ),
                )
              : PrivateConversationScreenWrapper(
                  conversationId: selectedTile!.conversation.id,
                  companionId: selectedTile!.companionId ?? '',
                  child: PrivateConversationScreen(
                    conversationId: selectedTile!.conversation.id,
                    companionId: selectedTile!.companionId ?? '',
                  ),
                ),
        ),
      ],
    );
  }
}

class _ConversationsListPanel extends StatelessWidget {
  const _ConversationsListPanel();

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
                const ChipsBar(),
                Expanded(
                  child: ListView.separated(
                    itemCount: tiles.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 5),
                    itemBuilder: (BuildContext context, int index) {
                      final ConversationTile tile = tiles[index];

                      return Padding(
                        padding: const EdgeInsetsGeometry.symmetric(
                          horizontal: 7,
                        ),
                        child: ConversationListTile(
                          conversationTile: tile,
                          onTap: () {
                            GoRouter.of(context).go(
                              AppRoutes.conversation(tile.conversation.id),
                              extra: tile,
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
