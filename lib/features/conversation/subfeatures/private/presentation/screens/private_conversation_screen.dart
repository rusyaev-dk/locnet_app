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
import 'package:locnet_app/features/message/subfeatures/message_selection/presentation/blocs/message_selection_cubit.dart';
import 'package:locnet_app/features/message/subfeatures/message_selection/presentation/components/messages_selection_app_bar.dart';
import 'package:locnet_app/features/message/subfeatures/message_selection/presentation/modals/forward_target_picker_modal_card.dart';
import 'package:locnet_app/features/conversations_list/domain/domain.dart';

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
          BlocProvider(
            create: (context) => MessageSelectionCubit(
              conversationId: conversationId,
              conversationType: ConversationType.private,
            ),
          ),
        ],
        child: child,
      ),
    );
  }
}

class PrivateConversationScreen extends StatefulWidget {
  const PrivateConversationScreen({required this.conversationId, super.key});

  final String conversationId;

  @override
  State<PrivateConversationScreen> createState() =>
      _PrivateConversationScreenState();
}

class _PrivateConversationScreenState extends State<PrivateConversationScreen> {
  PrivateMessage? _replyTo;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final l10n = context.l10n;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        BlocBuilder<MessageSelectionCubit, MessageSelectionState>(
          builder: (context, selectionState) {
            final bool isSelectionMode = selectionState.isSelectionMode;

            final PrivateConversationState baseState =
                context.read<PrivateConversationBloc>().state;

            final Widget header = isSelectionMode
                ? MessagesSelectionAppBar(
                    selectedCount: selectionState.selectedCount,
                    onClosePressed: () =>
                        context.read<MessageSelectionCubit>().clearSelection(),
                    onDeletePressed: () async {
                      if (baseState is! PrivateConversationLoadedState) return;

                      final l10n = context.l10n;

                      final bool? confirm = await showDialog<bool>(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text(l10n.messageContextActionDelete),
                            content: Text(
                              l10n.logOutConfirmation,
                            ),
                            actions: [
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
                                child: Text(l10n.cancel),
                              ),
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(true),
                                child: Text(l10n.yesLabel),
                              ),
                            ],
                          );
                        },
                      );

                      if (confirm != true) return;

                      final messages = baseState.messages
                          .where(
                            (m) => selectionState.selectedMessageIds.contains(
                              m.id,
                            ),
                          )
                          .toList();

                      for (final msg in messages) {
                        await context
                            .read<PrivateMessageActionsCubit>()
                            .deleteMessage(message: msg);
                      }

                      context.read<MessageSelectionCubit>().clearSelection();
                    },
                    onForwardPressed: () async {
                      if (selectionState.selectedMessageIds.isEmpty) return;

                      final tiles = await showGeneralDialog<
                          ConversationTile>(
                        context: context,
                        barrierColor: Colors.transparent,
                        transitionBuilder: slideFadeDialogTransition,
                        pageBuilder: (context, _, __) {
                          return ForwardTargetPickerModalWrapper(
                            child: ForwardTargetPickerModalCard(
                              onTargetSelected: (tile) {
                                Navigator.of(context).pop(tile);
                              },
                            ),
                          );
                        },
                      );

                      if (tiles == null) return;

                      // Реальный forward предполагает бэкенд-метод forwardMessages.
                      // Пока реализуем отправку цитатой текста выбранных сообщений.

                      final selectedMessages = (baseState as
                              PrivateConversationLoadedState)
                          .messages
                          .where(
                            (m) => selectionState.selectedMessageIds.contains(
                              m.id,
                            ),
                          )
                          .toList()
                        ..sort(
                          (a, b) => a.createdAt.compareTo(b.createdAt),
                        );

                      final text = selectedMessages
                          .map((m) => m.text)
                          .join('\n');

                      if (text.trim().isEmpty) return;

                      if (tiles.type == ConversationTileType.private) {
                        await context.read<PrivateMessageActionsCubit>().sendMessage(
                              conversationId: tiles.id,
                              text: text,
                            );
                      }

                      context.read<MessageSelectionCubit>().clearSelection();
                    },
                  )
                : baseState is PrivateConversationLoadedState
                    ? PrivateHeader(
                        conversationId: widget.conversationId,
                        companion: baseState.companion,
                      )
                    : const SizedBox.shrink();

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                header,
                Divider(
                  height: 1,
                  thickness: 1,
                  color: colorScheme.surfaceContainer.withAlpha(80),
                ),
              ],
            );
          },
        ),
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
                            conversationId: widget.conversationId,
                          ),
                        ),
                    iconAnimationEffect: const ShakeEffect(),
                  );

                case PrivateConversationLoadedState():
                  final List<PrivateMessage> messages = state.messages;

                  if (messages.isEmpty) {
                    return const Text("Empty here...");
                  }

                  return PrivateMessagesList(
                    messages: messages,
                    companionId: state.companionId,
                    onReply: (message) {
                      setState(() {
                        _replyTo = message;
                      });
                    },
                    onForward: (message) async {
                      final tile = await showGeneralDialog<ConversationTile>(
                        context: context,
                        barrierColor: Colors.transparent,
                        transitionBuilder: slideFadeDialogTransition,
                        pageBuilder: (context, _, __) {
                          return ForwardTargetPickerModalWrapper(
                            child: ForwardTargetPickerModalCard(
                              onTargetSelected: (tile) {
                                Navigator.of(context).pop(tile);
                              },
                            ),
                          );
                        },
                      );

                      if (tile == null) return;

                      final text = message.text.trim();
                      if (text.isEmpty) return;

                      if (tile.type == ConversationTileType.private) {
                        await context
                            .read<PrivateMessageActionsCubit>()
                            .sendMessage(
                              conversationId: tile.id,
                              text: text,
                            );
                      }
                    },
                    onDelete: (message) async {
                      final l10n = context.l10n;

                      final bool? confirm = await showDialog<bool>(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text(l10n.messageContextActionDelete),
                            content: Text(
                              l10n.logOutConfirmation,
                            ),
                            actions: [
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
                                child: Text(l10n.cancel),
                              ),
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(true),
                                child: Text(l10n.yesLabel),
                              ),
                            ],
                          );
                        },
                      );

                      if (confirm != true) return;

                      await context
                          .read<PrivateMessageActionsCubit>()
                          .deleteMessage(message: message);
                    },
                  );
              }
            },
          ),
        ),
        if (_replyTo != null)
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            color: colorScheme.surfaceContainerHigh,
            child: Row(
              children: [
                Container(
                  width: 3,
                  height: 32,
                  color: colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.messageContextActionReply,
                        style: context.textScheme.caption.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        _replyTo!.text,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    setState(() {
                      _replyTo = null;
                    });
                  },
                ),
              ],
            ),
          ),
        MessageInputBar(
          conversationId: widget.conversationId,
          conversationType: ConversationType.private,
          replyToMessageId: _replyTo?.id,
        ),
      ],
    );
  }
}
