import 'package:flutter/material.dart';
import 'package:locnet_app/app/app.dart';

/// Base layout for conversation headers (private, group, channel).
///
/// Provides:
/// - Left: avatar (38px), name + status (no online dot on avatar).
/// - Right: custom trailing actions + overflow menu.
///
class ConversationProfileHeaderBase extends StatelessWidget {
  const ConversationProfileHeaderBase({
    required this.title,
    required this.avatarOverride,
    required this.onTap,
    this.subtitle,
    this.isOnline,
    this.trailingActions = const <Widget>[],
    this.menuButton,
    super.key,
  });

  final String title;
  final Widget avatarOverride;
  final String? subtitle;
  final bool? isOnline;
  final VoidCallback onTap;

  /// Small icon buttons placed before the menu button.
  final List<Widget> trailingActions;

  /// Typically a [PopupMenuButton] configured by the caller.
  final Widget? menuButton;

  static const Color _onlineColor = Color(0xFF4CAF79);

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    final bool online = isOnline ?? false;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Container(
        height: 64,
        decoration: BoxDecoration(
          color: colorScheme.secondary,
          border: Border(
            bottom: BorderSide(color: colorScheme.outline),
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: onTap,
                child: Row(
                  children: [
                    avatarOverride,
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: colorScheme.onSurface,
                              height: 1.2,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            online
                                ? context.l10n.companionStatusOnline
                                : (subtitle ??
                                    context.l10n.companionStatusOffline),
                            style: TextStyle(
                              fontSize: 12,
                              color: online
                                  ? _onlineColor
                                  : colorScheme.onSurfaceVariant,
                              height: 1.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 8),
            ...trailingActions,
            if (menuButton != null) menuButton!,
          ],
        ),
      ),
    );
  }
}
