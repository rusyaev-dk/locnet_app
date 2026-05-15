import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/conversation/domain/domain.dart';
import 'package:locnet_app/features/conversation/subfeatures/private/data/data.dart';
import 'package:locnet_app/features/conversation/subfeatures/private/domain/domain.dart';
import 'package:locnet_app/features/conversation/subfeatures/private/presentation/presentation.dart';
import 'package:locnet_app/features/conversations_list/domain/domain.dart';
import 'package:locnet_app/features/conversations_list/presentation/presentation.dart';
import 'package:locnet_app/features/message/data/data.dart';
import 'package:locnet_app/features/message/domain/domain.dart';
import 'package:locnet_app/features/message/subfeatures/message_input/presentation/presentation.dart';
import 'package:locnet_app/features/message/subfeatures/message_selection/presentation/blocs/message_selection_cubit.dart';
import 'package:locnet_app/features/message/subfeatures/message_selection/presentation/components/messages_selection_app_bar.dart';
import 'package:locnet_app/features/message/subfeatures/message_selection/presentation/modals/forward_target_picker_modal_card.dart';
import 'package:locnet_app/features/message/subfeatures/private_message/domain/domain.dart';
import 'package:locnet_app/features/message/subfeatures/private_message/presentation/presentation.dart';
import 'package:locnet_app/uikit/uikit.dart';

class PrivateConversationScreenWrapper extends StatelessWidget {
  const PrivateConversationScreenWrapper({
    required this.child,
    this.conversationId,
    this.draftCompanionId,
    this.initialCompanion,
    super.key,
  }) : assert(
         conversationId != null || draftCompanionId != null,
         'Either conversationId or draftCompanionId must be provided.',
       );

  final Widget child;
  final String? conversationId;
  final String? draftCompanionId;
  final User? initialCompanion;

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
        RepositoryProvider<MediaInteractor>(
          create: (BuildContext context) => MediaInteractor(
            mediaRepo: context.read<IAppEnvPreset>().createMediaRepo(),
            downloadCache: context
                .read<IAppEnvPreset>()
                .createMediaDownloadCacheRepo(),
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
                  privateMessageInteractor: context
                      .read<PrivateMessageInteractor>(),
                  mediaInteractor: context.read<MediaInteractor>(),
                  userInteractor: context.read<UserInteractor>(),
                  logger: context.read<ILogger>(),
                )..add(
                  conversationId != null
                      ? PrivateConversationStartedEvent(
                          conversationId: conversationId!,
                          initialCompanion: initialCompanion,
                        )
                      : PrivateConversationDraftStartedEvent(
                          companionId: draftCompanionId!,
                          initialCompanion: initialCompanion,
                        ),
                ),
          ),
          BlocProvider(create: (context) => MessageAttachmentsCubit()),
          BlocProvider(
            create: (context) => PrivateMessageActionsCubit(
              privateMessageInteractor: context
                  .read<PrivateMessageInteractor>(),
              userInteractor: context.read<UserInteractor>(),
              logger: context.read<ILogger>(),
            ),
          ),
          BlocProvider(
            create: (context) => MessageSelectionCubit(
              conversationId:
                  conversationId ?? 'draft-${draftCompanionId ?? 'private'}',
              conversationType: ConversationType.private,
            ),
          ),
        ],
        child: BlocBuilder<PrivateConversationBloc, PrivateConversationState>(
          buildWhen: (PrivateConversationState previous, PrivateConversationState next) {
            final String? prevId = conversationId ??
                (previous is PrivateConversationLoadedState
                    ? previous.conversation.conversationId
                    : null);
            final String? nextId = conversationId ??
                (next is PrivateConversationLoadedState
                    ? next.conversation.conversationId
                    : null);
            return prevId != nextId;
          },
          builder: (BuildContext context, PrivateConversationState convState) {
            final String? effectiveConversationId = conversationId ??
                (convState is PrivateConversationLoadedState
                    ? convState.conversation.conversationId
                    : null);

            if (effectiveConversationId == null) {
              return child;
            }

            return BlocProvider<PrivateConversationOptionsCubit>(
              key: ValueKey<String>(
                'private-conv-options-$effectiveConversationId',
              ),
              create: (BuildContext context) => PrivateConversationOptionsCubit(
                conversationId: effectiveConversationId,
                privateConversationInteractor: context
                    .read<PrivateConversationInteractor>(),
                logger: context.read<ILogger>(),
              ),
              child: BlocListener<
                PrivateConversationOptionsCubit,
                PrivateConversationOptionsState
              >(
                listenWhen:
                    (
                      PrivateConversationOptionsState previous,
                      PrivateConversationOptionsState current,
                    ) {
                      return current is PrivateConversationOptionsDeletedState;
                    },
                listener:
                    (
                      BuildContext context,
                      PrivateConversationOptionsState state,
                    ) {
                      context.read<AllConversationsListBloc>().add(
                            AllConversationsListConversationDeletedEvent(
                              conversationId: effectiveConversationId,
                            ),
                          );
                      if (!context.mounted) {
                        return;
                      }
                      GoRouter.of(context).go(AppRoutes.conversations);
                    },
                child: child,
              ),
            );
          },
        ),
      ),
    );
  }
}

class PrivateConversationScreen extends StatefulWidget {
  const PrivateConversationScreen({
    this.conversationId,
    this.draftCompanionId,
    this.initialCompanion,
    this.onConversationCreated,
    super.key,
  }) : assert(
         conversationId != null || draftCompanionId != null,
         'Either conversationId or draftCompanionId must be provided.',
       );

  final String? conversationId;
  final String? draftCompanionId;
  final User? initialCompanion;
  final void Function(String conversationId)? onConversationCreated;

  @override
  State<PrivateConversationScreen> createState() =>
      _PrivateConversationScreenState();
}

class _PrivateConversationScreenState extends State<PrivateConversationScreen> {
  PrivateMessage? _replyTo;
  String? _highlightedMessageId;
  String? _notifiedCreatedConversationId;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final l10n = context.l10n;

    return MultiBlocListener(
      listeners: [
        BlocListener<PrivateConversationBloc, PrivateConversationState>(
          listenWhen: (previous, current) {
            if (widget.onConversationCreated == null ||
                widget.draftCompanionId == null) {
              return false;
            }
            return previous is PrivateConversationDraftState &&
                current is PrivateConversationLoadedState;
          },
          listener: (BuildContext context, PrivateConversationState current) {
            if (current is! PrivateConversationLoadedState) {
              return;
            }
            final String id = current.conversation.conversationId;
            if (_notifiedCreatedConversationId == id) {
              return;
            }
            _notifiedCreatedConversationId = id;
            widget.onConversationCreated?.call(id);
          },
        ),
        BlocListener<PrivateConversationBloc, PrivateConversationState>(
          listenWhen:
              (
                PrivateConversationState previous,
                PrivateConversationState current,
              ) {
                if (current is! PrivateConversationLoadedState) {
                  return false;
                }
                if (previous is! PrivateConversationLoadedState) {
                  return true;
                }
                return previous.conversation.conversationId !=
                    current.conversation.conversationId;
              },
          listener: (BuildContext context, PrivateConversationState state) {
            if (state is PrivateConversationLoadedState) {
              unawaited(_markIncomingMessagesAsRead(context, state));
            }
          },
        ),
      ],
      child: Column(
        children: [
          BlocBuilder<MessageSelectionCubit, MessageSelectionState>(
            builder: (context, selectionState) {
              final bool isSelectionMode = selectionState.isSelectionMode;

              final Widget header = isSelectionMode
                  ? MessagesSelectionAppBar(
                      selectedCount: selectionState.selectedCount,
                      onClosePressed: () => context
                          .read<MessageSelectionCubit>()
                          .clearSelection(),
                      onDeletePressed: () async {
                        final baseState = context
                            .read<PrivateConversationBloc>()
                            .state;
                        if (baseState is! PrivateConversationLoadedState) {
                          return;
                        }

                        final l10n = context.l10n;

                        final bool? confirm = await showAppAlertDialog<bool>(
                          context: context,
                          title: Text(l10n.messageContextActionDelete),
                          content: Text(
                            l10n.deleteSelectedMessagesConfirmation(
                              selectionState.selectedCount,
                            ),
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
                                m.id,
                              ),
                            )
                            .toList();

                        for (final msg in messages) {
                          await context
                              .read<PrivateMessageActionsCubit>()
                              .deleteMessage(message: msg);
                          context.read<PrivateConversationBloc>().add(
                            PrivateConversationMessageDeletedLocallyEvent(
                              messageId: msg.id,
                            ),
                          );
                        }

                        context.read<MessageSelectionCubit>().clearSelection();
                      },
                      onForwardPressed: () async {
                        if (selectionState.selectedMessageIds.isEmpty) return;

                        final tiles = await showGeneralDialog<ConversationTile>(
                          context: context,
                          barrierDismissible: true,
                          barrierLabel: MaterialLocalizations.of(
                            context,
                          ).modalBarrierDismissLabel,
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

                        if (tiles == null) return;

                        final baseState = context
                            .read<PrivateConversationBloc>()
                            .state;
                        final selectedMessages =
                            (baseState as PrivateConversationLoadedState)
                                .messages
                                .where(
                                  (m) => selectionState.selectedMessageIds
                                      .contains(m.id),
                                )
                                .toList()
                              ..sort(
                                (a, b) => a.createdAt.compareTo(b.createdAt),
                              );

                        if (tiles.type == ConversationTileType.private) {
                          for (final PrivateMessage sourceMessage
                              in selectedMessages) {
                            await context
                                .read<PrivateMessageActionsCubit>()
                                .forwardMessage(
                                  conversationId: tiles.id,
                                  sourceMessage: sourceMessage,
                                );
                          }
                        }

                        context.read<MessageSelectionCubit>().clearSelection();
                      },
                    )
                  : BlocBuilder<
                      PrivateConversationBloc,
                      PrivateConversationState
                    >(
                      builder: (context, convState) => switch (convState) {
                        PrivateConversationLoadedState() => PrivateHeader(
                          conversationId: convState.conversation.conversationId,
                          companion: convState.companion,
                          onSearchResultSelected: (messageId) {
                            setState(() {
                              _highlightedMessageId = messageId;
                            });
                          },
                        ),
                        PrivateConversationDraftState() => PrivateHeader(
                          companion: convState.companion,
                        ),
                        _ => const SizedBox.shrink(),
                      },
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
            child:
                BlocBuilder<PrivateConversationBloc, PrivateConversationState>(
                  builder:
                      (BuildContext context, PrivateConversationState state) {
                        switch (state) {
                          case PrivateConversationLoadingState():
                            return const PrivateConversationLoadingShimmer();

                          case PrivateConversationFailureState():
                            return InfoWidget(
                              icon: Icons.error,
                              text: state.failure.toString(),
                              useErrorStyle: true,
                              buttonText: l10n.retry,
                              onButtonPressed: () {
                                final PrivateConversationBloc bloc = context
                                    .read<PrivateConversationBloc>();
                                if (widget.conversationId != null) {
                                  bloc.add(
                                    PrivateConversationStartedEvent(
                                      conversationId: widget.conversationId!,
                                      initialCompanion: widget.initialCompanion,
                                    ),
                                  );
                                  return;
                                }

                                if (widget.draftCompanionId != null) {
                                  bloc.add(
                                    PrivateConversationDraftStartedEvent(
                                      companionId: widget.draftCompanionId!,
                                      initialCompanion: widget.initialCompanion,
                                    ),
                                  );
                                }
                              },
                              iconAnimationEffect: const ShakeEffect(),
                            );

                          case PrivateConversationDraftState():
                            return Center(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.chat_bubble_outline,
                                      size: 36,
                                      color:
                                          context.colorScheme.onSurfaceVariant,
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      context
                                          .l10n
                                          .privateDraftConversationEmptyTitle,
                                      style: context.textScheme.title.copyWith(
                                        color: context.colorScheme.onSurface,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      context.l10n.draftChatHint,
                                      style: context.textScheme.caption
                                          .copyWith(
                                            color: context
                                                .colorScheme
                                                .onSurfaceVariant,
                                          ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            );

                          case PrivateConversationLoadedState():
                            final List<PrivateMessage> messages = state.messages
                                .where(
                                  (PrivateMessage message) =>
                                      !message.isDeleted,
                                )
                                .toList(growable: false);

                            if (messages.isEmpty) {
                              return Text(
                                context.l10n.conversationNoMessagesYet,
                              );
                            }

                            return PrivateMessagesList(
                              messages: messages,
                              companionId: state.companionId,
                              highlightedMessageId: _highlightedMessageId,
                              onHighlightConsumed: (messageId) {
                                if (_highlightedMessageId != messageId) {
                                  return;
                                }
                                setState(() {
                                  _highlightedMessageId = null;
                                });
                              },
                              onReply: (message) {
                                setState(() {
                                  _replyTo = message;
                                });
                              },
                              onForward: (message) async {
                                final tile =
                                    await showGeneralDialog<ConversationTile>(
                                      context: context,
                                      barrierDismissible: true,
                                      barrierLabel: MaterialLocalizations.of(
                                        context,
                                      ).modalBarrierDismissLabel,
                                      barrierColor: context.colorScheme.scrim
                                          .withValues(alpha: 0.45),
                                      transitionBuilder:
                                          slideFadeDialogTransition,
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

                                if (tile.type == ConversationTileType.private) {
                                  await context
                                      .read<PrivateMessageActionsCubit>()
                                      .forwardMessage(
                                        conversationId: tile.id,
                                        sourceMessage: message,
                                      );
                                }
                              },
                              onDelete: (message) async {
                                final l10n = context.l10n;

                                final bool?
                                confirm = await showAppAlertDialog<bool>(
                                  context: context,
                                  title: Text(l10n.messageContextActionDelete),
                                  content: Text(l10n.deleteMessageConfirmation),
                                  buildActions: (d) => [
                                    AppAlertDialogAction(
                                      child: Text(l10n.cancel),
                                      onPressed: () =>
                                          Navigator.of(d).pop(false),
                                    ),
                                    AppAlertDialogAction(
                                      isDefaultAction: true,
                                      child: Text(l10n.yesLabel),
                                      onPressed: () =>
                                          Navigator.of(d).pop(true),
                                    ),
                                  ],
                                );

                                if (confirm != true) return;

                                await context
                                    .read<PrivateMessageActionsCubit>()
                                    .deleteMessage(message: message);
                                context.read<PrivateConversationBloc>().add(
                                  PrivateConversationMessageDeletedLocallyEvent(
                                    messageId: message.id,
                                  ),
                                );
                              },
                            );
                        }
                      },
                ),
          ),
          if (_replyTo != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              color: colorScheme.surfaceContainerHigh,
              child: Row(
                children: [
                  Container(width: 3, height: 32, color: colorScheme.primary),
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
          BlocSelector<
            PrivateConversationBloc,
            PrivateConversationState,
            ({String? conversationId, String? draftContextId})
          >(
            selector: (PrivateConversationState s) => (
              conversationId: s is PrivateConversationLoadedState
                  ? s.conversation.conversationId
                  : null,
              draftContextId: s is PrivateConversationDraftState
                  ? s.companion.userId
                  : null,
            ),
            builder:
                (
                  BuildContext context,
                  ({String? conversationId, String? draftContextId}) ids,
                ) {
                  return MessageInputBar(
                    conversationId: ids.conversationId,
                    draftContextId: ids.draftContextId,
                    conversationType: ConversationType.private,
                    replyToMessageId: _replyTo?.id,
                    onMessageSent: () {
                      if (_replyTo == null) {
                        return;
                      }
                      setState(() {
                        _replyTo = null;
                      });
                    },
                  );
                },
          ),
        ],
      ),
    );
  }

  Future<void> _markIncomingMessagesAsRead(
    BuildContext context,
    PrivateConversationLoadedState state,
  ) async {
    final User user = await context.read<UserInteractor>().getCachedUser();
    if (!context.mounted) {
      return;
    }
    final PrivateConversationBloc bloc = context
        .read<PrivateConversationBloc>();
    for (final PrivateMessage message in state.messages) {
      if (message.senderId == user.userId) {
        continue;
      }
      if (message.deliveryStatus == MessageDeliveryStatus.read) {
        continue;
      }
      if (message.id.isEmpty) {
        continue;
      }
      bloc.add(
        PrivateConversationMarkMessageReadEvent(
          conversationId: state.conversation.conversationId,
          messageId: message.id,
        ),
      );
    }
  }
}
