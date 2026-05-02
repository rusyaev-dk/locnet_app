import 'package:drift/drift.dart';
import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/core/data/storage/db/db.dart';
import 'package:locnet_app/features/conversations_list/domain/domain.dart';

final class ConversationTileMapper {
  static ConversationTilesTableCompanion toCompanion(ConversationTile tile) {
    final User? c = tile.companion;
    return ConversationTilesTableCompanion(
      id: Value(tile.id),
      type: Value(tile.type.name),
      title: Value(tile.title),
      description: Value(tile.description),
      companionId: Value(c?.userId),
      companionUsername: Value(c?.username),
      companionFirstName: Value(c?.firstName),
      companionLastName: Value(c?.lastName),
      companionAvatarId: Value(c?.avatarId),
      lastMessageText: Value(tile.lastMessageText),
      lastMessageSenderId: Value(tile.lastMessageSenderId),
      lastMessageAtMs: Value(tile.lastMessageAt?.millisecondsSinceEpoch),
      updatedAtMs: Value(tile.updatedAt.millisecondsSinceEpoch),
      cachedAtMs: Value(DateTime.now().millisecondsSinceEpoch),
    );
  }

  static ConversationTile fromRow(ConversationTilesTableData row) {
    User? companion;
    if (row.companionId != null) {
      companion = User(
        userId: row.companionId!,
        username: row.companionUsername ?? '',
        firstName: row.companionFirstName ?? '',
        lastName: row.companionLastName ?? '',
        avatarId: row.companionAvatarId,
        languageCode: 'ru',
        isDeleted: false,
        isBanned: false,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    }

    return ConversationTile(
      id: row.id,
      type: ConversationTileType.values.firstWhere(
        (e) => e.name == row.type,
        orElse: () => ConversationTileType.private,
      ),
      title: row.title,
      description: row.description,
      companion: companion,
      lastMessageText: row.lastMessageText,
      lastMessageSenderId: row.lastMessageSenderId,
      lastMessageAt: row.lastMessageAtMs != null
          ? DateTime.fromMillisecondsSinceEpoch(row.lastMessageAtMs!)
          : null,
      updatedAt: DateTime.fromMillisecondsSinceEpoch(row.updatedAtMs),
    );
  }
}
