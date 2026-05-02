import 'package:flutter/material.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/features/auth/domain/domain.dart';
import 'package:locnet_app/features/settings/presentation/components/components.dart';
import 'package:locnet_app/features/settings/subfeatures/profile/presentation/components/session_info.dart';

/// Session summary and app version.
class PrivacySettingsContent extends StatelessWidget {
  const PrivacySettingsContent({required this.session, super.key});

  final Session? session;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    if (session == null) {
      return Center(
        child: Text(
          l10n.sessionIsNotLoadedYet,
          style: context.textScheme.label.copyWith(
            color: context.colorScheme.onSurfaceVariant,
          ),
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SessionInfo(session: session!),
          const SizedBox(height: 16),
          SettingsGroupCard(
            title: l10n.aboutApp,
            children: const [
              SettingsAppVersionTile(),
            ],
          ),
        ],
      ),
    );
  }
}
