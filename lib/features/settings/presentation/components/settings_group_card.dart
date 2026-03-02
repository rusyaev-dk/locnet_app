import 'package:flutter/material.dart';
import 'package:locnet_app/app/app.dart';

/// A grouped card block for settings: optional group title + items
/// separated by subtle dividers.
class SettingsGroupCard extends StatelessWidget {
  const SettingsGroupCard({
    required this.children,
    this.title,
    this.description,
    super.key,
  });

  final String? title;
  final String? description;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final textScheme = context.textScheme;
    final colorScheme = context.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 8),
            child: Text(
              title!.toUpperCase(),
              style: textScheme.caption.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.6,
              ),
            ),
          ),
        Container(
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerLow,
            borderRadius: BorderRadius.circular(16),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: _buildChildren(context),
          ),
        ),
        if (description != null) ...[
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Text(
              description!,
              style: textScheme.caption.copyWith(
                color: colorScheme.onSurfaceVariant,
                height: 1.4,
              ),
            ),
          ),
        ],
      ],
    );
  }

  List<Widget> _buildChildren(BuildContext context) {
    final colorScheme = context.colorScheme;
    final result = <Widget>[];
    for (int i = 0; i < children.length; i++) {
      result.add(children[i]);
      if (i < children.length - 1) {
        result.add(
          Divider(
            height: 1,
            thickness: 1,
            indent: 16,
            color: colorScheme.outlineVariant,
          ),
        );
      }
    }
    return result;
  }
}
