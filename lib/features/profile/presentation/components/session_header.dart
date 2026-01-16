import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/uikit/uikit.dart';

class SessionHeader extends StatelessWidget {
  const SessionHeader({super.key});

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
            onPressed: () {
              GoRouter.of(context).pop();
            },
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
                fontSize: 20,
              ),
            ),
          ),
          const Spacer(),
          RoundedIconButton(
            onPressed: () {
              GoRouter.of(context).pop();
              GoRouter.of(context).pop();
            },
            icon: Icons.close,
            backgroundColor: Colors.transparent,
          ),
        ],
      ),
    );
  }
}
