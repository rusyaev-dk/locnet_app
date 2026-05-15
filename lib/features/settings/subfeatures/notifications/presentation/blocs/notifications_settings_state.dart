part of 'notifications_settings_cubit.dart';

sealed class NotificationsSettingsState extends Equatable {
  const NotificationsSettingsState();

  @override
  List<Object?> get props => [];
}

final class NotificationsSettingsLoadedState
    extends NotificationsSettingsState {
  const NotificationsSettingsLoadedState({
    required this.messageNotifications,
    required this.mentionNotifications,
    required this.systemNotifications,
    required this.soundEnabled,
    required this.sendSound,
    required this.systemSounds,
    required this.soundIndex,
    required this.showPreview,
    required this.doNotDisturb,
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

  NotificationsSettingsLoadedState copyWith({
    bool? messageNotifications,
    bool? mentionNotifications,
    bool? systemNotifications,
    bool? soundEnabled,
    bool? sendSound,
    bool? systemSounds,
    int? soundIndex,
    bool? showPreview,
    bool? doNotDisturb,
  }) {
    return NotificationsSettingsLoadedState(
      messageNotifications: messageNotifications ?? this.messageNotifications,
      mentionNotifications: mentionNotifications ?? this.mentionNotifications,
      systemNotifications: systemNotifications ?? this.systemNotifications,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      sendSound: sendSound ?? this.sendSound,
      systemSounds: systemSounds ?? this.systemSounds,
      soundIndex: soundIndex ?? this.soundIndex,
      showPreview: showPreview ?? this.showPreview,
      doNotDisturb: doNotDisturb ?? this.doNotDisturb,
    );
  }

  @override
  List<Object?> get props => [
    messageNotifications,
    mentionNotifications,
    systemNotifications,
    soundEnabled,
    sendSound,
    systemSounds,
    soundIndex,
    showPreview,
    doNotDisturb,
  ];
}
