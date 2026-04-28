import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:locnet_app/features/settings/domain/interactors/settings_interactor.dart';

part 'notifications_settings_state.dart';

/// Notifications subfeature cubit. Uses [SettingsInteractor] for future
/// persistence; currently holds local UI state only.
class NotificationsSettingsCubit extends Cubit<NotificationsSettingsState> {
  NotificationsSettingsCubit({required SettingsInteractor settingsInteractor})
    : _settingsInteractor = settingsInteractor,
      super(
        const NotificationsSettingsLoadedState(
          messageNotifications: true,
          mentionNotifications: true,
          systemNotifications: false,
          soundEnabled: true,
          sendSound: false,
          systemSounds: true,
          soundIndex: 0,
          showPreview: true,
          doNotDisturb: false,
        ),
      ) {
    _load();
  }

  final SettingsInteractor _settingsInteractor;

  static const String _messageNotificationsKey = 'message_notifications';
  static const String _mentionNotificationsKey = 'mention_notifications';
  static const String _systemNotificationsKey = 'system_notifications';
  static const String _soundEnabledKey = 'sound_enabled';
  static const String _sendSoundKey = 'send_sound';
  static const String _systemSoundsKey = 'system_sounds';
  static const String _showPreviewKey = 'show_preview';
  static const String _doNotDisturbKey = 'do_not_disturb';

  Future<void> _load() async {
    final List<dynamic> values = await Future.wait<dynamic>([
      _settingsInteractor.getNotificationSetting(
        key: _messageNotificationsKey,
        fallback: true,
      ),
      _settingsInteractor.getNotificationSetting(
        key: _mentionNotificationsKey,
        fallback: true,
      ),
      _settingsInteractor.getNotificationSetting(
        key: _systemNotificationsKey,
        fallback: false,
      ),
      _settingsInteractor.getNotificationSetting(
        key: _soundEnabledKey,
        fallback: true,
      ),
      _settingsInteractor.getNotificationSetting(
        key: _sendSoundKey,
        fallback: false,
      ),
      _settingsInteractor.getNotificationSetting(
        key: _systemSoundsKey,
        fallback: true,
      ),
      _settingsInteractor.getNotificationSoundIndex(fallback: 0),
      _settingsInteractor.getNotificationSetting(
        key: _showPreviewKey,
        fallback: true,
      ),
      _settingsInteractor.getNotificationSetting(
        key: _doNotDisturbKey,
        fallback: false,
      ),
    ]);
    emit(
      NotificationsSettingsLoadedState(
        messageNotifications: values[0] as bool,
        mentionNotifications: values[1] as bool,
        systemNotifications: values[2] as bool,
        soundEnabled: values[3] as bool,
        sendSound: values[4] as bool,
        systemSounds: values[5] as bool,
        soundIndex: values[6] as int,
        showPreview: values[7] as bool,
        doNotDisturb: values[8] as bool,
      ),
    );
  }

  Future<void> setMessageNotifications({required bool value}) async {
    await _updateBool(
      update: (state) => state.copyWith(messageNotifications: value),
      key: _messageNotificationsKey,
      value: value,
    );
  }

  Future<void> setMentionNotifications({required bool value}) async {
    await _updateBool(
      update: (state) => state.copyWith(mentionNotifications: value),
      key: _mentionNotificationsKey,
      value: value,
    );
  }

  Future<void> setSystemNotifications({required bool value}) async {
    await _updateBool(
      update: (state) => state.copyWith(systemNotifications: value),
      key: _systemNotificationsKey,
      value: value,
    );
  }

  Future<void> setSoundEnabled({required bool value}) async {
    await _updateBool(
      update: (state) => state.copyWith(soundEnabled: value),
      key: _soundEnabledKey,
      value: value,
    );
  }

  Future<void> setSendSound({required bool value}) async {
    await _updateBool(
      update: (state) => state.copyWith(sendSound: value),
      key: _sendSoundKey,
      value: value,
    );
  }

  Future<void> setSystemSounds({required bool value}) async {
    await _updateBool(
      update: (state) => state.copyWith(systemSounds: value),
      key: _systemSoundsKey,
      value: value,
    );
  }

  Future<void> setSoundIndex({required int value}) async {
    final current = state;
    if (current is! NotificationsSettingsLoadedState) {
      return;
    }
    final next = current.copyWith(soundIndex: value);
    emit(next);
    try {
      final bool success = await _settingsInteractor.saveNotificationSoundIndex(
        value: value,
      );
      if (!success) {
        emit(current);
      }
    } catch (_) {
      emit(current);
    }
  }

  Future<void> setShowPreview({required bool value}) async {
    await _updateBool(
      update: (state) => state.copyWith(showPreview: value),
      key: _showPreviewKey,
      value: value,
    );
  }

  Future<void> setDoNotDisturb({required bool value}) async {
    await _updateBool(
      update: (state) => state.copyWith(doNotDisturb: value),
      key: _doNotDisturbKey,
      value: value,
    );
  }

  Future<void> _updateBool({
    required NotificationsSettingsLoadedState Function(
      NotificationsSettingsLoadedState state,
    )
    update,
    required String key,
    required bool value,
  }) async {
    final current = state;
    if (current is! NotificationsSettingsLoadedState) {
      return;
    }
    final next = update(current);
    emit(next);
    try {
      final bool success = await _settingsInteractor.saveNotificationSetting(
        key: key,
        value: value,
      );
      if (!success) {
        emit(current);
      }
    } catch (_) {
      emit(current);
    }
  }
}
