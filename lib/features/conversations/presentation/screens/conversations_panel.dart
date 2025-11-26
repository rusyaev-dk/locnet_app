import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/conversation/presentation/presentation.dart';
import 'package:locnet_app/features/conversations/data/data.dart';
import 'package:locnet_app/features/conversations/domain/domain.dart';
import 'package:locnet_app/features/conversations/presentation/presentation.dart';
import 'package:locnet_app/uikit/uikit.dart';

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
      child: BlocProvider(
        create: (BuildContext context) => AllConversationsListBloc(
          conversationsListRepo: context.read<IConversationsListRepo>(),
          conversationsListInteractor: context
              .read<ConversationsListInteractor>(),
          logger: context.read<ILogger>(),
        )..add(const AllConversationsListLoadEvent()),
        child: child,
      ),
    );
  }
}

class ConversationsPanel extends StatelessWidget {
  const ConversationsPanel({required this.selectedConversationId, super.key});

  final String? selectedConversationId;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    return Row(
      children: [
        const SizedBox(width: 320, child: _ConversationsListPanel()),
        VerticalDivider(
          width: 0.45,
          color: colorScheme.surfaceContainer.withAlpha(100),
        ),
        Expanded(
          child: selectedConversationId == null
              ? const _ConversationEmptyPlaceholder()
              : ConversationChatPanel(conversationId: selectedConversationId!),
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
      builder: (BuildContext context, AllConversationsListState state) {
        switch (state) {
          case AllConversationsListLoadingState():
            return const Center(child: CircularProgressIndicator());

          case AllConversationsListFailureState():
            return _ConversationsErrorPlaceholder(error: state.failure);

          case AllConversationsListLoadedState():
            final List<ConversationTile> tiles = state.conversationTiles;

            if (tiles.isEmpty) {
              return const Center(child: Text('Empty here...'));
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _ChipsBar(),
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
                        child: ConversationListTile(conversationTile: tile),
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

class _ChipsBar extends StatelessWidget {
  const _ChipsBar();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return SizedBox(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,

        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Row(
            children: [
              const SizedBox(width: 8),
              ChipButton(
                icon: Icons.add,
                label: l10n.create,
                onPressed: () {
                  showGeneralDialog(
                    context: context,
                    pageBuilder: (_, _, _) {
                      return const ConversationCreatorModalWrapper(
                        child: ConversationCreatorModalCard(),
                      );
                    },
                  );
                },
              ),
              const SizedBox(width: 8),
              ChipButton(
                icon: Icons.search,
                label: l10n.search,
                onPressed: () {},
              ),
              const SizedBox(width: 8),
              ChipButton(label: 'Mock', onPressed: () {}),
              const SizedBox(width: 8),
              ChipButton(label: 'Mock', onPressed: () {}),
              const SizedBox(width: 8),
              ChipButton(label: 'Mock', onPressed: () {}),
              const SizedBox(width: 8),
              ChipButton(label: 'Mock', onPressed: () {}),
              const SizedBox(width: 8),
              ChipButton(label: 'Mock', onPressed: () {}),
            ],
          ),
        ),
      ),
    );
  }
}

class _ConversationsErrorPlaceholder extends StatelessWidget {
  const _ConversationsErrorPlaceholder({required this.error});

  final Object? error;

  @override
  Widget build(BuildContext context) {
    final textScheme = context.textScheme;

    return Center(
      child: Text(
        error?.toString() ?? 'Unknown error',
        style: textScheme.label,
        textAlign: TextAlign.center,
      ),
    );
  }
}

class _ConversationEmptyPlaceholder extends StatelessWidget {
  const _ConversationEmptyPlaceholder();

  @override
  Widget build(BuildContext context) {
    final textScheme = context.textScheme;

    return Center(
      child: Text(
        'Select a conversation to start chatting',
        style: textScheme.label,
        textAlign: TextAlign.center,
      ),
    );
  }
}

class ConversationChatPanel extends StatelessWidget {
  const ConversationChatPanel({required this.conversationId, super.key});

  final String conversationId;

  @override
  Widget build(BuildContext context) {
    final textScheme = context.textScheme;

    return Center(
      child: Text(
        'Chat for conversation: $conversationId',
        style: textScheme.label,
      ),
    );
  }
}
