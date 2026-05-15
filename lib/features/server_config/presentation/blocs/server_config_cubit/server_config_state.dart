import 'package:equatable/equatable.dart';
import 'package:locnet_app/features/server_config/domain/domain.dart';

sealed class ServerConfigState extends Equatable {
  const ServerConfigState();

  @override
  List<Object?> get props => [];
}

final class ServerConfigInitialState extends ServerConfigState {
  const ServerConfigInitialState();
}

final class ServerConfigLoadedState extends ServerConfigState {
  const ServerConfigLoadedState({required this.config});

  final ServerConfig config;

  ServerConfigLoadedState copyWith({ServerConfig? config}) =>
      ServerConfigLoadedState(config: config ?? this.config);

  @override
  List<Object?> get props => [config];
}

final class ServerConfigSavingState extends ServerConfigState {
  const ServerConfigSavingState({required this.config});

  final ServerConfig config;

  @override
  List<Object?> get props => [config];
}

final class ServerConfigFailureState extends ServerConfigState {
  const ServerConfigFailureState({required this.failure});

  final Object failure;

  @override
  List<Object?> get props => [failure];
}
