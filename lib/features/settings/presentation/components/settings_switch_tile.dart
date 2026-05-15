import 'package:flutter/material.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/uikit/uikit.dart';

/// A switch row inside a [SettingsGroupCard].
class SettingsSwitchTile extends StatelessWidget {
  const SettingsSwitchTile({
    required this.title,
    required this.value,
    required this.onChanged,
    this.subtitle,
    this.enabled = true,
    super.key,
  });

  final String title;
  final String? subtitle;
  final bool value;
  final bool enabled;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final textScheme = context.textScheme;
    final colorScheme = context.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
      child: MergeSemantics(
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: textScheme.label.copyWith(
                      color: enabled
                          ? colorScheme.onSurface
                          : colorScheme.onSurfaceVariant,
                    ),
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
            const SizedBox(width: 12),
            AppSwitch(value: value, onChanged: enabled ? onChanged : null),
          ],
        ),
      ),
    );
  }
}
