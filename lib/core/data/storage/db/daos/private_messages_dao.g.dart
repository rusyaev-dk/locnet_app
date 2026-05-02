// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'private_messages_dao.dart';

// ignore_for_file: type=lint
mixin _$PrivateMessagesDaoMixin on DatabaseAccessor<AppDatabase> {
  $PrivateMessagesTableTable get privateMessagesTable =>
      attachedDatabase.privateMessagesTable;
  $PrivateMessageAttachmentsTableTable get privateMessageAttachmentsTable =>
      attachedDatabase.privateMessageAttachmentsTable;
  PrivateMessagesDaoManager get managers => PrivateMessagesDaoManager(this);
}

class PrivateMessagesDaoManager {
  final _$PrivateMessagesDaoMixin _db;
  PrivateMessagesDaoManager(this._db);
  $$PrivateMessagesTableTableTableManager get privateMessagesTable =>
      $$PrivateMessagesTableTableTableManager(
        _db.attachedDatabase,
        _db.privateMessagesTable,
      );
  $$PrivateMessageAttachmentsTableTableTableManager
  get privateMessageAttachmentsTable =>
      $$PrivateMessageAttachmentsTableTableTableManager(
        _db.attachedDatabase,
        _db.privateMessageAttachmentsTable,
      );
}
