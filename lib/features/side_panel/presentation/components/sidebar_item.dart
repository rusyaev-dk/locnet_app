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
    final spacing = context.designTokens.spacing;
    final radii = context.radii;
    final textScheme = context.textScheme;
    final Color selectedBackground = colorScheme.primaryContainer;

    return Tooltip(
      message: label,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Material(
          color: Colors.transparent,
          child: Ink(
            decoration: BoxDecoration(
              color: isSelected ? selectedBackground : Colors.transparent,
              borderRadius: radii.smallRadius,
            ),
            child: InkWell(
              onTap: onTap,
              borderRadius: radii.smallRadius,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: spacing.xs,
                  vertical: spacing.xs + spacing.xxs / 2,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      icon,
                      size: spacing.lg + spacing.xxs / 2,
                      color: isSelected
                          ? colorScheme.primary
                          : colorScheme.onSurfaceVariant,
                    ),
                    SizedBox(
                      height: spacing.sm - spacing.xxs - spacing.xxs / 2,
                    ),
                    Text(
                      label,
                      maxLines: 2,
                      softWrap: false,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.fade,
                      style: textScheme.caption.copyWith(
                        color: isSelected
                            ? colorScheme.primary
                            : colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
