import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/features/conversation/subfeatures/private/presentation/presentation.dart';
import 'package:locnet_app/features/message/subfeatures/message_input/domain/domain.dart';
import 'package:locnet_app/features/message/subfeatures/message_input/presentation/presentation.dart';
import 'package:locnet_app/uikit/uikit.dart';

class MessageInputBar extends StatefulWidget {
  const MessageInputBar({required this.conversationId, super.key});

  final String conversationId;

  @override
  State<MessageInputBar> createState() => _MessageInputBarState();
}

class _MessageInputBarState extends State<MessageInputBar> {
  late final TextEditingController _textEditingController;
  bool _isEmojiPickerVisible = false;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  void _toggleEmojiSelector() {
    setState(() {
      _isEmojiPickerVisible = !_isEmojiPickerVisible;
    });
  }

  void _handleAttachPressed() {
    context.read<MessageAttachmentsCubit>().pickFiles();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final l10n = context.l10n;

    return BlocBuilder<MessageAttachmentsCubit, MessageAttachmentsState>(
      builder: (context, state) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (state.files.isNotEmpty)
              MessageAttachmentsPreview(
                files: state.files,
                onRemovePressed: (UploadableFile file) {
                  context.read<MessageAttachmentsCubit>().removeFile(file);
                },
                onOrderChanged: (List<UploadableFile> newOrder) {
                  context.read<MessageAttachmentsCubit>().applyNewOrder(
                    newOrder,
                  );
                },
              ),

            SafeArea(
              top: false,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceBright,
                  border: Border(
                    top: BorderSide(
                      color: colorScheme.surfaceContainer.withAlpha(80),
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    RoundedIconButton(
                      icon: Icons.attach_file,
                      backgroundColor: colorScheme.surfaceBright,
                      onPressed: _handleAttachPressed,
                      buttonSize: 35,
                      iconSize: 25,
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: MessageInputField(
                        controller: _textEditingController,
                        hintText: '${l10n.message}...',
                        maxSymbols: 4096,
                      ),
                    ),
                    const SizedBox(width: 5),
                    RoundedIconButton(
                      buttonSize: 35,
                      backgroundColor: colorScheme.surfaceBright,
                      icon: _isEmojiPickerVisible
                          ? Icons.close
                          : Icons.emoji_emotions_outlined,
                      onPressed: _toggleEmojiSelector,
                      iconSize: 25,
                    ),
                    const SizedBox(width: 5),
                    RoundedIconButton(
                      icon: Icons.send,
                      backgroundColor: colorScheme.surfaceBright,
                      onPressed: () {
                        context.read<PrivateMessageActionsCubit>().sendMessage(
                          conversationId: widget.conversationId,
                          text: _textEditingController.text,
                        );
                        _textEditingController.clear();
                      },
                      buttonSize: 35,
                      iconSize: 23,
                    ),
                  ],
                ),
              ),
            ),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 180),
              child: _isEmojiPickerVisible
                  ? EmojiSelector(
                      key: const ValueKey('emoji-selector'),
                      textController: _textEditingController,
                    )
                  : const SizedBox.shrink(key: ValueKey('empty')),
            ),
          ],
        );
      },
    );
  }
}
