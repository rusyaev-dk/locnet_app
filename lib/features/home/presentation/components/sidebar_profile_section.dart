import 'package:flutter/material.dart';
import 'package:locnet_app/app/app.dart';

class SidebarProfileSection extends StatelessWidget {
  const SidebarProfileSection({
    required this.isCollapsed,
    required this.horizontalPadding,
    super.key,
  });

  final bool isCollapsed;
  final double horizontalPadding;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textScheme = context.textScheme;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 8),
      child: Row(
        mainAxisAlignment: isCollapsed
            ? MainAxisAlignment.center
            : MainAxisAlignment.start,
        children: [
          Container(
            width: isCollapsed ? 28 : 36,
            height: isCollapsed ? 28 : 36,
            decoration: BoxDecoration(
              color: colorScheme.primary.withAlpha(24),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.person_outline,
              size: isCollapsed ? 16 : 20,
              color: colorScheme.primary,
            ),
          ),
          if (!isCollapsed) ...[
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'User name',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textScheme.label.copyWith(
                      color: colorScheme.onSecondaryContainer,
                    ),
                  ),
                  Text(
                    'View profile',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textScheme.label.copyWith(
                      fontSize: 12,
                      color: colorScheme.onSecondaryContainer.withAlpha(160),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.chevron_right,
              size: 18,
              color: colorScheme.onSecondaryContainer.withAlpha(160),
            ),
          ],
        ],
      ),
    );
  }
}
