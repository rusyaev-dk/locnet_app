import 'package:flutter/material.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/uikit/uikit.dart';

class SettingsHeader extends StatelessWidget {
  const SettingsHeader({
    this.title,
    this.showBackButton = true,
    this.popsOnClose = 1,
    super.key,
  });

  final String? title;
  final bool showBackButton;
  final int popsOnClose;

  @override
  Widget build(BuildContext context) {
    final textScheme = context.textScheme;
    final l10n = context.l10n;
    final displayTitle = title ?? l10n.settings;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          if (showBackButton)
            RoundedIconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: Icons.chevron_left,
              backgroundColor: Colors.transparent,
            ),
          if (showBackButton) const SizedBox(width: 8),
          Expanded(
            flex: 5,
            child: Text(
              displayTitle,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              style: textScheme.display.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
                fontSize: 20,
              ),
            ),
          ),
          const Spacer(),
          RoundedIconButton(
            buttonSize: 35,
            iconSize: 18.5,
            onPressed: () {
              for (int i = 0; i < popsOnClose; i++) {
                if (context.mounted) Navigator.of(context).pop();
              }
            },
            icon: Icons.close,
          ),
        ],
      ),
    );
  }
}
