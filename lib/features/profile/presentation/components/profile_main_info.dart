import 'package:flutter/material.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/core/core.dart';

class ProfileMainInfo extends StatelessWidget {
  const ProfileMainInfo({required this.user, super.key});

  final User user;

  String get _initials {
    final String trimmedFirstName = user.firstName.trim();
    final String trimmedLastName = user.lastName.trim();

    if (trimmedFirstName.isEmpty && trimmedLastName.isEmpty) {
      return '?';
    }

    if (trimmedLastName.isEmpty) {
      return trimmedFirstName[0].toUpperCase();
    }

    return '${trimmedFirstName[0].toUpperCase()}${trimmedLastName[0].toUpperCase()}';
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textScheme = context.textScheme;

    return Center(
      child: Column(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: colorScheme.primaryContainer,
            child: Text(
              _initials,
              style: textScheme.headline.copyWith(
                color: colorScheme.onPrimaryContainer,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            user.fullName,
            textAlign: TextAlign.center,
            style: textScheme.display.copyWith(
              color: colorScheme.onSurface,
              fontSize: 22,
            ),
          ),
          if (user.username.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              '@${user.username}',
              textAlign: TextAlign.center,
              style: textScheme.label.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
          if (user.description?.isNotEmpty == true) ...[
            const SizedBox(height: 8),
            Text(
              user.description!,
              textAlign: TextAlign.center,
              style: textScheme.label.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
