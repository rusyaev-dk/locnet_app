import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:locnet_app/features/settings/domain/interactors/settings_interactor.dart';

part 'notifications_settings_state.dart';

/// Notifications subfeature cubit. Uses [SettingsInteractor] for future
/// persistence; currently holds local UI state only.
class NotificationsSettingsCubit extends Cubit<NotificationsSettingsState> {
  NotificationsSettingsCubit({
    required SettingsInteractor settingsInteractor,
  })  : _settingsInteractor = settingsInteractor,
        super(const NotificationsSettingsLoadedState(
          messageNotifications: true,
          soundEnabled: true,
        ));

  /// Reserved for future persistence of notification preferences.
  // ignore: unused_field
  final SettingsInteractor _settingsInteractor;

  void setMessageNotifications({required bool value}) {
    final current = state;
    if (current is NotificationsSettingsLoadedState) {
      emit(current.copyWith(messageNotifications: value));
    }
  }

  void setSoundEnabled({required bool value}) {
    final current = state;
    if (current is NotificationsSettingsLoadedState) {
      emit(current.copyWith(soundEnabled: value));
    }
  }
}
