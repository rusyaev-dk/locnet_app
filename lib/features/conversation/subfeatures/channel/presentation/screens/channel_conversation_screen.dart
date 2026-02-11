import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/conversation/subfeatures/channel/data/data.dart';
import 'package:locnet_app/features/conversation/subfeatures/channel/domain/domain.dart';
import 'package:locnet_app/features/conversation/subfeatures/channel/presentation/presentation.dart';
import 'package:locnet_app/features/message/subfeatures/message_input/presentation/presentation.dart';

class ChannelConversationScreenWrapper extends StatelessWidget {
  const ChannelConversationScreenWrapper({
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
        RepositoryProvider<IChannelRepo>(
          create: (context) =>
              context.read<IAppEnvPreset>().createChannelRepo(),
        ),
        RepositoryProvider<ChannelInteractor>(
          create: (BuildContext context) => ChannelInteractor(
            channelRepo: context.read<IChannelRepo>(),
          ),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                ChannelConversationBloc(
                  channelInteractor: context.read<ChannelInteractor>(),
                  logger: context.read<ILogger>(),
                )..add(
                  ChannelConversationStartedEvent(
                    conversationId: conversationId,
                  ),
                ),
          ),
          BlocProvider(create: (context) => MessageAttachmentsCubit()),
        ],
        child: child,
      ),
    );
  }
}

class ChannelConversationScreen extends StatelessWidget {
  const ChannelConversationScreen({required this.conversationId, super.key});

  final String conversationId;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final l10n = context.l10n;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: BlocBuilder<ChannelConversationBloc, ChannelConversationState>(
            builder: (BuildContext context, ChannelConversationState state) {
              switch (state) {
                case ChannelConversationLoadingState():
                  return const ChannelConversationLoadingShimmer();

                case ChannelConversationFailureState():
                  return InfoWidget(
                    icon: Icons.error,
                    text: state.failure.toString(),
                    buttonText: l10n.retry,
                    onButtonPressed: () =>
                        context.read<ChannelConversationBloc>().add(
                          ChannelConversationStartedEvent(
                            conversationId: conversationId,
                          ),
                        ),
                    iconAnimationEffect: const ShakeEffect(),
                  );

                case ChannelConversationLoadedState():
                  final List<ChannelPublication> messages = state.messages;

                  if (messages.isEmpty) {
                    return const Text("Empty here...");
                  }

                  return Column(
                    children: [
                      ChannelHeader(
                        conversation: state.conversation,
                        subscribersCount: state.subscribers.length,
                      ),
                      Divider(
                        height: 1,
                        thickness: 1,
                        color: colorScheme.surfaceContainer.withAlpha(80),
                      ),
                      Expanded(child: ChannelMessagesList(messages: messages)),
                    ],
                  );
              }
            },
          ),
        ),
        MessageInputBar(conversationId: conversationId),
      ],
    );
  }
}
