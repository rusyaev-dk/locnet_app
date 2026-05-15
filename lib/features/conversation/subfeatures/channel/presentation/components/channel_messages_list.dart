import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:locnet_app/features/conversation/subfeatures/channel/channel.dart';
import 'package:locnet_app/features/message/subfeatures/message_selection/presentation/blocs/message_selection_cubit.dart';
import 'package:locnet_app/features/message/subfeatures/message_selection/presentation/components/selectable_message_bubble_wrapper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';

class ChannelMessagesList extends StatefulWidget {
  const ChannelMessagesList({
    required this.messages,
    this.onReply,
    this.onForward,
    this.onDelete,
    super.key,
  });

  final List<ChannelPublication> messages;
  final void Function(ChannelPublication publication)? onReply;
  final void Function(ChannelPublication publication)? onForward;
  final void Function(ChannelPublication publication)? onDelete;

  @override
  State<ChannelMessagesList> createState() => _ChannelMessagesListState();
}

class _ChannelMessagesListState extends State<ChannelMessagesList> {
  bool _isDragSelecting = false;
  final Set<String> _visitedIds = <String>{};

  @override
  Widget build(BuildContext context) {
    final selectionCubit = context.watch<MessageSelectionCubit>();
    final Map<String, ChannelPublication> publicationsById =
        <String, ChannelPublication>{
          for (final ChannelPublication publication in widget.messages)
            publication.publicationId: publication,
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
        final ChannelPublication publication = widget.messages[index];
        final String replyText =
            publication.replyToPublicationId != null
            ? (publicationsById[publication.replyToPublicationId!]?.text ?? '')
            : '';
        const Duration baseDuration = Duration(milliseconds: 280);
        final Duration delay = Duration(milliseconds: 35 * index);

        final isSelected =
            selectionCubit.state.isSelected(publication.publicationId);

        return MouseRegion(
          onEnter: (_) {
            if (_isDragSelecting &&
                !_visitedIds.contains(publication.publicationId)) {
              _visitedIds.add(publication.publicationId);
              selectionCubit.toggleMessage(publication.publicationId);
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
                message: publication,
                companionId: '',
                forceLeft: true,
                showDeliveryStatus: false,
                isSelected: isSelected,
                onEnterSelectionMode: () => selectionCubit
                    .enterSelectionMode(publication.publicationId),
                onToggleSelection: () =>
                    selectionCubit.toggleMessage(publication.publicationId),
                onReply: () => widget.onReply?.call(publication),
                onForward: () => widget.onForward?.call(publication),
                onDelete: () => widget.onDelete?.call(publication),
                replyPreviewText: replyText,
                onCopy: () async {
                  final String text = (publication.text ?? '').trim();
                  if (text.isNotEmpty) {
                    await Clipboard.setData(ClipboardData(text: text));
                  }
                },
              ),
            ),
          ),
        );
      },
    ),
    );
  }
}
