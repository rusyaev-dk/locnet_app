import 'package:flutter/material.dart';
import 'package:locnet_app/app/app.dart';

class AppActionButtonGroup extends StatelessWidget {
  const AppActionButtonGroup({
    required this.children,
    super.key,
    this.padding = const EdgeInsets.symmetric(vertical: 4),
    this.borderRadius = 16,
  });

  final List<Widget> children;
  final EdgeInsetsGeometry padding;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    final List<Widget> items = <Widget>[];

    for (int index = 0; index < children.length; index += 1) {
      items.add(children[index]);

      final bool isLast = index == children.length - 1;
      if (!isLast) {
        items.add(
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Divider(height: 1, color: colorScheme.outlineVariant),
          ),
        );
      }
    }

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: padding,
        child: Column(mainAxisSize: MainAxisSize.min, children: items),
      ),
    );
  }
}

class AppActionButton extends StatelessWidget {
  const AppActionButton({
    required this.icon,
    required this.label,
    required this.onPressed,
    super.key,
    this.height = 60,
  });

  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final double height;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textScheme = context.textScheme;

    final Color backgroundColor = colorScheme.surfaceContainer.withAlpha(140);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: height,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: colorScheme.outlineVariant),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 20, color: colorScheme.onSurface),
              const SizedBox(width: 8),
              Text(
                label,
                style: textScheme.label.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AppActionButtonRow extends StatelessWidget {
  const AppActionButtonRow({
    required this.children,
    super.key,
    this.spacing = 10,
  });

  final List<Widget> children;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    return Row(children: _buildExpandedChildrenWithSpacing());
  }

  List<Widget> _buildExpandedChildrenWithSpacing() {
    final List<Widget> result = <Widget>[];

    for (int index = 0; index < children.length; index += 1) {
      result.add(Expanded(child: children[index]));

      final bool isLast = index == children.length - 1;
      if (!isLast) {
        result.add(SizedBox(width: spacing));
      }
    }

    return result;
  }
}
