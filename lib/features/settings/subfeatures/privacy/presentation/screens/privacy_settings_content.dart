import 'package:flutter/material.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/features/auth/domain/domain.dart';
import 'package:locnet_app/features/settings/presentation/components/components.dart';
import 'package:locnet_app/features/settings/subfeatures/language/presentation/components/app_version_widget.dart';
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
          SettingsGroupCard(
            title: l10n.currentSession,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                child: SessionInfo(session: session!),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SettingsGroupCard(
            title: l10n.aboutApp,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: AppVersionWidget(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
