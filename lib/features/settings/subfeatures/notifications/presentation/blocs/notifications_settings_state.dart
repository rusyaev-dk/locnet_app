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
    required this.soundEnabled,
  });

  final bool messageNotifications;
  final bool soundEnabled;

  NotificationsSettingsLoadedState copyWith({
    bool? messageNotifications,
    bool? soundEnabled,
  }) {
    return NotificationsSettingsLoadedState(
      messageNotifications:
          messageNotifications ?? this.messageNotifications,
      soundEnabled: soundEnabled ?? this.soundEnabled,
    );
  }

  @override
  List<Object?> get props => [messageNotifications, soundEnabled];
}
