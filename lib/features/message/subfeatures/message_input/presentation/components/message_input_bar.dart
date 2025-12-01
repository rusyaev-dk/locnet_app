import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/features/message/subfeatures/message_input/domain/domain.dart';
import 'package:locnet_app/features/message/subfeatures/message_input/presentation/presentation.dart';
import 'package:locnet_app/uikit/uikit.dart';

class MessageInputBar extends StatefulWidget {
  const MessageInputBar({super.key});

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

  void _handleSendPressed() {
    final String text = _textEditingController.text.trim();
    if (text.isEmpty) {
      return;
    }

    final MessageAttachmentsCubit attachmentCubit = context
        .read<MessageAttachmentsCubit>();
    final MessageAttachmentsState attachmentState = attachmentCubit.state;

    final List<UploadableFile> attachedFiles = attachmentState.files;
    // TODO: remove print
    debugPrint("Attached files: ${attachedFiles.length}");
    // TODO: dispatch sending event with [text] and [attachedFiles].
    // context.read<PrivateConversationBloc>().add(
    //   PrivateConversationSendMessageEvent(
    //     text: text,
    //     attachments: attachedFiles,
    //   ),
    // );

    _textEditingController.clear();
    attachmentCubit.clear();
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
      builder: (BuildContext context, MessageAttachmentsState state) {
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
      context.read<MessageAttachmentsCubit>().applyNewOrder(newOrder);
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
                      onPressed: _handleSendPressed,
                      buttonSize: 35,
                      iconSize: 25,
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
