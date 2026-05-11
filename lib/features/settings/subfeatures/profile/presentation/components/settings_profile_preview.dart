import 'package:flutter/material.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/core/core.dart';

/// Compact profile preview for the settings sidebar (avatar and optionally name).
class SettingsProfilePreview extends StatelessWidget {
  const SettingsProfilePreview({
    required this.user,
    required this.compact,
    super.key,
  });

  final User user;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textScheme = context.textScheme;
    final fullName = ProfileDataExtractor.extractUserFullName(user);
    final displayName = fullName.isNotEmpty ? fullName : user.username;
    final username = user.username.isNotEmpty ? '@${user.username}' : '';

    if (compact) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 12),
        child: Center(child: Avatar.user(user: user, size: 40)),
      );
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 16),
      child: Row(
        children: [
          Avatar.user(user: user, size: 40),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  displayName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textScheme.label.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (username.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    username,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textScheme.label.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      fontSize: 12,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
