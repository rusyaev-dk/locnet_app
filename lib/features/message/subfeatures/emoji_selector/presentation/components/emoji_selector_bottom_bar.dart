import 'package:flutter/material.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/features/message/subfeatures/emoji_selector/presentation/presentation.dart';

class EmojiSelectorBottomBar extends StatelessWidget {
  const EmojiSelectorBottomBar({required this.onCategoryTap, super.key});

  final void Function(EmojiCategoryType type) onCategoryTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    return Container(
      height: 38,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        border: Border(
          top: BorderSide(color: colorScheme.outlineVariant.withAlpha(80)),
        ),
      ),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        itemCount: emojiCategories.length,
        separatorBuilder: (BuildContext context, int index) {
          return const SizedBox(width: 4);
        },
        itemBuilder: (BuildContext context, int index) {
          final EmojiCategory category = emojiCategories[index];
          return _EmojiSelectorBottomBarButton(
            icon: emojiCategoryIcon(category.type),
            onPressed: () => onCategoryTap(category.type),
          );
        },
      ),
    );
  }

  IconData emojiCategoryIcon(EmojiCategoryType type) {
    switch (type) {
      case EmojiCategoryType.smileysAndPeople:
        return Icons.emoji_emotions_outlined;
      case EmojiCategoryType.nature:
        return Icons.pets_outlined;
      case EmojiCategoryType.foodAndDrink:
        return Icons.restaurant_outlined;
      case EmojiCategoryType.activities:
        return Icons.sports_soccer_outlined;
      case EmojiCategoryType.travelAndPlaces:
        return Icons.directions_car_outlined;
      case EmojiCategoryType.objects:
        return Icons.lightbulb_outline;
      case EmojiCategoryType.symbols:
        return Icons.tag_outlined;
      case EmojiCategoryType.flags:
        return Icons.flag_outlined;
    }
  }
}

class _EmojiSelectorBottomBarButton extends StatefulWidget {
  const _EmojiSelectorBottomBarButton({
    required this.icon,
    required this.onPressed,
  });

  final IconData icon;
  final VoidCallback onPressed;

  @override
  State<_EmojiSelectorBottomBarButton> createState() =>
      _EmojiSelectorBottomBarButtonState();
}

class _EmojiSelectorBottomBarButtonState
    extends State<_EmojiSelectorBottomBarButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          curve: Curves.easeOut,
          width: 35,
          height: 35,
          margin: const EdgeInsets.symmetric(vertical: 4),
          decoration: BoxDecoration(
            color: _hovered
                ? colorScheme.onSurface.withAlpha(18)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          alignment: Alignment.center,
          child: Icon(
            widget.icon,
            size: 22,
            color: colorScheme.onSurfaceVariant.withAlpha(160),
          ),
        ),
      ),
    );
  }
}
