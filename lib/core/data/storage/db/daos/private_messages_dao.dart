import 'package:drift/drift.dart';
import 'package:locnet_app/core/data/storage/db/app_database.dart';
import 'package:locnet_app/core/data/storage/db/tables/private_message_attachments_table.dart';
import 'package:locnet_app/core/data/storage/db/tables/private_messages_table.dart';

part 'private_messages_dao.g.dart';

const int _pageSize = 30;

@DriftAccessor(tables: [PrivateMessagesTable, PrivateMessageAttachmentsTable])
class PrivateMessagesDao extends DatabaseAccessor<AppDatabase>
    with _$PrivateMessagesDaoMixin {
  PrivateMessagesDao(super.db);

  Future<List<PrivateMessagesTableData>> getPage({
    required String conversationId,
    int page = 1,
  }) {
    final int offset = (page - 1) * _pageSize;
    return (select(privateMessagesTable)
          ..where((t) =>
              t.conversationId.equals(conversationId) &
              t.isDeleted.equals(false))
          ..orderBy([(t) => OrderingTerm.desc(t.createdAtMs)])
          ..limit(_pageSize, offset: offset))
        .get();
  }

  Future<List<PrivateMessageAttachmentsTableData>> getAttachments(
          String messageId) =>
      (select(privateMessageAttachmentsTable)
            ..where((t) => t.messageId.equals(messageId))
            ..orderBy([(t) => OrderingTerm.asc(t.order)]))
          .get();

  Future<void> upsertMessage(PrivateMessagesTableCompanion entry) =>
      into(privateMessagesTable).insertOnConflictUpdate(entry);

  Future<void> upsertAll(List<PrivateMessagesTableCompanion> entries) =>
      batch((b) => b.insertAllOnConflictUpdate(privateMessagesTable, entries));

  Future<void> upsertAttachments(
          List<PrivateMessageAttachmentsTableCompanion> entries) =>
      batch((b) =>
          b.insertAllOnConflictUpdate(privateMessageAttachmentsTable, entries));

  Future<void> markDeleted(String messageId) =>
      (update(privateMessagesTable)..where((t) => t.id.equals(messageId)))
          .write(const PrivateMessagesTableCompanion(
        isDeleted: Value(true),
      ));

  Future<void> keepRecentPerConversation({
    required String conversationId,
    int limit = 60,
  }) async {
    final rows = await getPage(conversationId: conversationId);
    if (rows.length < limit) return;
    final cutoffMs = rows[limit - 1].createdAtMs;
    await (delete(privateMessagesTable)
          ..where((t) =>
              t.conversationId.equals(conversationId) &
              t.createdAtMs.isSmallerThanValue(cutoffMs)))
        .go();
  }

  Future<void> deleteByConversation(String conversationId) =>
      (delete(privateMessagesTable)
            ..where((t) => t.conversationId.equals(conversationId)))
          .go();
}
