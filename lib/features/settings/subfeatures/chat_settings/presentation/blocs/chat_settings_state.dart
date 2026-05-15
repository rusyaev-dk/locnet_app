part of 'chat_settings_cubit.dart';

sealed class ChatSettingsState extends Equatable {
  const ChatSettingsState();

  @override
  List<Object?> get props => [];
}

final class ChatSettingsInitialState extends ChatSettingsState {
  const ChatSettingsInitialState();
}

final class ChatSettingsLoadingState extends ChatSettingsState {
  const ChatSettingsLoadingState();
}

final class ChatSettingsLoadedState extends ChatSettingsState {
  const ChatSettingsLoadedState({
    required this.autoScroll,
    required this.sendOnEnter,
    required this.shiftEnterNewLine,
    required this.saveDrafts,
  });

  final bool autoScroll;
  final bool sendOnEnter;
  final bool shiftEnterNewLine;
  final bool saveDrafts;

  ChatSettingsLoadedState copyWith({
    bool? autoScroll,
    bool? sendOnEnter,
    bool? shiftEnterNewLine,
    bool? saveDrafts,
  }) {
    return ChatSettingsLoadedState(
      autoScroll: autoScroll ?? this.autoScroll,
      sendOnEnter: sendOnEnter ?? this.sendOnEnter,
      shiftEnterNewLine: shiftEnterNewLine ?? this.shiftEnterNewLine,
      saveDrafts: saveDrafts ?? this.saveDrafts,
    );
  }

  @override
  List<Object?> get props => [
    autoScroll,
    sendOnEnter,
    shiftEnterNewLine,
    saveDrafts,
  ];
}

final class ChatSettingsFailureState extends ChatSettingsState {
  const ChatSettingsFailureState();
}
