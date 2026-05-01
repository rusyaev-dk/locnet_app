import 'package:flutter/material.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/features/conversation/presentation/presentation.dart';

/// Base layout for conversation headers (private, group, channel).
///
/// Provides:
/// - Left: avatar (38px) with online dot + name + status.
/// - Right: custom trailing actions + overflow menu.
class ConversationProfileHeaderBase extends StatelessWidget {
  const ConversationProfileHeaderBase({
    required this.title,
    required this.avatarText,
    required this.onTap,
    this.subtitle,
    this.isOnline,
    this.trailingActions = const <Widget>[],
    this.menuButton,
    super.key,
  });

  final String title;
  final String avatarText;
  final String? subtitle;
  final bool? isOnline;
  final VoidCallback onTap;

  /// Small icon buttons (e.g. phone, video, info) placed before the menu button.
  final List<Widget> trailingActions;

  /// Typically a [PopupMenuButton] configured by the caller.
  final Widget? menuButton;

  static const Color _onlineColor = Color(0xFF4CAF79);

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    final bool online = isOnline ?? false;

    return Container(
      height: 64,
      decoration: BoxDecoration(
        color: colorScheme.secondary,
        border: Border(
          bottom: BorderSide(color: colorScheme.outline, width: 1),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          GestureDetector(
            onTap: onTap,
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: ConversationAvatar(
                text: avatarText,
                size: 38,
                isOnline: isOnline,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: GestureDetector(
              onTap: onTap,
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
                  Row(
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        margin: const EdgeInsets.only(right: 4),
                        decoration: BoxDecoration(
                          color: online
                              ? _onlineColor
                              : colorScheme.onSurfaceVariant,
                          shape: BoxShape.circle,
                        ),
                      ),
                      Text(
                        online
                            ? context.l10n.companionStatusOnline
                            : (subtitle ?? context.l10n.companionStatusOffline),
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
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          ...trailingActions,
          if (menuButton != null) menuButton!,
        ],
      ),
    );
  }
}

/// A styled header action button (34×34, secondary bg, outline border, radius 8).
class HeaderActionButton extends StatelessWidget {
  const HeaderActionButton({
    required this.icon,
    required this.onPressed,
    super.key,
  });

  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 34,
        height: 34,
        margin: const EdgeInsets.only(left: 6),
        decoration: BoxDecoration(
          color: colorScheme.secondary,
          border: Border.all(color: colorScheme.outline, width: 1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 16, color: colorScheme.onSurfaceVariant),
      ),
    );
  }
}
