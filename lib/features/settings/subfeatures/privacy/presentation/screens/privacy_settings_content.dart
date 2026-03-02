import 'package:flutter/material.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/auth/domain/domain.dart';
import 'package:locnet_app/features/profile/presentation/modals/modals.dart';
import 'package:locnet_app/features/profile/presentation/components/session_info.dart';
import 'package:locnet_app/features/settings/presentation/components/components.dart';

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

          // ── Данные ────────────────────────────────────────
          SettingsGroupCard(
            title: 'Данные',
            children: [
              SettingsSwitchTile(
                title: 'Разрешить сбор аналитики',
                subtitle: 'Анонимная статистика для улучшения сервиса',
                value: analytics,
                onChanged: onAnalyticsChanged,
              ),
              SettingsSwitchTile(
                title: 'Персонализация ответов',
                value: personalization,
                onChanged: onPersonalizationChanged,
              ),
              SettingsSwitchTile(
                title: 'Использовать данные для улучшения сервиса',
                value: dataImprovement,
                onChanged: onDataImprovementChanged,
              ),
              SettingsActionTile(
                title: 'Запросить копию данных',
                leadingIcon: Icons.download_outlined,
                onTap: () {},
              ),
            ],
          ),
          const SizedBox(height: 20),

          // ── Безопасность ─────────────────────────────────
          SettingsGroupCard(
            title: 'Безопасность',
            children: [
              SettingsSwitchTile(
                title: 'Двухфакторная аутентификация',
                subtitle: 'Дополнительный уровень защиты аккаунта',
                value: twoFactor,
                onChanged: onTwoFactorChanged,
              ),
              SettingsNavTile(
                title: 'Управление активными сессиями',
                onTap: () {
                  showGeneralDialog(
                    context: context,
                    barrierColor: Colors.transparent,
                    transitionBuilder: slideFadeDialogTransition,
                    pageBuilder: (dialogContext, _, __) {
                      return SessionModalCard(session: session);
                    },
                  );
                },
              ),
              SettingsActionTile(
                title: 'Выйти со всех устройств',
                leadingIcon: Icons.logout,
                destructive: true,
                onTap: () {},
              ),
              SettingsSwitchTile(
                title: 'Блокировка приложения',
                subtitle: 'Запрашивать биометрию при открытии',
                value: appLock,
                onChanged: onAppLockChanged,
              ),
            ],
          ),
          const SizedBox(height: 8),
          const SettingsInfoCard(
            message:
                'Выход со всех устройств завершит все активные сессии и потребует повторного входа.',
            icon: Icons.warning_amber_outlined,
            variant: SettingsInfoCardVariant.warning,
          ),
          const SizedBox(height: 20),

          // ── Контент ───────────────────────────────────────
          SettingsGroupCard(
            title: 'Контент',
            children: [
              SettingsSwitchTile(
                title: 'Фильтр чувствительного контента',
                value: sensitiveFilter,
                onChanged: onSensitiveFilterChanged,
              ),
              SettingsSwitchTile(
                title: 'Скрывать предпросмотр уведомлений',
                value: hideNotificationPreview,
                onChanged: onHideNotificationPreviewChanged,
              ),
              SettingsSegmentedTile(
                title: 'Уровень модерации',
                options: const ['Мягкий', 'Стандарт', 'Строгий'],
                selectedIndex: moderationLevel,
                onSelected: onModerationLevelChanged,
              ),
            ],
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
