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
  const ChatSettingsLoadedState();

  @override
  List<Object?> get props => [];
}

final class ChatSettingsFailureState extends ChatSettingsState {
  const ChatSettingsFailureState();
}
