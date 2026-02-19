import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:locnet_app/features/settings/domain/interactors/settings_interactor.dart';

part 'chat_settings_state.dart';

/// Chat settings subfeature. Theme mode moved to theme subfeature;
/// this cubit only handles chat-specific content (e.g. shortcuts).
class ChatSettingsCubit extends Cubit<ChatSettingsState> {
  ChatSettingsCubit({
    required SettingsInteractor settingsInteractor,
  })  : _settingsInteractor = settingsInteractor,
        super(const ChatSettingsInitialState());

  /// Reserved for future chat-specific settings persistence.
  // ignore: unused_field
  final SettingsInteractor _settingsInteractor;

  Future<void> load() async {
    emit(const ChatSettingsLoadingState());
    try {
      emit(const ChatSettingsLoadedState());
    } catch (_) {
      emit(const ChatSettingsFailureState());
    }
  }
}
