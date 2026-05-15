import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/conversation/subfeatures/group/group.dart';
import 'package:locnet_app/features/message/subfeatures/message_selection/presentation/blocs/message_selection_cubit.dart';
import 'package:locnet_app/features/message/subfeatures/message_selection/presentation/components/selectable_message_bubble_wrapper.dart';

class GroupMessagesList extends StatefulWidget {
  const GroupMessagesList({
    required this.messages,
    required this.currentUserId,
    required this.participants,
    this.onReply,
    this.onForward,
    this.onDelete,
    super.key,
  });

  final List<GroupMessage> messages;
  final String currentUserId;
  final List<User> participants;
  final void Function(GroupMessage message)? onReply;
  final void Function(GroupMessage message)? onForward;
  final void Function(GroupMessage message)? onDelete;

  @override
  State<GroupMessagesList> createState() => _GroupMessagesListState();
}

class _GroupMessagesListState extends State<GroupMessagesList> {
  bool _isDragSelecting = false;
  final Set<String> _visitedIds = <String>{};

  @override
  Widget build(BuildContext context) {
    final Map<String, User> participantsMap = {
      for (final User user in widget.participants) user.userId: user,
    };

    final selectionCubit = context.watch<MessageSelectionCubit>();
    final Map<String, GroupMessage> messagesById = <String, GroupMessage>{
      for (final GroupMessage msg in widget.messages) msg.id: msg,
    };

    return Listener(
      onPointerDown: (PointerDownEvent event) {
        if ((event.buttons & kPrimaryMouseButton) != 0 &&
            selectionCubit.state.isSelectionMode) {
          setState(() {
            _isDragSelecting = true;
            _visitedIds.clear();
          });
        }
      },
      onPointerUp: (_) {
        if (_isDragSelecting) {
          setState(() {
            _isDragSelecting = false;
            _visitedIds.clear();
          });
        }
      },
      child: ListView.separated(
        cacheExtent: 1200,
        reverse: true,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        itemCount: widget.messages.length,
        separatorBuilder: (BuildContext context, int index) {
          return const SizedBox(height: 8);
        },
        itemBuilder: (BuildContext context, int index) {
          final GroupMessage message = widget.messages[index];
          final GroupMessage? repliedMessage = message.replyToMessageId != null
              ? messagesById[message.replyToMessageId!]
              : null;
          final String replyText = repliedMessage?.text ?? '';
          final User? repliedSender = repliedMessage != null
              ? participantsMap[repliedMessage.senderId]
              : null;
          final String? replyAuthor = repliedSender != null
              ? (repliedSender.fullName.isNotEmpty
                    ? repliedSender.fullName
                    : repliedSender.username)
              : null;
          const Duration baseDuration = Duration(milliseconds: 280);
          final Duration delay = Duration(milliseconds: 35 * index);

          final bool isMine = message.senderId == widget.currentUserId;
          final User? sender = participantsMap[message.senderId];
          final String senderName = sender != null
              ? (sender.fullName.isNotEmpty ? sender.fullName : sender.username)
              : 'Unknown';

          final isSelected = selectionCubit.state.isSelected(message.id);

          return MouseRegion(
            onEnter: (_) {
              if (_isDragSelecting && !_visitedIds.contains(message.id)) {
                _visitedIds.add(message.id);
                selectionCubit.toggleMessage(message.id);
              }
            },
            child: ClipRect(
              child: Animate(
                delay: delay,
                effects: const [
                  FadeEffect(duration: baseDuration, curve: Curves.easeOut),
                  SlideEffect(
                    begin: Offset(0, 0.06),
                    end: Offset.zero,
                    duration: baseDuration,
                    curve: Curves.easeOutCubic,
                  ),
                  ScaleEffect(
                    begin: Offset(0.98, 0.98),
                    end: Offset(1, 1),
                    duration: baseDuration,
                    curve: Curves.easeOut,
                  ),
                ],
                child: isMine
                    ? SelectableMessageBubbleWrapper(
                        message: message,
                        companionId: '',
                        currentUserId: widget.currentUserId,
                        isSelected: isSelected,
                        onEnterSelectionMode: () =>
                            selectionCubit.enterSelectionMode(message.id),
                        onToggleSelection: () =>
                            selectionCubit.toggleMessage(message.id),
                        onReply: () => widget.onReply?.call(message),
                        onForward: () => widget.onForward?.call(message),
                        onDelete: () => widget.onDelete?.call(message),
                        replyPreviewText: replyText,
                        replyPreviewAuthor: replyAuthor,
                        onCopy: () async {
                          final String t = message.text.trim();
                          if (t.isNotEmpty) {
                            await Clipboard.setData(ClipboardData(text: t));
                          }
                        },
                      )
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          sender != null
                              ? Avatar.user(user: sender, size: 32)
                              : Avatar.user(
                                  user: _placeholderUser(message.senderId),
                                  size: 32,
                                ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: SelectableMessageBubbleWrapper(
                              message: message,
                              companionId: '',
                              currentUserId: widget.currentUserId,
                              sender: senderName,
                              isSelected: isSelected,
                              onEnterSelectionMode: () =>
                                  selectionCubit.enterSelectionMode(message.id),
                              onToggleSelection: () =>
                                  selectionCubit.toggleMessage(message.id),
                              onReply: () => widget.onReply?.call(message),
                              onForward: () => widget.onForward?.call(message),
                              onDelete: () => widget.onDelete?.call(message),
                              replyPreviewText: replyText,
                              replyPreviewAuthor: replyAuthor,
                              onCopy: () async {
                                final String t = message.text.trim();
                                if (t.isNotEmpty) {
                                  await Clipboard.setData(
                                    ClipboardData(text: t),
                                  );
                                }
                              },
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          );
        },
      ),
    );
  }

  User _placeholderUser(String senderId) {
    final DateTime now = DateTime.now();
    return User(
      userId: senderId,
      username: senderId,
      firstName: 'Unknown',
      lastName: '',
      languageCode: 'en',
      isDeleted: false,
      isBanned: false,
      createdAt: now,
      updatedAt: now,
    );
  }
}
