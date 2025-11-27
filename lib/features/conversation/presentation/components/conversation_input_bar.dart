import 'package:flutter/material.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/uikit/uikit.dart';

class ConversationInputBar extends StatefulWidget {
  const ConversationInputBar({super.key});

  @override
  State<ConversationInputBar> createState() => _ConversationInputBarState();
}

class _ConversationInputBarState extends State<ConversationInputBar> {
  late final TextEditingController _textEditingController;

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

    // TODO: диспатч события в PrivateConversationBloc для отправки сообщения.
    // context.read<PrivateConversationBloc>().add(
    //   PrivateConversationSendMessageEvent(text: text),
    // );

    _textEditingController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          border: Border(
            top: BorderSide(color: colorScheme.surfaceContainer.withAlpha(80)),
          ),
        ),
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.emoji_emotions_outlined),
              onPressed: () {
                // TODO: open emoji picker.
              },
            ),
            Expanded(
              child: AppTextField(
                controller: _textEditingController,
                hintText: 'Message',
                maxLines: 4,
                minLines: 1,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.send),
              onPressed: _handleSendPressed,
            ),
          ],
        ),
      ),
    );
  }
}
