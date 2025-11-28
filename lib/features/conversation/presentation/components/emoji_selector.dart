import 'package:flutter/material.dart';
import 'package:locnet_app/app/app.dart';

class EmojiSelector extends StatefulWidget {
  const EmojiSelector({required this.textController, super.key});

  final TextEditingController textController;

  @override
  State<EmojiSelector> createState() => _EmojiSelectorState();
}

class _EmojiSelectorState extends State<EmojiSelector> {
  int _selectedCategoryIndex = 0;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textScheme = context.textScheme;

    final double panelHeight = MediaQuery.of(context).size.height * 0.35;

    const List<_EmojiCategory> categories = _emojiCategories;
    final _EmojiCategory selectedCategory = categories[_selectedCategoryIndex];

    return SizedBox(
      height: panelHeight,
      child: Material(
        color: colorScheme.surface,
        elevation: 8,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        child: Column(
          children: [
            const SizedBox(height: 5),
            SizedBox(
              height: 40,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                separatorBuilder: (_, _) => const SizedBox(width: 4),
                itemBuilder: (BuildContext context, int index) {
                  final _EmojiCategory category = categories[index];
                  final bool isSelected = index == _selectedCategoryIndex;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedCategoryIndex = index;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? colorScheme.surfaceContainerHighest
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            category.icon,
                            style: const TextStyle(fontSize: 18),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            category.name,
                            style: textScheme.label.copyWith(
                              fontSize: 13,
                              color: isSelected
                                  ? colorScheme.onSurface
                                  : colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 5),
            Divider(height: 1, color: colorScheme.outlineVariant.withAlpha(80)),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(8),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 8,
                  mainAxisSpacing: 4,
                  crossAxisSpacing: 4,
                ),
                itemCount: selectedCategory.emojis.length,
                itemBuilder: (BuildContext context, int index) {
                  final String emoji = selectedCategory.emojis[index];

                  return InkWell(
                    onTap: () => _insertEmoji(emoji),
                    borderRadius: BorderRadius.circular(8),
                    child: Center(
                      child: Text(emoji, style: const TextStyle(fontSize: 24)),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _insertEmoji(String emoji) {
    final TextEditingValue value = widget.textController.value;
    final String fullText = value.text;
    final TextSelection selection = value.selection;

    final int start = selection.start;
    final int end = selection.end;

    if (start < 0 || end < 0) {
      final String newText = fullText + emoji;
      widget.textController.text = newText;
      widget.textController.selection = TextSelection.fromPosition(
        TextPosition(offset: newText.length),
      );
      return;
    }

    final String newText = fullText.replaceRange(start, end, emoji);
    final int newOffset = start + emoji.length;

    widget.textController.value = value.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: newOffset),
      composing: TextRange.empty,
    );
  }
}

class _EmojiCategory {
  const _EmojiCategory({
    required this.name,
    required this.icon,
    required this.emojis,
  });

  final String name;
  final String icon;
  final List<String> emojis;
}

const List<_EmojiCategory> _emojiCategories = <_EmojiCategory>[
  _EmojiCategory(
    name: 'Smileys',
    icon: '😊',
    emojis: <String>[
      '😀',
      '😃',
      '😄',
      '😁',
      '😆',
      '😅',
      '😂',
      '🤣',
      '😊',
      '😇',
      '🙂',
      '🙃',
      '😉',
      '😍',
      '🥰',
      '😘',
      '😗',
      '😙',
      '😚',
      '😋',
      '😛',
      '😜',
      '🤪',
      '😝',
      '🤑',
      '🤗',
      '🤭',
      '🤫',
    ],
  ),
  _EmojiCategory(
    name: 'Animals',
    icon: '🐻',
    emojis: <String>[
      '🐶',
      '🐱',
      '🐭',
      '🐹',
      '🐰',
      '🦊',
      '🐻',
      '🐼',
      '🐨',
      '🐯',
      '🦁',
      '🐮',
      '🐷',
      '🐸',
      '🐵',
      '🐥',
      '🦆',
      '🦉',
      '🐙',
      '🐠',
    ],
  ),
  _EmojiCategory(
    name: 'Food',
    icon: '🍔',
    emojis: <String>[
      '🍎',
      '🍊',
      '🍌',
      '🍉',
      '🍇',
      '🍓',
      '🍒',
      '🍍',
      '🥝',
      '🍅',
      '🥕',
      '🌽',
      '🍔',
      '🍟',
      '🍕',
      '🌭',
      '🍣',
      '🍜',
      '🍦',
      '🍫',
    ],
  ),
  _EmojiCategory(
    name: 'Activity',
    icon: '⚽',
    emojis: <String>[
      '⚽',
      '🏀',
      '🏈',
      '⚾',
      '🎾',
      '🏐',
      '🏉',
      '🎱',
      '🏓',
      '🏸',
      '🥊',
      '🎮',
      '🎲',
      '🎳',
      '🎯',
      '🎼',
      '🎧',
      '🎤',
    ],
  ),
  _EmojiCategory(
    name: 'Symbols',
    icon: '❤️',
    emojis: <String>[
      '❤️',
      '🧡',
      '💛',
      '💚',
      '💙',
      '💜',
      '🖤',
      '🤍',
      '🤎',
      '✨',
      '⭐',
      '🔥',
      '⚡',
      '💥',
      '💫',
      '❗',
      '❓',
      '✅',
      '❌',
      '⚠️',
    ],
  ),
];
