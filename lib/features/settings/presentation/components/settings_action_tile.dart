import 'package:flutter/material.dart';
import 'package:locnet_app/app/app.dart';

/// A tappable action row — for plain or destructive actions.
class SettingsActionTile extends StatelessWidget {
  const SettingsActionTile({
    required this.title,
    this.onTap,
    this.leadingIcon,
    this.destructive = false,
    this.enabled = true,
    super.key,
  });

  final String title;
  final IconData? leadingIcon;
  final VoidCallback? onTap;
  final bool destructive;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final textScheme = context.textScheme;
    final colorScheme = context.colorScheme;

    final Color color = !enabled
        ? colorScheme.onSurfaceVariant
        : destructive
        ? colorScheme.error
        : colorScheme.onSurface;

    final radii = context.radii;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: radii.defaultRadiusValue,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
          child: Row(
            children: [
              if (leadingIcon != null) ...[
                Icon(leadingIcon, size: 18, color: color),
                const SizedBox(width: 12),
              ],
              Text(
                title,
                style: textScheme.label.copyWith(
                  color: color,
                  fontWeight: destructive ? FontWeight.w500 : FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
