import 'package:flutter/material.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/uikit/uikit.dart';

class SessionHeader extends StatelessWidget {
  const SessionHeader({this.popsOnClose = 3, super.key});

  /// Number of Navigator.pop() to run when close is pressed (e.g. 3 for Settings → Profile → Session).
  final int popsOnClose;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textScheme = context.textScheme;
    final l10n = context.l10n;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          RoundedIconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icons.chevron_left,
            backgroundColor: Colors.transparent,
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 5,
            child: Text(
              l10n.sessionDetails,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              style: textScheme.display.copyWith(
                color: colorScheme.onSurface,
                fontSize: 17,
              ),
            ),
          ),
          const Spacer(),
          RoundedIconButton(
            onPressed: () {
              for (int i = 0; i < popsOnClose; i++) {
                if (context.mounted) Navigator.of(context).pop();
              }
            },
            icon: Icons.close,
            backgroundColor: Colors.transparent,
          ),
        ],
      ),
    );
  }
}
