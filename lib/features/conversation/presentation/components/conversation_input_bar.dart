import 'package:flutter/material.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/features/conversation/presentation/presentation.dart';
import 'package:locnet_app/uikit/uikit.dart';

class ConversationInputBar extends StatefulWidget {
  const ConversationInputBar({super.key});

  @override
  State<ConversationInputBar> createState() => _ConversationInputBarState();
}

class _ConversationInputBarState extends State<ConversationInputBar> {
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

    // TODO: dispatch sending event
    // context.read<PrivateConversationBloc>().add(
    //   PrivateConversationSendMessageEvent(text: text),
    // );

    _textEditingController.clear();
  }

  void _toggleEmojiSelector() {
    setState(() {
      _isEmojiPickerVisible = !_isEmojiPickerVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final l10n = context.l10n;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
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
                  onPressed: () {},
                  buttonSize: 35,
                  iconSize: 25,
                ),

                const SizedBox(width: 5),

                Expanded(
                  child: MessageInputField(
                    controller: _textEditingController,
                    hintText: "${l10n.message}...",
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
  }
}
