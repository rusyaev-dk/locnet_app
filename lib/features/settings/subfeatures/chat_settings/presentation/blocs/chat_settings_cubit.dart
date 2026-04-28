import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:locnet_app/features/settings/domain/interactors/settings_interactor.dart';

part 'chat_settings_state.dart';

/// Chat settings subfeature. Theme mode moved to theme subfeature;
/// this cubit only handles chat-specific content (e.g. shortcuts).
class ChatSettingsCubit extends Cubit<ChatSettingsState> {
  ChatSettingsCubit({required SettingsInteractor settingsInteractor})
    : _settingsInteractor = settingsInteractor,
      super(const ChatSettingsInitialState());

  final SettingsInteractor _settingsInteractor;

  static const String _autoScrollKey = 'auto_scroll';
  static const String _sendOnEnterKey = 'send_on_enter';
  static const String _shiftEnterNewLineKey = 'shift_enter_new_line';
  static const String _saveDraftsKey = 'save_drafts';

  Future<void> load() async {
    emit(const ChatSettingsLoadingState());
    try {
      final List<dynamic> values = await Future.wait<dynamic>([
        _settingsInteractor.getChatSetting(key: _autoScrollKey, fallback: true),
        _settingsInteractor.getChatSetting(
          key: _sendOnEnterKey,
          fallback: true,
        ),
        _settingsInteractor.getChatSetting(
          key: _shiftEnterNewLineKey,
          fallback: true,
        ),
        _settingsInteractor.getChatSetting(key: _saveDraftsKey, fallback: true),
      ]);
      emit(
        ChatSettingsLoadedState(
          autoScroll: values[0] as bool,
          sendOnEnter: values[1] as bool,
          shiftEnterNewLine: values[2] as bool,
          saveDrafts: values[3] as bool,
        ),
      );
    } catch (_) {
      emit(const ChatSettingsFailureState());
    }
  }

  Future<void> setAutoScroll({required bool value}) async {
    await _updateSetting(
      update: (state) => state.copyWith(autoScroll: value),
      persist: () => _settingsInteractor.saveChatSetting(
        key: _autoScrollKey,
        value: value,
      ),
    );
  }

  Future<void> setSendOnEnter({required bool value}) async {
    await _updateSetting(
      update: (state) => state.copyWith(sendOnEnter: value),
      persist: () => _settingsInteractor.saveChatSetting(
        key: _sendOnEnterKey,
        value: value,
      ),
    );
  }

  Future<void> setShiftEnterNewLine({required bool value}) async {
    await _updateSetting(
      update: (state) => state.copyWith(shiftEnterNewLine: value),
      persist: () => _settingsInteractor.saveChatSetting(
        key: _shiftEnterNewLineKey,
        value: value,
      ),
    );
  }

  Future<void> setSaveDrafts({required bool value}) async {
    await _updateSetting(
      update: (state) => state.copyWith(saveDrafts: value),
      persist: () => _settingsInteractor.saveChatSetting(
        key: _saveDraftsKey,
        value: value,
      ),
    );
  }

  Future<void> _updateSetting({
    required ChatSettingsLoadedState Function(ChatSettingsLoadedState state)
    update,
    required Future<bool> Function() persist,
  }) async {
    final ChatSettingsState current = state;
    if (current is! ChatSettingsLoadedState) {
      return;
    }
    final ChatSettingsLoadedState next = update(current);
    emit(next);
    try {
      final bool success = await persist();
      if (!success) {
        emit(current);
      }
    } catch (_) {
      emit(current);
    }
  }
}
