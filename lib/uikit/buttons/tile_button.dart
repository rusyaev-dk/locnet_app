import 'package:flutter/material.dart';
import 'package:locnet_app/app/app.dart';

/// Card container for grouped tile buttons; uses design tokens.
/// Set [backgroundColor] to transparent for minimal list style.
class AppTileButtonGroupCard extends StatelessWidget {
  const AppTileButtonGroupCard({
    required this.children,
    super.key,
    this.borderRadius,
    this.dividerIndent,
    this.padding = EdgeInsets.zero,
    this.backgroundColor,
  });

  final List<Widget> children;
  final BorderRadius? borderRadius;
  final double? dividerIndent;
  final EdgeInsetsGeometry padding;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final radii = context.radii;

    final double indent = dividerIndent ?? 56;
    final List<Widget> columnChildren = <Widget>[];

    for (int index = 0; index < children.length; index += 1) {
      columnChildren.add(children[index]);

      final bool isLast = index == children.length - 1;
      if (!isLast) {
        columnChildren.add(
          Divider(height: 1, indent: indent, color: colorScheme.outlineVariant),
        );
      }
    }

    final Color bg = backgroundColor ?? colorScheme.surface;

    return Container(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: borderRadius ?? radii.defaultRadiusValue,
      ),
      child: Padding(
        padding: padding,
        child: Column(mainAxisSize: MainAxisSize.min, children: columnChildren),
      ),
    );
  }
}

/// List-tile style button with icon, title, optional value; desktop hover/focus.
/// If [value] is empty, minimal style is used.
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
    final radii = context.radii;
    final bool hasValue = value.isNotEmpty;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: radii.defaultRadiusValue,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              Icon(icon, size: 20, color: colorScheme.onSurfaceVariant),
              const SizedBox(width: 12),
              Expanded(
                child: hasValue
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            title,
                            style: textScheme.caption.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            value,
                            style: textScheme.subtitle.copyWith(
                              color: colorScheme.onSurface,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      )
                    : Text(
                        title,
                        style: textScheme.subtitle.copyWith(
                          color: colorScheme.onSurface,
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
