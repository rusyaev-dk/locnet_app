import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/features/settings/presentation/components/components.dart';
import 'package:locnet_app/features/settings/subfeatures/notifications/presentation/blocs/blocs.dart';

/// Notifications & sounds.
class NotificationsSettingsContent extends StatelessWidget {
  const NotificationsSettingsContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationsSettingsCubit, NotificationsSettingsState>(
      builder: (context, state) {
        if (state is! NotificationsSettingsLoadedState) {
          return const SizedBox.shrink();
        }
        return _NotificationsBody(
          messageNotifications: state.messageNotifications,
          mentionNotifications: state.mentionNotifications,
          systemNotifications: state.systemNotifications,
          soundEnabled: state.soundEnabled,
          sendSound: state.sendSound,
          systemSounds: state.systemSounds,
          soundIndex: state.soundIndex,
          doNotDisturb: state.doNotDisturb,
          onMessageNotificationsChanged: (v) => context
              .read<NotificationsSettingsCubit>()
              .setMessageNotifications(value: v),
          onMentionNotificationsChanged: (v) => context
              .read<NotificationsSettingsCubit>()
              .setMentionNotifications(value: v),
          onSystemNotificationsChanged: (v) => context
              .read<NotificationsSettingsCubit>()
              .setSystemNotifications(value: v),
          onSoundEnabledChanged: (v) => context
              .read<NotificationsSettingsCubit>()
              .setSoundEnabled(value: v),
          onSendSoundChanged: (v) =>
              context.read<NotificationsSettingsCubit>().setSendSound(value: v),
          onSystemSoundsChanged: (v) => context
              .read<NotificationsSettingsCubit>()
              .setSystemSounds(value: v),
          onSoundIndexChanged: (i) => context
              .read<NotificationsSettingsCubit>()
              .setSoundIndex(value: i),
          onDoNotDisturbChanged: (v) => context
              .read<NotificationsSettingsCubit>()
              .setDoNotDisturb(value: v),
        );
      },
    );
  }
}

class _NotificationsBody extends StatelessWidget {
  const _NotificationsBody({
    required this.messageNotifications,
    required this.mentionNotifications,
    required this.systemNotifications,
    required this.soundEnabled,
    required this.sendSound,
    required this.systemSounds,
    required this.soundIndex,
    required this.doNotDisturb,
    required this.onMessageNotificationsChanged,
    required this.onMentionNotificationsChanged,
    required this.onSystemNotificationsChanged,
    required this.onSoundEnabledChanged,
    required this.onSendSoundChanged,
    required this.onSystemSoundsChanged,
    required this.onSoundIndexChanged,
    required this.onDoNotDisturbChanged,
  });

  final bool messageNotifications;
  final bool mentionNotifications;
  final bool systemNotifications;
  final bool soundEnabled;
  final bool sendSound;
  final bool systemSounds;
  final int soundIndex;
  final bool doNotDisturb;
  final ValueChanged<bool> onMessageNotificationsChanged;
  final ValueChanged<bool> onMentionNotificationsChanged;
  final ValueChanged<bool> onSystemNotificationsChanged;
  final ValueChanged<bool> onSoundEnabledChanged;
  final ValueChanged<bool> onSendSoundChanged;
  final ValueChanged<bool> onSystemSoundsChanged;
  final ValueChanged<int> onSoundIndexChanged;
  final ValueChanged<bool> onDoNotDisturbChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SettingsGroupCard(
            title: l10n.settingsPushSection,
            children: [
              SettingsSwitchTile(
                title: l10n.settingsAllowPush,
                value: messageNotifications,
                onChanged: onMessageNotificationsChanged,
              ),
              SettingsSwitchTile(
                title: l10n.settingsNotifyMentions,
                value: mentionNotifications,
                enabled: messageNotifications,
                onChanged: onMentionNotificationsChanged,
              ),
              SettingsSwitchTile(
                title: l10n.settingsNotifySystem,
                value: systemNotifications,
                enabled: messageNotifications,
                onChanged: onSystemNotificationsChanged,
              ),
              SettingsSwitchTile(
                title: l10n.settingsDoNotDisturb,
                value: doNotDisturb,
                onChanged: onDoNotDisturbChanged,
              ),
            ],
          ),
          const SizedBox(height: 16),
          SettingsGroupCard(
            title: l10n.settingsSoundsSection,
            children: [
              SettingsSwitchTile(
                title: l10n.settingsSoundNewMessages,
                value: soundEnabled,
                onChanged: onSoundEnabledChanged,
              ),
              SettingsSwitchTile(
                title: l10n.settingsSoundSend,
                value: sendSound,
                enabled: soundEnabled,
                onChanged: onSendSoundChanged,
              ),
              SettingsSwitchTile(
                title: l10n.settingsSoundSystem,
                value: systemSounds,
                enabled: soundEnabled,
                onChanged: onSystemSoundsChanged,
              ),
              SettingsSegmentedTile(
                title: l10n.settingsNotificationSoundTone,
                options: [
                  l10n.settingsSoundDefault,
                  l10n.settingsSoundChime,
                  l10n.settingsSoundPing,
                ],
                selectedIndex: soundIndex.clamp(0, 2),
                onSelected: onSoundIndexChanged,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
