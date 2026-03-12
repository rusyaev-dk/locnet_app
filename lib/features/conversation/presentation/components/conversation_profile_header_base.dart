import 'package:flutter/material.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/features/conversation/presentation/presentation.dart';

/// Base layout for conversation headers (private, group, channel).
///
/// Provides:
/// - Left: avatar.
/// - Center: title + optional subtitle.
/// - Right: custom trailing actions + overflow menu.
class ConversationProfileHeaderBase extends StatelessWidget {
  const ConversationProfileHeaderBase({
    required this.title,
    required this.avatarText,
    required this.onTap,
    this.subtitle,
    this.trailingActions = const <Widget>[],
    this.menuButton,
    super.key,
  });

  final String title;
  final String avatarText;
  final String? subtitle;
  final VoidCallback onTap;

  /// Small icon buttons (e.g. search, media) placed before the menu button.
  final List<Widget> trailingActions;

  /// Typically a [PopupMenuButton] configured by the caller.
  final Widget? menuButton;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textScheme = context.textScheme;

    final bool hasSubtitle = subtitle != null && subtitle!.trim().isNotEmpty;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Material(
        color: colorScheme.surfaceBright,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                ConversationAvatar(
                  text: avatarText,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: textScheme.headline.copyWith(fontSize: 15),
                      ),
                      if (hasSubtitle) ...[
                        const SizedBox(height: 2),
                        Text(
                          subtitle!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: textScheme.label,
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                ...trailingActions,
                if (menuButton != null) menuButton!,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

