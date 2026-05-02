import 'package:flutter/material.dart';
import 'package:locnet_app/app/app.dart';

/// Read-only label / value row inside a [SettingsGroupCard].
class SettingsValueTile extends StatelessWidget {
  const SettingsValueTile({
    required this.label,
    required this.value,
    this.leadingIcon,
    super.key,
  });

  final String label;
  final String value;
  final IconData? leadingIcon;

  @override
  Widget build(BuildContext context) {
    final textScheme = context.textScheme;
    final colorScheme = context.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (leadingIcon != null) ...[
            Icon(
              leadingIcon,
              size: 18,
              color: colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 12),
          ],
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: textScheme.label.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: textScheme.label.copyWith(
                color: colorScheme.onSurface,
              ),
              textAlign: TextAlign.end,
              maxLines: 6,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
