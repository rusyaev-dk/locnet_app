import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/conversation/data/data.dart';
import 'package:locnet_app/features/conversation/subfeatures/private/data/data.dart';
import 'package:locnet_app/features/conversation/subfeatures/private/domain/domain.dart';
import 'package:locnet_app/features/conversation/subfeatures/private/presentation/presentation.dart';
import 'package:locnet_app/features/message/domain/domain.dart';
import 'package:locnet_app/features/message/subfeatures/message_input/presentation/presentation.dart';
import 'package:locnet_app/mock/mock.dart';

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
          create: (BuildContext context) => MockPrivateConversationRepo(
            backendStorage: context.read<MockBackendStorage>(),
            logger: context.read<ILogger>(),
          ),
        ),
        RepositoryProvider<PrivateConversationInteractor>(
          create: (BuildContext context) => PrivateConversationInteractor(
            privateConversationRepo: context.read<IPrivateConversationRepo>(),
            conversationRepo: context.read<IConversationRepo>(),
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
      children: [
        const PrivateHeader(),
        Divider(
          height: 1,
          thickness: 1,
          color: colorScheme.surfaceContainer.withAlpha(80),
        ),
        Expanded(
          child: BlocBuilder<PrivateConversationBloc, PrivateConversationState>(
            builder: (BuildContext context, PrivateConversationState state) {
              switch (state) {
                case PrivateConversationLoadingState():
                  return const Center(child: CircularProgressIndicator());

                case PrivateConversationFailureState():
                  return InfoWidget(
                    icon: Icons.error,
                    text: state.failure.toString(),
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
                  final List<Message> messages = state.messages;

                  if (messages.isEmpty) {
                    return const Text("Empty here...");
                  }

                  return PrivateMessagesList(
                    messages: messages,
                    companionId: state.companionId,
                  );
              }
            },
          ),
        ),
        const MessageInputBar(),
      ],
    );
  }
}
