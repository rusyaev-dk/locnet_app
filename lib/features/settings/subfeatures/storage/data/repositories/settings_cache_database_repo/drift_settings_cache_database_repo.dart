import 'package:locnet_app/core/data/storage/db/db.dart';
import 'package:locnet_app/features/settings/subfeatures/storage/data/repositories/settings_cache_database_repo/i_settings_cache_database_repo.dart';

final class DriftSettingsCacheDatabaseRepo implements ISettingsCacheDatabaseRepo {
  DriftSettingsCacheDatabaseRepo({required AppDatabase db}) : _db = db;

  final AppDatabase _db;

  @override
  Future<void> clearAll() => _db.clearAll();

  @override
  Future<int> sumCachedImageMediaBytes() =>
      _sumMediaBytes("mime_type LIKE 'image/%'");

  @override
  Future<int> sumCachedVideoMediaBytes() =>
      _sumMediaBytes("mime_type LIKE 'video/%'");

  @override
  Future<int> sumCachedAudioMediaBytes() =>
      _sumMediaBytes("mime_type LIKE 'audio/%'");

  @override
  Future<int> sumCachedOtherMimeMediaBytes() => _sumMediaBytes(
        "mime_type NOT LIKE 'image/%' AND mime_type NOT LIKE 'video/%' "
        "AND mime_type NOT LIKE 'audio/%'",
      );

  @override
  Future<int> sumPrivateMessagesTextLength() async {
    final result = await _db
        .customSelect(
          'SELECT COALESCE(SUM(LENGTH("text")), 0) AS s '
          'FROM private_messages WHERE is_deleted = 0',
        )
        .getSingle();
    return result.read<int>('s');
  }

  @override
  Future<int> conversationTilesCount() async {
    final result = await _db
        .customSelect('SELECT COUNT(*) AS c FROM conversation_tiles')
        .getSingle();
    return result.read<int>('c');
  }

  Future<int> _sumMediaBytes(String whereClause) async {
    final result = await _db
        .customSelect(
          'SELECT COALESCE(SUM(size_bytes), 0) AS s '
          'FROM media_download_cache WHERE $whereClause',
        )
        .getSingle();
    return result.read<int>('s');
  }
}
