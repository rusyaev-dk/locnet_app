import 'package:flutter/material.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/features/auth/domain/domain.dart';
import 'package:locnet_app/features/settings/presentation/components/components.dart';
import 'package:locnet_app/features/settings/subfeatures/language/presentation/components/components.dart';
import 'package:locnet_app/features/settings/subfeatures/profile/presentation/components/session_info.dart';

/// Privacy & security section.
class PrivacySettingsContent extends StatefulWidget {
  const PrivacySettingsContent({required this.session, super.key});

  final Session? session;

  @override
  State<PrivacySettingsContent> createState() => _PrivacySettingsContentState();
}

class _PrivacySettingsContentState extends State<PrivacySettingsContent> {
  bool _analytics = false;
  bool _personalization = false;
  bool _dataImprovement = false;
  bool _twoFactor = false;
  bool _appLock = false;
  bool _sensitiveFilter = true;
  bool _hideNotificationPreview = false;
  int _moderationLevel = 1;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    if (widget.session == null) {
      return Center(
        child: Text(
          l10n.sessionIsNotLoadedYet,
          style: context.textScheme.label.copyWith(
            color: context.colorScheme.onSurfaceVariant,
          ),
        ),
      );
    }

    return _PrivacyBody(
      session: widget.session!,
      analytics: _analytics,
      personalization: _personalization,
      dataImprovement: _dataImprovement,
      twoFactor: _twoFactor,
      appLock: _appLock,
      sensitiveFilter: _sensitiveFilter,
      hideNotificationPreview: _hideNotificationPreview,
      moderationLevel: _moderationLevel,
      onAnalyticsChanged: (v) => setState(() => _analytics = v),
      onPersonalizationChanged: (v) => setState(() => _personalization = v),
      onDataImprovementChanged: (v) => setState(() => _dataImprovement = v),
      onTwoFactorChanged: (v) => setState(() => _twoFactor = v),
      onAppLockChanged: (v) => setState(() => _appLock = v),
      onSensitiveFilterChanged: (v) => setState(() => _sensitiveFilter = v),
      onHideNotificationPreviewChanged: (v) =>
          setState(() => _hideNotificationPreview = v),
      onModerationLevelChanged: (i) => setState(() => _moderationLevel = i),
    );
  }
}

class _PrivacyBody extends StatelessWidget {
  const _PrivacyBody({
    required this.session,
    required this.analytics,
    required this.personalization,
    required this.dataImprovement,
    required this.twoFactor,
    required this.appLock,
    required this.sensitiveFilter,
    required this.hideNotificationPreview,
    required this.moderationLevel,
    required this.onAnalyticsChanged,
    required this.onPersonalizationChanged,
    required this.onDataImprovementChanged,
    required this.onTwoFactorChanged,
    required this.onAppLockChanged,
    required this.onSensitiveFilterChanged,
    required this.onHideNotificationPreviewChanged,
    required this.onModerationLevelChanged,
  });

  final Session session;
  final bool analytics;
  final bool personalization;
  final bool dataImprovement;
  final bool twoFactor;
  final bool appLock;
  final bool sensitiveFilter;
  final bool hideNotificationPreview;
  final int moderationLevel;
  final ValueChanged<bool> onAnalyticsChanged;
  final ValueChanged<bool> onPersonalizationChanged;
  final ValueChanged<bool> onDataImprovementChanged;
  final ValueChanged<bool> onTwoFactorChanged;
  final ValueChanged<bool> onAppLockChanged;
  final ValueChanged<bool> onSensitiveFilterChanged;
  final ValueChanged<bool> onHideNotificationPreviewChanged;
  final ValueChanged<int> onModerationLevelChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SettingsSectionHeader(
            title: l10n.settingsPrivacy,
            description:
                'Управляйте данными, безопасностью и уровнем модерации.',
          ),

          // ── Текущая сессия ─────────────────────────────────
          SettingsGroupCard(
            title: 'Текущая сессия',
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                child: SessionInfo(session: session),
              ),
            ],
          ),
          const SizedBox(height: 20),

          const SizedBox(height: 20),

          // ── О приложении ──────────────────────────────────
          const SettingsGroupCard(
            title: 'О приложении',
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: AppVersionWidget(),
              ),
            ],
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
