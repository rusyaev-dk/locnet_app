import 'package:flutter/material.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/uikit/uikit.dart';

class UnifiedSearchHeader extends StatelessWidget {
  const UnifiedSearchHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textScheme = context.textScheme;
    final l10n = context.l10n;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Expanded(
            flex: 5,
            child: Text(
              l10n.search,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              style: textScheme.display.copyWith(
                color: colorScheme.onSurface,
                fontSize: 17,
              ),
            ),
          ),
          const Spacer(),
          SurfaceIconButton(
            dimension: 35,
            iconSize: 18.5,
            margin: EdgeInsets.zero,
            tooltip: l10n.close,
            onPressed: () => Navigator.of(context).pop(),
            icon: Icons.close,
          ),
        ],
      ),
    );
  }
}
