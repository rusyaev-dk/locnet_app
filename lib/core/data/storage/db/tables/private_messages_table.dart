import 'package:drift/drift.dart';

class PrivateMessagesTable extends Table {
  @override
  String get tableName => 'private_messages';

  TextColumn get id => text()();
  TextColumn get clientMessageId => text().nullable()();
  TextColumn get conversationId => text()();
  TextColumn get senderId => text()();
  TextColumn get messageText => text().named('text')();
  TextColumn get deliveryStatus => text()();
  TextColumn get replyToMessageId => text().nullable()();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
  TextColumn get deletedById => text().nullable()();
  BoolColumn get isPinned => boolean().withDefault(const Constant(false))();
  IntColumn get createdAtMs => integer()();
  IntColumn get updatedAtMs => integer()();
  IntColumn get editedAtMs => integer().nullable()();
  IntColumn get readAtMs => integer().nullable()();
  IntColumn get cachedAtMs => integer()();

  @override
  Set<Column> get primaryKey => {id};
}
