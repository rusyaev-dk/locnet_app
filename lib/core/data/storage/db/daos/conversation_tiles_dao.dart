import 'package:drift/drift.dart';
import 'package:locnet_app/core/data/storage/db/app_database.dart';
import 'package:locnet_app/core/data/storage/db/tables/conversation_tiles_table.dart';

part 'conversation_tiles_dao.g.dart';

@DriftAccessor(tables: [ConversationTilesTable])
class ConversationTilesDao extends DatabaseAccessor<AppDatabase>
    with _$ConversationTilesDaoMixin {
  ConversationTilesDao(super.db);

  Future<List<ConversationTilesTableData>> getAllTiles() =>
      (select(conversationTilesTable)
            ..orderBy([
              (t) => OrderingTerm.desc(t.updatedAtMs),
            ]))
          .get();

  Future<void> upsertTile(ConversationTilesTableCompanion entry) =>
      into(conversationTilesTable).insertOnConflictUpdate(entry);

  Future<void> upsertAll(List<ConversationTilesTableCompanion> entries) =>
      batch((b) => b.insertAllOnConflictUpdate(conversationTilesTable, entries));

  Future<int> deleteTile(String id) =>
      (delete(conversationTilesTable)..where((t) => t.id.equals(id))).go();

  Future<void> keepOnlyRecent({int limit = 50}) async {
    final all = await getAllTiles();
    if (all.length <= limit) return;
    final toDelete = all.skip(limit).map((e) => e.id).toList();
    await (delete(conversationTilesTable)
          ..where((t) => t.id.isIn(toDelete)))
        .go();
  }
}
