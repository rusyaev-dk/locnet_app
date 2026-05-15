import 'package:drift/drift.dart';

class ConversationTilesTable extends Table {
  @override
  String get tableName => 'conversation_tiles';

  TextColumn get id => text()();
  TextColumn get type => text()();
  TextColumn get title => text()();
  TextColumn get description => text().nullable()();

  TextColumn get companionId => text().nullable()();
  TextColumn get companionUsername => text().nullable()();
  TextColumn get companionFirstName => text().nullable()();
  TextColumn get companionLastName => text().nullable()();
  TextColumn get companionAvatarId => text().nullable()();

  TextColumn get lastMessageText => text().nullable()();
  TextColumn get lastMessageSenderId => text().nullable()();
  IntColumn get lastMessageAtMs => integer().nullable()();

  IntColumn get updatedAtMs => integer()();
  IntColumn get cachedAtMs => integer()();

  @override
  Set<Column> get primaryKey => {id};
}
