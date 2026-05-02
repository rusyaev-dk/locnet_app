// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conversation_tiles_dao.dart';

// ignore_for_file: type=lint
mixin _$ConversationTilesDaoMixin on DatabaseAccessor<AppDatabase> {
  $ConversationTilesTableTable get conversationTilesTable =>
      attachedDatabase.conversationTilesTable;
  ConversationTilesDaoManager get managers => ConversationTilesDaoManager(this);
}

class ConversationTilesDaoManager {
  final _$ConversationTilesDaoMixin _db;
  ConversationTilesDaoManager(this._db);
  $$ConversationTilesTableTableTableManager get conversationTilesTable =>
      $$ConversationTilesTableTableTableManager(
        _db.attachedDatabase,
        _db.conversationTilesTable,
      );
}
