import 'package:locnet_app/features/settings/subfeatures/storage/data/repositories/settings_cache_database_repo/i_settings_cache_database_repo.dart';
import 'package:locnet_app/features/settings/subfeatures/storage/domain/storage_cache_stats.dart';

final class SettingsCacheDatabaseInteractor {
  SettingsCacheDatabaseInteractor({
    required ISettingsCacheDatabaseRepo settingsCacheDatabaseRepo,
  }) : _settingsCacheDatabaseRepo = settingsCacheDatabaseRepo;

  final ISettingsCacheDatabaseRepo _settingsCacheDatabaseRepo;

  static const int _bytesOverheadPerConversationTile = 512;

  Future<StorageCacheStats> fetchStorageStats() async {
    final results = await Future.wait([
      _settingsCacheDatabaseRepo.sumCachedImageMediaBytes(),
      _settingsCacheDatabaseRepo.sumCachedVideoMediaBytes(),
      _settingsCacheDatabaseRepo.sumCachedAudioMediaBytes(),
      _settingsCacheDatabaseRepo.sumCachedOtherMimeMediaBytes(),
      _settingsCacheDatabaseRepo.sumPrivateMessagesTextLength(),
      _settingsCacheDatabaseRepo.conversationTilesCount(),
    ]);
    final msgBytes = results[4];
    final tileCount = results[5];
    final textBytes = msgBytes + tileCount * _bytesOverheadPerConversationTile;
    return StorageCacheStats(
      photoBytes: results[0],
      videoBytes: results[1],
      audioBytes: results[2],
      otherBytes: results[3],
      textBytes: textBytes,
    );
  }

  Future<void> clearAll() => _settingsCacheDatabaseRepo.clearAll();
}
