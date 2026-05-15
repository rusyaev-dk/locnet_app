import 'package:locnet_app/core/data/storage/key_value_storage/i_key_value_storage.dart';
import 'package:locnet_app/features/server_config/data/repositories/i_server_config_repo.dart';
import 'package:locnet_app/features/server_config/domain/domain.dart';

abstract final class _Keys {
  static const baseUrl = 'server_config_base_url';
  static const socketBaseUrl = 'server_config_socket_base_url';
}

final class LocalServerConfigRepo implements IServerConfigRepo {
  const LocalServerConfigRepo({
    required IKeyValueStorage storage,
    required ServerConfig defaults,
  })  : _storage = storage,
        _defaults = defaults;

  final IKeyValueStorage _storage;
  final ServerConfig _defaults;

  @override
  Future<ServerConfig> getConfig() async {
    final baseUrl =
        await _storage.read<String>(key: _Keys.baseUrl) ?? _defaults.baseUrl;
    final socketBaseUrl = await _storage.read<String>(
          key: _Keys.socketBaseUrl,
        ) ??
        _defaults.socketBaseUrl;

    return ServerConfig(baseUrl: baseUrl, socketBaseUrl: socketBaseUrl);
  }

  @override
  Future<void> saveConfig(ServerConfig config) async {
    await _storage.write<String>(key: _Keys.baseUrl, value: config.baseUrl);
    await _storage.write<String>(
      key: _Keys.socketBaseUrl,
      value: config.socketBaseUrl,
    );
  }

  @override
  Future<void> resetToDefaults() async {
    await _storage.delete(key: _Keys.baseUrl);
    await _storage.delete(key: _Keys.socketBaseUrl);
  }
}
