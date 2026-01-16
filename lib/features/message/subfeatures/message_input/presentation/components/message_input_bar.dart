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
  late final MessageMarkdownInputController _textEditingController;

  @override
  void initState() {
    super.initState();
    const TextStyle baseStyle = TextStyle(fontSize: 16);

    _textEditingController = MessageMarkdownInputController(
      baseStyle: baseStyle,
      markerStyle: baseStyle.copyWith(color: Colors.black38),
      boldStyle: baseStyle.copyWith(fontWeight: FontWeight.w700),
      italicStyle: baseStyle.copyWith(fontStyle: FontStyle.italic),
      codeStyle: baseStyle.copyWith(fontFamily: 'monospace'),
      strikeStyle: baseStyle.copyWith(decoration: TextDecoration.lineThrough),
      linkStyle: baseStyle.copyWith(decoration: TextDecoration.underline),
    );
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
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
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                        onSubmitted: (_) {
                          context
                              .read<PrivateMessageActionsCubit>()
                              .sendMessage(
                                conversationId: widget.conversationId,
                                attachedFiles: context
                                    .read<MessageAttachmentsCubit>()
                                    .state
                                    .files,
                                text: _textEditingController.text,
                              );
                          _textEditingController.clear();
                        },
                      ),
                    ),
                    const SizedBox(width: 5),
                    EmojiButton(textController: _textEditingController),
                    const SizedBox(width: 5),
                    RoundedIconButton(
                      icon: Icons.send,
                      backgroundColor: colorScheme.surfaceBright,
                      onPressed: () {
                        context.read<PrivateMessageActionsCubit>().sendMessage(
                          conversationId: widget.conversationId,
                          attachedFiles: context
                              .read<MessageAttachmentsCubit>()
                              .state
                              .files,
                          text: _textEditingController.text,
                        );
                        _textEditingController.clear();
                      },
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
