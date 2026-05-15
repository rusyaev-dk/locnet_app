import 'package:flutter/material.dart';
import 'package:locnet_app/app/app.dart';

/// Section-level header with headline and optional description.
class SettingsSectionHeader extends StatelessWidget {
  const SettingsSectionHeader({
    required this.title,
    this.description,
    super.key,
  });

  final String title;
  final String? description;

  @override
  Widget build(BuildContext context) {
    final textScheme = context.textScheme;
    final colorScheme = context.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: textScheme.headline.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w700,
          ),
        ),
        if (description != null) ...[
          const SizedBox(height: 6),
          Text(
            description!,
            style: textScheme.label.copyWith(
              color: colorScheme.onSurfaceVariant,
              height: 1.4,
            ),
          ),
        ],
      ],
    );
  }
}
