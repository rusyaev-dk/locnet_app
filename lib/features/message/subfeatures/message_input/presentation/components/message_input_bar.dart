import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/features/conversation/subfeatures/private/presentation/presentation.dart';
import 'package:locnet_app/features/message/subfeatures/emoji_selector/presentation/presentation.dart';
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
  MessageRichInputController? _textEditingController;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_textEditingController != null) {
      return;
    }

    final colorScheme = context.colorScheme;
    final textScheme = context.textScheme;

    final TextStyle baseStyle = textScheme.label.copyWith(
      fontSize: 16,
      color: colorScheme.onSurface,
    );

    _textEditingController = MessageRichInputController(
      baseStyle: baseStyle,
      boldStyle: baseStyle.copyWith(fontWeight: FontWeight.w700),
      italicStyle: baseStyle.copyWith(fontStyle: FontStyle.italic),
      underlineStyle: baseStyle.copyWith(decoration: TextDecoration.underline),
      codeStyle: baseStyle.copyWith(fontFamily: 'monospace'),
      codeBlockStyle: baseStyle.copyWith(
        fontFamily: 'monospace',
        height: 1.25,
        backgroundColor: colorScheme.onSurface.withAlpha(18),
      ),
      strikeStyle: baseStyle.copyWith(decoration: TextDecoration.lineThrough),
      linkStyle: baseStyle.copyWith(
        color: colorScheme.primary,
        decoration: TextDecoration.none,
      ),
    );
  }

  @override
  void dispose() {
    _textEditingController?.dispose();
    super.dispose();
  }

  void _handleAttachPressed() {
    context.read<MessageAttachmentsCubit>().pickFiles();
  }

  String _buildMarkdownForSend() {
    final MessageRichInputController controller = _textEditingController!;
    final String plainText = controller.text;
    if (plainText.trim().isEmpty) {
      return '';
    }

    return MessageMarkdownCodec.encode(
      text: plainText,
      ranges: controller.ranges,
    );
  }

  void _send() {
    final String markdown = _buildMarkdownForSend();
    if (markdown.isEmpty) {
      return;
    }

    context.read<PrivateMessageActionsCubit>().sendMessage(
      conversationId: widget.conversationId,
      attachedFiles: context.read<MessageAttachmentsCubit>().state.files,
      text: markdown,
    );

    final MessageRichInputController _ = _textEditingController!
      ..clear()
      ..clearAllFormatting();
  }

  @override
  Widget build(BuildContext context) {
    final MessageRichInputController controller = _textEditingController!;

    final colorScheme = context.colorScheme;
    final l10n = context.l10n;

    return BlocBuilder<MessageAttachmentsCubit, MessageAttachmentsState>(
      builder: (context, state) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
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
                        controller: controller,
                        hintText: '${l10n.message}...',
                        maxSymbols: 4096,
                        onSubmitted: (_) => _send(),
                      ),
                    ),
                    const SizedBox(width: 5),
                    EmojiButton(textController: controller),
                    const SizedBox(width: 5),
                    RoundedIconButton(
                      icon: Icons.send,
                      backgroundColor: colorScheme.surfaceBright,
                      onPressed: _send,
                      buttonSize: 35,
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
