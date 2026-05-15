import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locnet_app/core/utils/logger/i_logger.dart';
import 'package:locnet_app/features/server_config/data/repositories/i_server_config_repo.dart';
import 'package:locnet_app/features/server_config/domain/domain.dart';
import 'package:locnet_app/features/server_config/presentation/blocs/server_config_cubit/server_config_state.dart';

final class ServerConfigCubit extends Cubit<ServerConfigState> {
  ServerConfigCubit({
    required IServerConfigRepo repo,
    required ILogger logger,
  })  : _repo = repo,
        _logger = logger,
        super(const ServerConfigInitialState());

  final IServerConfigRepo _repo;
  final ILogger _logger;

  Future<void> load() async {
    try {
      final config = await _repo.getConfig();
      emit(ServerConfigLoadedState(config: config));
    } catch (e, st) {
      _logger.exception(e, st);
      emit(ServerConfigFailureState(failure: e));
    }
  }

  Future<void> save({
    required String baseUrl,
    required String socketBaseUrl,
  }) async {
    final current = state;
    if (current is! ServerConfigLoadedState) return;

    final newConfig = ServerConfig(
      baseUrl: baseUrl.trim(),
      socketBaseUrl: socketBaseUrl.trim(),
    );

    emit(ServerConfigSavingState(config: newConfig));
    try {
      await _repo.saveConfig(newConfig);
      emit(ServerConfigLoadedState(config: newConfig));
    } catch (e, st) {
      _logger.exception(e, st);
      emit(ServerConfigFailureState(failure: e));
    }
  }

  Future<void> resetToDefaults() async {
    try {
      await _repo.resetToDefaults();
      await load();
    } catch (e, st) {
      _logger.exception(e, st);
      emit(ServerConfigFailureState(failure: e));
    }
  }
}
