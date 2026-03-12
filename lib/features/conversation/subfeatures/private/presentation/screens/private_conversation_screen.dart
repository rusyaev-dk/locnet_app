import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/conversation/domain/domain.dart';
import 'package:locnet_app/features/conversation/subfeatures/private/data/data.dart';
import 'package:locnet_app/features/conversation/subfeatures/private/domain/domain.dart';
import 'package:locnet_app/features/conversation/subfeatures/private/presentation/presentation.dart';
import 'package:locnet_app/features/message/data/data.dart';
import 'package:locnet_app/features/message/subfeatures/message_input/presentation/presentation.dart';
import 'package:locnet_app/features/message/subfeatures/private_message/domain/domain.dart';
import 'package:locnet_app/features/message/subfeatures/private_message/presentation/presentation.dart';

class PrivateConversationScreenWrapper extends StatelessWidget {
  const PrivateConversationScreenWrapper({
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
        RepositoryProvider<IPrivateConversationRepo>(
          create: (context) =>
              context.read<IAppEnvPreset>().createPrivateConversationRepo(),
        ),
        RepositoryProvider<PrivateConversationInteractor>(
          create: (BuildContext context) => PrivateConversationInteractor(
            privateConversationRepo: context.read<IPrivateConversationRepo>(),
          ),
        ),
        RepositoryProvider<PrivateMessageInteractor>(
          create: (BuildContext context) => PrivateMessageInteractor(
            messageRepo: context.read<IPrivateMessageRepo>(),
          ),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                PrivateConversationBloc(
                  privateConversationInteractor: context
                      .read<PrivateConversationInteractor>(),
                  logger: context.read<ILogger>(),
                )..add(
                  PrivateConversationStartedEvent(
                    conversationId: conversationId,
                  ),
                ),
          ),
          BlocProvider(create: (context) => MessageAttachmentsCubit()),
          BlocProvider(
            create: (context) => PrivateConversationOptionsCubit(
              conversationId: conversationId,
              privateConversationInteractor: context
                  .read<PrivateConversationInteractor>(),
              logger: context.read<ILogger>(),
            ),
          ),
          BlocProvider(
            create: (context) => PrivateMessageActionsCubit(
              privateMessageInteractor: context.read<PrivateMessageInteractor>(),
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

class PrivateConversationScreen extends StatelessWidget {
  const PrivateConversationScreen({required this.conversationId, super.key});

  final String conversationId;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final l10n = context.l10n;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: BlocBuilder<PrivateConversationBloc, PrivateConversationState>(
            builder: (BuildContext context, PrivateConversationState state) {
              switch (state) {
                case PrivateConversationLoadingState():
                  return const PrivateConversationLoadingShimmer();

                case PrivateConversationFailureState():
                  return InfoWidget(
                    icon: Icons.error,
                    text: state.failure.toString(),
                    useErrorStyle: true,
                    buttonText: l10n.retry,
                    onButtonPressed: () =>
                        context.read<PrivateConversationBloc>().add(
                          PrivateConversationStartedEvent(
                            conversationId: conversationId,
                          ),
                        ),
                    iconAnimationEffect: const ShakeEffect(),
                  );

                case PrivateConversationLoadedState():
                  final List<PrivateMessage> messages = state.messages;

                  if (messages.isEmpty) {
                    return const Text("Empty here...");
                  }

                  return Column(
                    children: [
                      PrivateHeader(
                        conversationId: conversationId,
                        companion: state.companion,
                      ),
                      Divider(
                        height: 1,
                        thickness: 1,
                        color: colorScheme.surfaceContainer.withAlpha(80),
                      ),
                      Expanded(
                        child: PrivateMessagesList(
                          messages: messages,
                          companionId: state.companionId,
                        ),
                      ),
                    ],
                  );
              }
            },
          ),
        ),
        MessageInputBar(
          conversationId: conversationId,
          conversationType: ConversationType.private,
        ),
      ],
    );
  }
}
