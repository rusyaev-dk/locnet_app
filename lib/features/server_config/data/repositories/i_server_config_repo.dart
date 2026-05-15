import 'package:locnet_app/features/server_config/domain/domain.dart';

abstract interface class IServerConfigRepo {
  Future<ServerConfig> getConfig();

  Future<void> saveConfig(ServerConfig config);

  Future<void> resetToDefaults();
}
