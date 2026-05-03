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
import 'package:locnet_app/uikit/uikit.dart';

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

                      final bool? confirm = await showAppAlertDialog<bool>(
                        context: context,
                        title: Text(l10n.messageContextActionDelete),
                        content: Text(
                          l10n.logOutConfirmation,
                        ),
                        buildActions: (d) => [
                          AppAlertDialogAction(
                            child: Text(l10n.cancel),
                            onPressed: () => Navigator.of(d).pop(false),
                          ),
                          AppAlertDialogAction(
                            isDefaultAction: true,
                            child: Text(l10n.yesLabel),
                            onPressed: () => Navigator.of(d).pop(true),
                          ),
                        ],
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
                        barrierDismissible: true,
                        barrierLabel:
                            MaterialLocalizations.of(context).modalBarrierDismissLabel,
                        barrierColor: context.colorScheme.scrim.withValues(
                          alpha: 0.45,
                        ),
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

                      switch (tile.type) {
                        case ConversationTileType.private:
                        case ConversationTileType.group:
                          return;
                        case ConversationTileType.channel:
                          for (final ChannelPublication sourcePublication
                              in selectedMessages) {
                            await context
                                .read<ChannelPublicationActionsCubit>()
                                .forwardPublication(
                                  channelId: tile.id,
                                  sourcePublication: sourcePublication,
                                );
                          }
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
                    return Text(context.l10n.conversationNoMessagesYet);
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
                        barrierDismissible: true,
                        barrierLabel:
                            MaterialLocalizations.of(context).modalBarrierDismissLabel,
                        barrierColor: context.colorScheme.scrim.withValues(
                          alpha: 0.45,
                        ),
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

                      switch (tile.type) {
                        case ConversationTileType.private:
                        case ConversationTileType.group:
                          return;
                        case ConversationTileType.channel:
                          await context
                              .read<ChannelPublicationActionsCubit>()
                              .forwardPublication(
                                channelId: tile.id,
                                sourcePublication: publication,
                              );
                          break;
                      }
                    },
                    onDelete: (publication) async {
                      final l10n = context.l10n;

                      final bool? confirm = await showAppAlertDialog<bool>(
                        context: context,
                        title: Text(l10n.messageContextActionDelete),
                        content: Text(
                          l10n.logOutConfirmation,
                        ),
                        buildActions: (d) => [
                          AppAlertDialogAction(
                            child: Text(l10n.cancel),
                            onPressed: () => Navigator.of(d).pop(false),
                          ),
                          AppAlertDialogAction(
                            isDefaultAction: true,
                            child: Text(l10n.yesLabel),
                            onPressed: () => Navigator.of(d).pop(true),
                          ),
                        ],
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
                SurfaceIconButton(
                  variant: SurfaceIconVariant.ghost,
                  icon: Icons.close,
                  margin: EdgeInsets.zero,
                  dimension: 32,
                  iconSize: 20,
                  tooltip: l10n.close,
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
