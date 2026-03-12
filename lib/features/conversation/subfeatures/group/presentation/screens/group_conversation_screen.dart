import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/conversation/domain/domain.dart';
import 'package:locnet_app/features/conversation/subfeatures/group/data/data.dart';
import 'package:locnet_app/features/conversation/subfeatures/group/domain/domain.dart';
import 'package:locnet_app/features/conversation/subfeatures/group/presentation/presentation.dart';
import 'package:locnet_app/features/message/data/data.dart';
import 'package:locnet_app/features/message/subfeatures/group_message/domain/domain.dart';
import 'package:locnet_app/features/message/subfeatures/group_message/presentation/presentation.dart';
import 'package:locnet_app/features/message/subfeatures/message_input/presentation/presentation.dart';

class GroupConversationScreenWrapper extends StatelessWidget {
  const GroupConversationScreenWrapper({
    required this.child,
    required this.conversationId,
    super.key,
  });

  final Widget child;
  final String conversationId;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<IGroupRepo>(
          create: (context) =>
              context.read<IAppEnvPreset>().createGroupConversationRepo(),
        ),
        RepositoryProvider<GroupConversationInteractor>(
          create: (BuildContext context) => GroupConversationInteractor(
            groupConversationRepo: context.read<IGroupRepo>(),
          ),
        ),
        RepositoryProvider<GroupMessageInteractor>(
          create: (BuildContext context) => GroupMessageInteractor(
            messageRepo: context.read<IGroupMessageRepo>(),
          ),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                GroupConversationBloc(
                  groupConversationInteractor: context
                      .read<GroupConversationInteractor>(),
                  logger: context.read<ILogger>(),
                )..add(
                  GroupConversationStartedEvent(conversationId: conversationId),
                ),
          ),
          BlocProvider(create: (context) => MessageAttachmentsCubit()),
          BlocProvider(
            create: (context) => GroupMessageActionsCubit(
              groupMessageInteractor: context.read<GroupMessageInteractor>(),
              userInteractor: context.read<UserInteractor>(),
              logger: context.read<ILogger>(),
            ),
          ),
        ],
        child: child,
      ),
    );
  }
}

class GroupConversationScreen extends StatelessWidget {
  const GroupConversationScreen({required this.conversationId, super.key});

  final String conversationId;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final l10n = context.l10n;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: BlocBuilder<GroupConversationBloc, GroupConversationState>(
            builder: (BuildContext context, GroupConversationState state) {
              switch (state) {
                case GroupConversationLoadingState():
                  return const GroupConversationLoadingShimmer();

                case GroupConversationFailureState():
                  return InfoWidget(
                    icon: Icons.error,
                    text: state.failure.toString(),
                    useErrorStyle: true,
                    buttonText: l10n.retry,
                    onButtonPressed: () =>
                        context.read<GroupConversationBloc>().add(
                          GroupConversationStartedEvent(
                            conversationId: conversationId,
                          ),
                        ),
                    iconAnimationEffect: const ShakeEffect(),
                  );

                case GroupConversationLoadedState():
                  final List<GroupMessage> messages = state.messages;

                  if (messages.isEmpty) {
                    return const Text("Empty here...");
                  }

                  return FutureBuilder<User>(
                    future: context.read<UserInteractor>().getCachedUser(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const SizedBox.shrink();
                      }

                      final currentUserId = snapshot.data!.userId;

                      return Column(
                        children: [
                          GroupHeader(
                            conversationId: conversationId,
                            conversation: state.conversation,
                            participantsCount: state.participants.length,
                          ),
                          Divider(
                            height: 1,
                            thickness: 1,
                            color: colorScheme.surfaceContainer.withAlpha(80),
                          ),
                          Expanded(
                            child: GroupMessagesList(
                              messages: messages,
                              currentUserId: currentUserId,
                              participants: state.participants,
                            ),
                          ),
                        ],
                      );
                    },
                  );
              }
            },
          ),
        ),
        MessageInputBar(
          conversationId: conversationId,
          conversationType: ConversationType.group,
        ),
      ],
    );
  }
}
