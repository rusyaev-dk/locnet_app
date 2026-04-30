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
import 'package:locnet_app/features/message/subfeatures/message_selection/presentation/blocs/message_selection_cubit.dart';
import 'package:locnet_app/features/message/subfeatures/message_selection/presentation/components/messages_selection_app_bar.dart';
import 'package:locnet_app/features/message/subfeatures/message_selection/presentation/modals/forward_target_picker_modal_card.dart';
import 'package:locnet_app/features/conversations_list/domain/domain.dart';

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
          BlocProvider(
            create: (context) => MessageSelectionCubit(
              conversationId: conversationId,
              conversationType: ConversationType.group,
            ),
          ),
        ],
        child: child,
      ),
    );
  }
}

class GroupConversationScreen extends StatefulWidget {
  const GroupConversationScreen({required this.conversationId, super.key});

  final String conversationId;

  @override
  State<GroupConversationScreen> createState() =>
      _GroupConversationScreenState();
}

class _GroupConversationScreenState extends State<GroupConversationScreen> {
  GroupMessage? _replyTo;

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
                      final baseState = context.read<GroupConversationBloc>().state;
                      if (baseState is! GroupConversationLoadedState) return;

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
                            .read<GroupMessageActionsCubit>()
                            .deleteMessage(message: msg);
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

                      final baseState = context.read<GroupConversationBloc>().state;
                      final selectedMessages = (baseState
                              as GroupConversationLoadedState)
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

                      switch (tile.type) {
                        case ConversationTileType.private:
                        case ConversationTileType.group:
                          for (final GroupMessage sourceMessage
                              in selectedMessages) {
                            await context
                                .read<GroupMessageActionsCubit>()
                                .forwardMessage(
                                  groupId: tile.id,
                                  sourceMessage: sourceMessage,
                                );
                          }
                          break;
                        case ConversationTileType.channel:
                          return;
                      }

                      context.read<MessageSelectionCubit>().clearSelection();
                    },
                  )
                : BlocBuilder<GroupConversationBloc, GroupConversationState>(
                    builder: (context, convState) =>
                        convState is GroupConversationLoadedState
                            ? GroupHeader(
                                conversationId: widget.conversationId,
                                conversation: convState.conversation,
                                participantsCount: convState.participants.length,
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
                            conversationId: widget.conversationId,
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

                      return GroupMessagesList(
                        messages: messages,
                        currentUserId: currentUserId,
                        participants: state.participants,
                        onReply: (message) {
                          setState(() {
                            _replyTo = message;
                          });
                        },
                        onForward: (message) async {
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

                          switch (tile.type) {
                            case ConversationTileType.private:
                            case ConversationTileType.group:
                              await context
                                  .read<GroupMessageActionsCubit>()
                                  .forwardMessage(
                                    groupId: tile.id,
                                    sourceMessage: message,
                                  );
                              break;
                            case ConversationTileType.channel:
                              return;
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
                              .read<GroupMessageActionsCubit>()
                              .deleteMessage(message: message);
                        },
                      );
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
          conversationType: ConversationType.group,
          replyToMessageId: _replyTo?.id,
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
