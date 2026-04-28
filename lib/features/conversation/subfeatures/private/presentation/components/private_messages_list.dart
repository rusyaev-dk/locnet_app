import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:locnet_app/features/conversation/subfeatures/private/private.dart';
import 'package:locnet_app/features/message/subfeatures/message_selection/presentation/blocs/message_selection_cubit.dart';
import 'package:locnet_app/features/message/subfeatures/message_selection/presentation/components/selectable_message_bubble_wrapper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';

class PrivateMessagesList extends StatefulWidget {
  const PrivateMessagesList({
    required this.messages,
    required this.companionId,
    this.highlightedMessageId,
    this.onHighlightConsumed,
    this.onReply,
    this.onForward,
    this.onDelete,
    super.key,
  });

  final List<PrivateMessage> messages;
  final String companionId;
  final String? highlightedMessageId;
  final ValueChanged<String>? onHighlightConsumed;
  final void Function(PrivateMessage message)? onReply;
  final void Function(PrivateMessage message)? onForward;
  final void Function(PrivateMessage message)? onDelete;

  @override
  State<PrivateMessagesList> createState() => _PrivateMessagesListState();
}

class _PrivateMessagesListState extends State<PrivateMessagesList> {
  bool _isDragSelecting = false;
  final Set<String> _visitedIds = <String>{};
  final Map<String, GlobalKey> _messageKeys = <String, GlobalKey>{};

  @override
  void didUpdateWidget(covariant PrivateMessagesList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.highlightedMessageId != null &&
        widget.highlightedMessageId != oldWidget.highlightedMessageId) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToMessage(widget.highlightedMessageId!);
      });
    }
  }

  void _scrollToMessage(String messageId) {
    final BuildContext? targetContext = _messageKeys[messageId]?.currentContext;
    if (targetContext == null) {
      return;
    }
    Scrollable.ensureVisible(
      targetContext,
      alignment: 0.5,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
    );
    widget.onHighlightConsumed?.call(messageId);
  }

  @override
  Widget build(BuildContext context) {
    final selectionCubit = context.watch<MessageSelectionCubit>();
    final Map<String, PrivateMessage> messagesById = <String, PrivateMessage>{
      for (final PrivateMessage msg in widget.messages) msg.id: msg,
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
          return const SizedBox(height: 4);
        },
        itemBuilder: (BuildContext context, int index) {
          final PrivateMessage message = widget.messages[index];
          final GlobalKey itemKey = _messageKeys[message.id] ??= GlobalKey(
            debugLabel: message.id,
          );
          final bool isHighlighted = widget.highlightedMessageId == message.id;
          final String replyText = message.replyToMessageId != null
              ? (messagesById[message.replyToMessageId!]?.text ?? '')
              : '';
          const Duration baseDuration = Duration(milliseconds: 280);
          final Duration delay = Duration(milliseconds: 35 * index);
          final isSelected = selectionCubit.state.isSelected(message.id);

          return Container(
            key: itemKey,
            decoration: isHighlighted
                ? BoxDecoration(
                    color: Theme.of(context).colorScheme.primary.withAlpha(28),
                    borderRadius: BorderRadius.circular(14),
                  )
                : null,
            child: MouseRegion(
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
                  child: SelectableMessageBubbleWrapper(
                    message: message,
                    companionId: widget.companionId,
                    isSelected: isSelected,
                    onEnterSelectionMode: () =>
                        selectionCubit.enterSelectionMode(message.id),
                    onToggleSelection: () =>
                        selectionCubit.toggleMessage(message.id),
                    onReply: () => widget.onReply?.call(message),
                    onForward: () => widget.onForward?.call(message),
                    onDelete: () => widget.onDelete?.call(message),
                    replyPreviewText: replyText,
                    onCopy: () async {
                      final String text = message.text.trim();
                      if (text.isNotEmpty) {
                        await Clipboard.setData(ClipboardData(text: text));
                      }
                    },
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
