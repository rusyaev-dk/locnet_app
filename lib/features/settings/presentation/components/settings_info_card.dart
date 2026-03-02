import 'package:flutter/material.dart';
import 'package:locnet_app/app/app.dart';

enum SettingsInfoCardVariant { info, warning }

/// An info / warning card for contextual notes inside settings sections.
class SettingsInfoCard extends StatelessWidget {
  const SettingsInfoCard({
    required this.message,
    this.icon = Icons.info_outline,
    this.variant = SettingsInfoCardVariant.info,
    super.key,
  });

  final String message;
  final IconData icon;
  final SettingsInfoCardVariant variant;

  @override
  Widget build(BuildContext context) {
    final textScheme = context.textScheme;
    final colorScheme = context.colorScheme;

    final Color bgColor = variant == SettingsInfoCardVariant.warning
        ? colorScheme.errorContainer.withAlpha(180)
        : colorScheme.surfaceContainerHigh;

    final Color fgColor = variant == SettingsInfoCardVariant.warning
        ? colorScheme.onErrorContainer
        : colorScheme.onSurfaceVariant;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: fgColor),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: textScheme.caption.copyWith(
                color: fgColor,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
