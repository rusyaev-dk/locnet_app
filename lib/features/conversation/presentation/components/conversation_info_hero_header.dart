import 'package:flutter/material.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/uikit/uikit.dart';

/// Shared centered hero header for group and channel info modals.
/// Displays a large avatar, title, optional subtitle (description), and a
/// close button anchored to the top-right corner.
class ConversationInfoHeroHeader extends StatelessWidget {
  const ConversationInfoHeroHeader({
    required this.title,
    required this.avatar,
    this.subtitle,
    super.key,
  });

  final String title;
  final Widget avatar;

  /// Shown below the title in a muted style. Pass description text or a
  /// type indicator like "Group · 42 members".
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textScheme = context.textScheme;
    final hasSubtitle =
        subtitle != null && subtitle!.trim().isNotEmpty;

    return Stack(
      children: [
        Center(
          child: Column(
            children: [
              const SizedBox(height: 6),
              avatar,
              const SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                style: textScheme.headline.copyWith(
                  color: colorScheme.onSurface,
                  fontSize: 18,
                ),
              ),
              if (hasSubtitle) ...[
                const SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    subtitle!.trim(),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: textScheme.label.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      fontSize: 13,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 12),
            ],
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: SurfaceIconButton(
            icon: Icons.close,
            dimension: 32,
            iconSize: 14,
            margin: EdgeInsets.zero,
            foregroundColor: colorScheme.onSurfaceVariant,
            tooltip: context.l10n.close,
            onPressed: () => Navigator.of(context).maybePop(),
          ),
        ),
      ],
    );
  }
}
