import 'package:flutter/material.dart';
import 'package:locnet_app/app/app.dart';

/// Switch list tile for notification toggles in settings.
class NotificationSwitchTile extends StatelessWidget {
  const NotificationSwitchTile({
    required this.title,
    required this.value,
    required this.onChanged,
    this.subtitle,
    super.key,
  });

  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final textScheme = context.textScheme;
    final colorScheme = context.colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        child: SwitchListTile(
          title: Text(
            title,
            style: textScheme.label.copyWith(color: colorScheme.onSurface),
          ),
          subtitle: subtitle != null
              ? Text(
                  subtitle!,
                  style: textScheme.label.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontSize: 12,
                  ),
                )
              : null,
          value: value,
          onChanged: onChanged,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
