abstract interface class ISettingsCacheDatabaseRepo {
  Future<void> clearAll();

  Future<int> sumCachedImageMediaBytes();

  Future<int> sumCachedVideoMediaBytes();

  Future<int> sumCachedAudioMediaBytes();

  Future<int> sumCachedOtherMimeMediaBytes();

  Future<int> sumPrivateMessagesTextLength();

  Future<int> conversationTilesCount();
}
