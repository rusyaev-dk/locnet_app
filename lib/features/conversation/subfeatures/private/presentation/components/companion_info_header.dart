import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/conversation/presentation/presentation.dart';
import 'package:locnet_app/uikit/buttons/buttons.dart';

class CompanionInfoHeader extends StatelessWidget {
  const CompanionInfoHeader({required this.companion, super.key});

  final User companion;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textScheme = context.textScheme;
    final l10n = context.l10n;

    final bool isActive = companion.isActive;

    return Stack(
      children: [
        Center(
          child: Column(
            children: [
              const SizedBox(height: 6),
              ConversationAvatar(
                text: ProfileDataExtractor.extractUserInitials(companion),
                size: 85,
              ),
              const SizedBox(height: 10),
              Text(
                companion.fullName,
                textAlign: TextAlign.center,
                style: textScheme.headline.copyWith(
                  color: colorScheme.onSurface,
                  fontSize: 17,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                isActive
                    ? l10n.companionStatusOnline
                    : l10n.companionStatusOffline,
                style: textScheme.label.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: RoundedIconButton(
            icon: Icons.close,
            foregroundColor: colorScheme.onSurfaceVariant,
            onPressed: () => GoRouter.of(context).pop(),
            tooltip: l10n.close,
          ),
        ),
      ],
    );
  }
}
