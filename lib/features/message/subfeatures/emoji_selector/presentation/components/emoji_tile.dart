// emoji_tile.dart
import 'package:flutter/material.dart';
import 'package:locnet_app/app/app.dart';

class EmojiTile extends StatefulWidget {
  const EmojiTile({required this.emoji, required this.onPressed, super.key});

  final String emoji;
  final VoidCallback onPressed;

  @override
  State<EmojiTile> createState() => _EmojiTileState();
}

class _EmojiTileState extends State<EmojiTile> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    return RepaintBoundary(
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: Listener(
          behavior: HitTestBehavior.opaque,
          onPointerUp: (_) => widget.onPressed(),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 120),
            curve: Curves.easeOut,
            decoration: BoxDecoration(
              color: _hovered
                  ? colorScheme.onSurface.withAlpha(18)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: Text(widget.emoji, style: const TextStyle(fontSize: 24)),
          ),
        ),
      ),
    );
  }
}
