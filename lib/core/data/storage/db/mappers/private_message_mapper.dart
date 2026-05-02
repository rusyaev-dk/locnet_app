import 'package:drift/drift.dart';
import 'package:locnet_app/core/data/storage/db/db.dart';
import 'package:locnet_app/features/conversation/subfeatures/private/domain/domain.dart';
import 'package:locnet_app/features/message/domain/domain.dart';

final class PrivateMessageMapper {
  static PrivateMessagesTableCompanion toCompanion(PrivateMessage msg) {
    final String effectiveId =
        msg.id.isEmpty ? msg.clientMessageId ?? '' : msg.id;
    return PrivateMessagesTableCompanion(
      id: Value(effectiveId),
      clientMessageId: Value(msg.clientMessageId),
      conversationId: Value(msg.conversationId),
      senderId: Value(msg.senderId),
      messageText: Value(msg.text),
      deliveryStatus: Value(msg.deliveryStatus.value),
      replyToMessageId: Value(msg.replyToMessageId),
      isDeleted: Value(msg.isDeleted),
      deletedById: Value(msg.deletedById),
      isPinned: Value(msg.isPinned),
      createdAtMs: Value(msg.createdAt.millisecondsSinceEpoch),
      updatedAtMs: Value(msg.updatedAt.millisecondsSinceEpoch),
      editedAtMs: Value(msg.editedAt?.millisecondsSinceEpoch),
      readAtMs: Value(msg.readAt?.millisecondsSinceEpoch),
      cachedAtMs: Value(DateTime.now().millisecondsSinceEpoch),
    );
  }

  static List<PrivateMessageAttachmentsTableCompanion> attachmentsToCompanions(
      PrivateMessage msg) {
    final String effectiveId =
        msg.id.isEmpty ? msg.clientMessageId ?? '' : msg.id;
    return msg.attachments
        .map((a) => PrivateMessageAttachmentsTableCompanion(
              id: Value(a.id),
              messageId: Value(effectiveId),
              fileId: Value(a.fileId),
              fileType: Value(a.fileType),
              order: Value(a.order),
              createdAtMs: Value(a.createdAt.millisecondsSinceEpoch),
            ))
        .toList();
  }

  static PrivateMessage fromRow(
    PrivateMessagesTableData row,
    List<PrivateMessageAttachmentsTableData> attachmentRows,
  ) {
    return PrivateMessage(
      id: row.id,
      clientMessageId: row.clientMessageId,
      conversationId: row.conversationId,
      senderId: row.senderId,
      text: row.messageText,
      deliveryStatus: MessageDeliveryStatus.fromString(row.deliveryStatus),
      replyToMessageId: row.replyToMessageId,
      isDeleted: row.isDeleted,
      deletedById: row.deletedById,
      isPinned: row.isPinned,
      editedAt: row.editedAtMs != null
          ? DateTime.fromMillisecondsSinceEpoch(row.editedAtMs!)
          : null,
      readAt: row.readAtMs != null
          ? DateTime.fromMillisecondsSinceEpoch(row.readAtMs!)
          : null,
      createdAt: DateTime.fromMillisecondsSinceEpoch(row.createdAtMs),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(row.updatedAtMs),
      attachments: attachmentRows
          .map((a) => PrivateMessageAttachment(
                id: a.id,
                messageId: a.messageId,
                fileId: a.fileId,
                fileType: a.fileType,
                order: a.order,
                createdAt: DateTime.fromMillisecondsSinceEpoch(a.createdAtMs),
              ))
          .toList(),
    );
  }
}
