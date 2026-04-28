import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/conversation/domain/domain.dart';
import 'package:locnet_app/features/conversation/subfeatures/channel/data/data.dart';
import 'package:locnet_app/features/conversation/subfeatures/channel/domain/domain.dart';
import 'package:locnet_app/features/conversation/subfeatures/channel/presentation/presentation.dart';
import 'package:locnet_app/features/message/data/data.dart';
import 'package:locnet_app/features/message/subfeatures/channel_publication/domain/domain.dart';
import 'package:locnet_app/features/message/subfeatures/channel_publication/presentation/presentation.dart';
import 'package:locnet_app/features/message/subfeatures/message_input/presentation/presentation.dart';
import 'package:locnet_app/features/message/subfeatures/message_selection/presentation/blocs/message_selection_cubit.dart';
import 'package:locnet_app/features/message/subfeatures/message_selection/presentation/components/messages_selection_app_bar.dart';
import 'package:locnet_app/features/message/subfeatures/message_selection/presentation/modals/forward_target_picker_modal_card.dart';
import 'package:locnet_app/features/conversations_list/domain/domain.dart';

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
        RepositoryProvider<ChannelPublicationInteractor>(
          create: (BuildContext context) => ChannelPublicationInteractor(
            publicationRepo: context.read<IChannelPublicationRepo>(),
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
          BlocProvider(
            create: (context) => ChannelPublicationActionsCubit(
              channelPublicationInteractor: context
                  .read<ChannelPublicationInteractor>(),
              userInteractor: context.read<UserInteractor>(),
              logger: context.read<ILogger>(),
            ),
          ),
          BlocProvider(
            create: (context) => MessageSelectionCubit(
              conversationId: conversationId,
              conversationType: ConversationType.channel,
            ),
          ),
        ],
        child: child,
      ),
    );
  }
}

class ChannelConversationScreen extends StatefulWidget {
  const ChannelConversationScreen({required this.conversationId, super.key});

  final String conversationId;

  @override
  State<ChannelConversationScreen> createState() =>
      _ChannelConversationScreenState();
}

class _ChannelConversationScreenState extends State<ChannelConversationScreen> {
  ChannelPublication? _replyTo;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final l10n = context.l10n;

    return Column(
      children: [
        BlocBuilder<MessageSelectionCubit, MessageSelectionState>(
          builder: (context, selectionState) {
            final bool isSelectionMode = selectionState.isSelectionMode;

            final header = isSelectionMode
                ? MessagesSelectionAppBar(
                    selectedCount: selectionState.selectedCount,
                    onClosePressed: () =>
                        context.read<MessageSelectionCubit>().clearSelection(),
                    onDeletePressed: () async {
                      final baseState = context.read<ChannelConversationBloc>().state;
                      if (baseState is! ChannelConversationLoadedState) return;

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
                              m.publicationId,
                            ),
                          )
                          .toList();

                      for (final pub in messages) {
                        await context
                            .read<ChannelPublicationActionsCubit>()
                            .deletePublication(publication: pub);
                      }

                      context.read<MessageSelectionCubit>().clearSelection();
                    },
                    onForwardPressed: () async {
                      if (selectionState.selectedMessageIds.isEmpty) return;

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

                      final baseState = context.read<ChannelConversationBloc>().state;
                      final selectedMessages = (baseState
                              as ChannelConversationLoadedState)
                          .messages
                          .where(
                            (m) => selectionState.selectedMessageIds.contains(
                              m.publicationId,
                            ),
                          )
                          .toList()
                        ..sort(
                          (a, b) => a.createdAt.compareTo(b.createdAt),
                        );

                      final text = selectedMessages
                          .map((m) => m.text ?? '')
                          .join('\n');

                      if (text.trim().isEmpty) return;

                      switch (tile.type) {
                        case ConversationTileType.private:
                        case ConversationTileType.group:
                          return;
                        case ConversationTileType.channel:
                          await context
                              .read<ChannelPublicationActionsCubit>()
                              .sendPublication(
                                channelId: tile.id,
                                text: text,
                              );
                          break;
                      }

                      context.read<MessageSelectionCubit>().clearSelection();
                    },
                  )
                : BlocBuilder<ChannelConversationBloc, ChannelConversationState>(
                    builder: (context, convState) =>
                        convState is ChannelConversationLoadedState
                            ? ChannelHeader(
                                conversationId: widget.conversationId,
                                conversation: convState.conversation,
                                subscribersCount: convState.subscribers.length,
                              )
                            : const SizedBox.shrink(),
                  );

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
          child: BlocBuilder<ChannelConversationBloc, ChannelConversationState>(
            builder: (BuildContext context, ChannelConversationState state) {
              switch (state) {
                case ChannelConversationLoadingState():
                  return const ChannelConversationLoadingShimmer();

                case ChannelConversationFailureState():
                  return InfoWidget(
                    icon: Icons.error,
                    text: state.failure.toString(),
                    useErrorStyle: true,
                    buttonText: l10n.retry,
                    onButtonPressed: () =>
                        context.read<ChannelConversationBloc>().add(
                          ChannelConversationStartedEvent(
                            conversationId: widget.conversationId,
                          ),
                        ),
                    iconAnimationEffect: const ShakeEffect(),
                  );

                case ChannelConversationLoadedState():
                  final List<ChannelPublication> messages = state.messages;

                  if (messages.isEmpty) {
                    return const Text("Empty here...");
                  }

                  return ChannelMessagesList(
                    messages: messages,
                    onReply: (publication) {
                      setState(() {
                        _replyTo = publication;
                      });
                    },
                    onForward: (publication) async {
                      final tile =
                          await showGeneralDialog<ConversationTile>(
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

                      final text = (publication.text ?? '').trim();
                      if (text.isEmpty) return;

                      switch (tile.type) {
                        case ConversationTileType.private:
                        case ConversationTileType.group:
                          return;
                        case ConversationTileType.channel:
                          await context
                              .read<ChannelPublicationActionsCubit>()
                              .sendPublication(
                                channelId: tile.id,
                                text: text,
                              );
                          break;
                      }
                    },
                    onDelete: (publication) async {
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
                          .read<ChannelPublicationActionsCubit>()
                          .deletePublication(publication: publication);
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
                        (_replyTo!.text ?? '').trim(),
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
          conversationType: ConversationType.channel,
          replyToMessageId: _replyTo?.publicationId,
          onMessageSent: () {
            if (_replyTo == null) {
              return;
            }
            setState(() {
              _replyTo = null;
            });
          },
        ),
      ],
    );
  }
}
