import 'package:drift/drift.dart';
import 'package:locnet_app/core/data/storage/db/tables/private_messages_table.dart';

class PrivateMessageAttachmentsTable extends Table {
  @override
  String get tableName => 'private_message_attachments';

  TextColumn get id => text()();
  TextColumn get messageId => text().references(
        PrivateMessagesTable,
        #id,
        onDelete: KeyAction.cascade,
      )();
  TextColumn get fileId => text()();
  TextColumn get fileType => text().nullable()();
  IntColumn get order => integer()();
  IntColumn get createdAtMs => integer()();

  @override
  Set<Column> get primaryKey => {id};
}
