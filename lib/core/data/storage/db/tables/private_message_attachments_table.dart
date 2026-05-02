import 'package:drift/drift.dart';

class PrivateMessageAttachmentsTable extends Table {
  @override
  String get tableName => 'private_message_attachments';

  TextColumn get id => text()();
  TextColumn get messageId => text()();
  TextColumn get fileId => text()();
  TextColumn get fileType => text().nullable()();
  IntColumn get order => integer()();
  IntColumn get createdAtMs => integer()();

  @override
  Set<Column> get primaryKey => {id};
}
