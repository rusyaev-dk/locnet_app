import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/conversation/data/data.dart';
import 'package:locnet_app/features/conversation/domain/domain.dart';
import 'package:locnet_app/features/conversations/domain/domain.dart';
import 'package:locnet_app/features/conversations/presentation/presentation.dart';

class ConversationsScreenWrapper extends StatelessWidget {
  const ConversationsScreenWrapper({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<ConversationsListInteractor>(
          create: (context) => ConversationsListInteractor(
            conversationRepo: context.read<IConversationRepo>(),
          ),
        ),
      ],
      child: BlocProvider(
        create: (context) => AllConversationsListBloc(
          conversationRepo: context.read<IConversationRepo>(),
          conversationsListInteractor: context
              .read<ConversationsListInteractor>(),
          logger: context.read<ILogger>(),
        ),
        child: child,
      ),
    );
  }
}

class ConversationsScreen extends StatelessWidget {
  const ConversationsScreen({required this.selectedConversationId, super.key});

  final String? selectedConversationId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AllConversationsListBloc>(
      create: (BuildContext context) {
        // TODO: inject real interactor, repo, logger from DI.
        final ConversationsListInteractor interactor = context
            .read<ConversationsListInteractor>();
        final IConversationRepo conversationRepo = context
            .read<IConversationRepo>();
        final ILogger logger = context.read<ILogger>();

        return AllConversationsListBloc(
          conversationsListInteractor: interactor,
          logger: logger,
          conversationRepo: conversationRepo,
        )..add(const AllConversationsListLoadEvent());
      },
      child: Row(
        children: <Widget>[
          const SizedBox(width: 320, child: _ConversationsListPanel()),
          const VerticalDivider(width: 1),
          Expanded(
            child: selectedConversationId == null
                ? const _ConversationEmptyPlaceholder()
                : ConversationChatPanel(
                    conversationId: selectedConversationId!,
                  ),
          ),
        ],
      ),
    );
  }
}

class _ConversationsListPanel extends StatelessWidget {
  const _ConversationsListPanel();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AllConversationsListBloc, AllConversationsListState>(
      builder: (BuildContext context, AllConversationsListState state) {
        if (state is AllConversationsListLoadingState) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is AllConversationsListFailureState) {
          return Center(child: Text(state.failure.toString()));
        }

        if (state is AllConversationsListLoadedState) {
          final List<Conversation> conversations = state.conversations;

          return ListView.builder(
            itemCount: conversations.length,
            itemBuilder: (BuildContext context, int index) {
              final Conversation conversation = conversations[index];

              return _ConversationListTile(conversation: conversation);
            },
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}

class _ConversationListTile extends StatelessWidget {
  const _ConversationListTile({required this.conversation});

  final Conversation conversation;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return ListTile(
      onTap: () {
        context.go('/home/conversations/${conversation.id}');
      },
      title: Text(conversation.title, style: theme.textTheme.bodyMedium),
      // subtitle: conversation.lastMessage != null
      //     ? Text(
      //         conversation.lastMessage!.text,
      //         maxLines: 1,
      //         overflow: TextOverflow.ellipsis,
      //       )
      //     : null,
    );
  }
}

class _ConversationEmptyPlaceholder extends StatelessWidget {
  const _ConversationEmptyPlaceholder();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Center(
      child: Text(
        'Select a conversation to start chatting',
        style: theme.textTheme.bodyMedium,
      ),
    );
  }
}

/// Chat panel for selected conversation.
class ConversationChatPanel extends StatelessWidget {
  const ConversationChatPanel({required this.conversationId, super.key});

  final String conversationId;

  @override
  Widget build(BuildContext context) {
    // TODO: implement chat layout and messages list.
    return Center(child: Text('Chat for conversation: $conversationId'));
  }
}
