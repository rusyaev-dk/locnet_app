import 'package:flutter/material.dart';
import 'package:locnet_app/app/app.dart';

class AppTileButtonGroupCard extends StatelessWidget {
  const AppTileButtonGroupCard({
    required this.children,
    super.key,
    this.borderRadius = 16,
    this.dividerIndent = 48,
    this.padding = EdgeInsets.zero,
  });

  final List<Widget> children;
  final double borderRadius;
  final double dividerIndent;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    final List<Widget> columnChildren = <Widget>[];

    for (int index = 0; index < children.length; index += 1) {
      columnChildren.add(children[index]);

      final bool isLast = index == children.length - 1;
      if (!isLast) {
        columnChildren.add(
          Divider(
            height: 1,
            indent: dividerIndent,
            color: colorScheme.outlineVariant,
          ),
        );
      }
    }

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Padding(
        padding: padding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: columnChildren,
        ),
      ),
    );
  }
}

class AppTileButton extends StatelessWidget {
  const AppTileButton({
    required this.title,
    required this.value,
    required this.icon,
    required this.onPressed,
    super.key,
  });

  final String title;
  final String value;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textScheme = context.textScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              Icon(icon, color: colorScheme.onSurfaceVariant),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: textScheme.label.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      value,
                      style: textScheme.label.copyWith(
                        color: colorScheme.onSurface,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Icon(Icons.chevron_right, color: colorScheme.onSurfaceVariant),
            ],
          ),
        ),
      ),
    );
  }
}
