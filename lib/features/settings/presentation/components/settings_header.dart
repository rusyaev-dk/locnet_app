import 'package:flutter/material.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/uikit/uikit.dart';

class SettingsHeader extends StatelessWidget {
  const SettingsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textScheme = context.textScheme;
    final l10n = context.l10n;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Expanded(
            flex: 5,
            child: Text(
              l10n.settings,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              style: textScheme.display.copyWith(
                color: colorScheme.onSurface,
                fontSize: 24,
              ),
            ),
          ),
          const Spacer(),
          RoundedIconButton(
            buttonSize: 35,
            iconSize: 18.5,
            onPressed: () => Navigator.of(context).pop(),
            icon: Icons.close,
          ),
        ],
      ),
    );
  }
}
