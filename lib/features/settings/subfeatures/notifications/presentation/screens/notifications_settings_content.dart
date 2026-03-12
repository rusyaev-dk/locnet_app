import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/features/settings/presentation/components/components.dart';
import 'package:locnet_app/features/settings/subfeatures/notifications/presentation/blocs/blocs.dart';

/// Notifications & sounds section.
class NotificationsSettingsContent extends StatefulWidget {
  const NotificationsSettingsContent({super.key});

  @override
  State<NotificationsSettingsContent> createState() =>
      _NotificationsSettingsContentState();
}

class _NotificationsSettingsContentState
    extends State<NotificationsSettingsContent> {
  bool _mentionNotifications = true;
  bool _systemNotifications = false;
  bool _sendSound = false;
  bool _systemSounds = true;
  int _soundIndex = 0;
  bool _showPreview = true;
  bool _doNotDisturb = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationsSettingsCubit, NotificationsSettingsState>(
      builder: (context, state) {
        if (state is! NotificationsSettingsLoadedState) {
          return const SizedBox.shrink();
        }
        return _NotificationsBody(
          messageNotifications: state.messageNotifications,
          mentionNotifications: _mentionNotifications,
          systemNotifications: _systemNotifications,
          soundEnabled: state.soundEnabled,
          sendSound: _sendSound,
          systemSounds: _systemSounds,
          soundIndex: _soundIndex,
          showPreview: _showPreview,
          doNotDisturb: _doNotDisturb,
          onMessageNotificationsChanged: (v) => context
              .read<NotificationsSettingsCubit>()
              .setMessageNotifications(value: v),
          onMentionNotificationsChanged: (v) =>
              setState(() => _mentionNotifications = v),
          onSystemNotificationsChanged: (v) =>
              setState(() => _systemNotifications = v),
          onSoundEnabledChanged: (v) =>
              context.read<NotificationsSettingsCubit>().setSoundEnabled(value: v),
          onSendSoundChanged: (v) => setState(() => _sendSound = v),
          onSystemSoundsChanged: (v) => setState(() => _systemSounds = v),
          onSoundIndexChanged: (i) => setState(() => _soundIndex = i),
          onShowPreviewChanged: (v) => setState(() => _showPreview = v),
          onDoNotDisturbChanged: (v) => setState(() => _doNotDisturb = v),
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
    required this.showPreview,
    required this.doNotDisturb,
    required this.onMessageNotificationsChanged,
    required this.onMentionNotificationsChanged,
    required this.onSystemNotificationsChanged,
    required this.onSoundEnabledChanged,
    required this.onSendSoundChanged,
    required this.onSystemSoundsChanged,
    required this.onSoundIndexChanged,
    required this.onShowPreviewChanged,
    required this.onDoNotDisturbChanged,
  });

  final bool messageNotifications;
  final bool mentionNotifications;
  final bool systemNotifications;
  final bool soundEnabled;
  final bool sendSound;
  final bool systemSounds;
  final int soundIndex;
  final bool showPreview;
  final bool doNotDisturb;
  final ValueChanged<bool> onMessageNotificationsChanged;
  final ValueChanged<bool> onMentionNotificationsChanged;
  final ValueChanged<bool> onSystemNotificationsChanged;
  final ValueChanged<bool> onSoundEnabledChanged;
  final ValueChanged<bool> onSendSoundChanged;
  final ValueChanged<bool> onSystemSoundsChanged;
  final ValueChanged<int> onSoundIndexChanged;
  final ValueChanged<bool> onShowPreviewChanged;
  final ValueChanged<bool> onDoNotDisturbChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SettingsSectionHeader(
            title: l10n.settingsNotificationsAndSounds,
            description: 'Управляйте тем, когда и как вы получаете уведомления.',
          ),

          // ── Push-уведомления ──────────────────────────────
          SettingsGroupCard(
            title: 'Push-уведомления',
            children: [
              SettingsSwitchTile(
                title: 'Разрешить push-уведомления',
                value: messageNotifications,
                onChanged: onMessageNotificationsChanged,
              ),
              SettingsSwitchTile(
                title: 'Уведомления о новых сообщениях',
                value: messageNotifications && messageNotifications,
                enabled: messageNotifications,
                onChanged: (_) {},
              ),
              SettingsSwitchTile(
                title: 'Уведомления об упоминаниях',
                value: mentionNotifications,
                enabled: messageNotifications,
                onChanged: onMentionNotificationsChanged,
              ),
              SettingsSwitchTile(
                title: 'Системные уведомления',
                value: systemNotifications,
                enabled: messageNotifications,
                onChanged: onSystemNotificationsChanged,
              ),
            ],
          ),
          const SizedBox(height: 20),

          // ── Звуки ────────────────────────────────────────
          SettingsGroupCard(
            title: 'Звуки',
            children: [
              SettingsSwitchTile(
                title: 'Звук новых сообщений',
                value: soundEnabled,
                onChanged: onSoundEnabledChanged,
              ),
              SettingsSwitchTile(
                title: 'Звук отправки сообщения',
                value: sendSound,
                enabled: soundEnabled,
                onChanged: onSendSoundChanged,
              ),
              SettingsSwitchTile(
                title: 'Системные звуки',
                value: systemSounds,
                enabled: soundEnabled,
                onChanged: onSystemSoundsChanged,
              ),
              SettingsSegmentedTile(
                title: 'Звук уведомлений',
                options: ['Default', 'Chime', 'Ping'],
                selectedIndex: soundIndex,
                onSelected: onSoundIndexChanged,
              ),
            ],
          ),
          const SizedBox(height: 20),

          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
