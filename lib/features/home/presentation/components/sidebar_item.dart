// sidebar_item.dart
import 'package:flutter/material.dart';
import 'package:locnet_app/app/app.dart';

class SidebarItem extends StatelessWidget {
  const SidebarItem({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
    super.key,
  });

  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textScheme = context.textScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: AnimatedContainer(
          duration: kThemeChangeDuration,
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          decoration: BoxDecoration(
            color: isSelected
                ? colorScheme.primary.withAlpha(26)
                : Colors.transparent,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 28,
                height: 28,
                padding: const EdgeInsets.all(2),
                child: Icon(
                  icon,
                  size: 22,
                  color: isSelected
                      ? colorScheme.primary
                      : colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                label,
                maxLines: 2,
                softWrap: false,
                textAlign: TextAlign.center,
                overflow: TextOverflow.fade,
                style: textScheme.label.copyWith(
                  color: isSelected
                      ? colorScheme.primary
                      : colorScheme.onSurfaceVariant,
                  fontSize: 13.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
