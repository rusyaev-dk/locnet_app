// emoji_tile.dart
import 'package:flutter/material.dart';
import 'package:locnet_app/app/app.dart';

class EmojiTile extends StatelessWidget {
  const EmojiTile({required this.emoji, required this.onPressed, super.key});

  final String emoji;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onPressed,
        child: _EmojiTileHoverBackground(
          onSurface: colorScheme.onSurface,
          child: const Center(child: _EmojiTileText()),
        ),
      ),
    );
  }
}

class _EmojiTileHoverBackground extends StatefulWidget {
  const _EmojiTileHoverBackground({
    required this.onSurface,
    required this.child,
  });

  final Color onSurface;
  final Widget child;

  @override
  State<_EmojiTileHoverBackground> createState() =>
      _EmojiTileHoverBackgroundState();
}

class _EmojiTileHoverBackgroundState extends State<_EmojiTileHoverBackground> {
  bool _isHovered = false;

  void _setHovered(bool value) {
    if (_isHovered == value) {
      return;
    }
    setState(() => _isHovered = value);
  }

  @override
  Widget build(BuildContext context) {
    final Color targetColor = _isHovered
        ? widget.onSurface.withAlpha(18)
        : Colors.transparent;

    return MouseRegion(
      onEnter: (_) => _setHovered(true),
      onExit: (_) => _setHovered(false),
      child: RepaintBoundary(
        child: TweenAnimationBuilder<Color?>(
          tween: ColorTween(end: targetColor),
          duration: const Duration(milliseconds: 120),
          curve: Curves.easeOut,
          builder: (BuildContext context, Color? color, Widget? child) {
            return DecoratedBox(
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(8),
              ),
              child: child,
            );
          },
          child: widget.child,
        ),
      ),
    );
  }
}

class _EmojiTileText extends StatelessWidget {
  const _EmojiTileText();

  @override
  Widget build(BuildContext context) {
    final EmojiTile? tileWidget = context
        .findAncestorWidgetOfExactType<EmojiTile>();

    final String emoji = tileWidget?.emoji ?? '';

    return Text(
      emoji,
      style: const TextStyle(
        fontSize: 24,
        fontFamilyFallback: <String>['NotoColorEmoji'],
      ),
    );
  }
}
