import 'package:flutter/material.dart';
import 'package:locnet_app/app/app.dart';

/// A tappable navigation row with optional trailing text and chevron.
class SettingsNavTile extends StatelessWidget {
  const SettingsNavTile({
    required this.title,
    required this.onTap,
    this.subtitle,
    this.trailingText,
    this.leadingIcon,
    this.showChevron = true,
    this.enabled = true,
    super.key,
  });

  final String title;
  final String? subtitle;
  final String? trailingText;
  final IconData? leadingIcon;
  final bool showChevron;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textScheme = context.textScheme;
    final colorScheme = context.colorScheme;

    final Color titleColor = enabled
        ? colorScheme.onSurface
        : colorScheme.onSurfaceVariant;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: enabled ? onTap : null,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
          child: Row(
            children: [
              if (leadingIcon != null) ...[
                Icon(
                  leadingIcon,
                  size: 18,
                  color: enabled
                      ? colorScheme.onSurfaceVariant
                      : colorScheme.outlineVariant,
                ),
                const SizedBox(width: 12),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: textScheme.label.copyWith(color: titleColor),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 3),
                      Text(
                        subtitle!,
                        style: textScheme.caption.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (trailingText != null) ...[
                const SizedBox(width: 8),
                Text(
                  trailingText!,
                  style: textScheme.caption.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
              if (showChevron) ...[
                const SizedBox(width: 4),
                Icon(
                  Icons.chevron_right,
                  size: 18,
                  color: colorScheme.onSurfaceVariant,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
