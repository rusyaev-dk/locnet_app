import 'dart:async';

import 'package:locnet_app/core/data/storage/db/db.dart';
import 'package:locnet_app/core/data/storage/db/mappers/conversation_tile_mapper.dart';
import 'package:locnet_app/features/conversations_list/data/repositories/conversations_list_repo/i_conversations_list_repo.dart';
import 'package:locnet_app/features/conversations_list/domain/models/conversation_tile.dart';

final class DriftCachedConversationsListRepo implements IConversationsListRepo {
  DriftCachedConversationsListRepo({
    required IConversationsListRepo network,
    required ConversationTilesDao tilesDao,
  })  : _network = network,
        _tilesDao = tilesDao;

  final IConversationsListRepo _network;
  final ConversationTilesDao _tilesDao;

  @override
  Future<List<ConversationTile>> loadConversationsList({int page = 1}) async {
    final cachedRows = await _tilesDao.getAllTiles();
    if (cachedRows.isNotEmpty) {
      if (page == 1) unawaited(_refreshFromNetwork(page));
      return cachedRows.map(ConversationTileMapper.fromRow).toList();
    }

    final fresh = await _network.loadConversationsList(page: page);
    await _saveToCache(fresh);
    return fresh;
  }

  @override
  Stream<ConversationsListUpdateRec> get conversationsUpdates =>
      _network.conversationsUpdates.asyncMap((update) async {
        await _applyUpdateToCache(update);
        return update;
      });

  Future<void> _refreshFromNetwork(int page) async {
    try {
      final fresh = await _network.loadConversationsList(page: page);
      await _saveToCache(fresh);
    } catch (_) {
      // фоновый refresh не должен ронять приложение
    }
  }

  Future<void> _saveToCache(List<ConversationTile> tiles) async {
    final companions = tiles.map(ConversationTileMapper.toCompanion).toList();
    await _tilesDao.upsertAll(companions);
  }

  Future<void> _applyUpdateToCache(ConversationsListUpdateRec update) async {
    switch (update.updateType) {
      case ConversationTileUpdateType.created:
      case ConversationTileUpdateType.updated:
        await _tilesDao.upsertTile(
            ConversationTileMapper.toCompanion(update.conversationTile));
      case ConversationTileUpdateType.deleted:
        await _tilesDao.deleteTile(update.conversationTile.id);
    }
  }

  @override
  Future<void> dispose() => _network.dispose();
}
