// ignore_for_file: sort_constructors_first

import 'package:equatable/equatable.dart';
import 'package:locnet_app/features/message/data/data.dart';
import 'package:locnet_app/features/message/domain/domain.dart';

class Message extends Equatable {
  const Message({
    required this.clientMessageId,
    required this.conversationId,
    required this.senderId,
    required this.hasAttachments,
    required this.createdAt,
    required this.updatedAt,
    required this.deliveryStatus,
    this.attachments = const <MessageAttachment>[],
    this.messageId,
    this.text,
    this.replyToMessageId,
    this.isPinned = false,
    this.editedAt,
    this.isDeleted = false,
    this.deletedAt,
  });

  final String? messageId;
  final String clientMessageId;
  final String conversationId;
  final String senderId;
  final MessageDeliveryStatus deliveryStatus;

  final String? text;
  final bool hasAttachments;
  final List<MessageAttachment> attachments;
  final String? replyToMessageId;
  final bool isPinned;
  final DateTime? editedAt;
  final bool isDeleted;
  final DateTime? deletedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  bool get isEdited => editedAt != null;
  bool get isActive => !isDeleted;
  bool get isSending => deliveryStatus == MessageDeliveryStatus.sending;
  bool get isFailed => deliveryStatus == MessageDeliveryStatus.failed;

  factory Message.fromDto(MessageDto dto) {
    return Message(
      messageId: dto.messageId,
      clientMessageId: dto.clientMessageId,
      conversationId: dto.conversationId,
      senderId: dto.senderId,
      text: dto.text,
      hasAttachments: dto.hasAttachments,
      attachments: dto.attachments
          .map(
            (MessageAttachmentDto attachmentDto) =>
                MessageAttachment.fromDto(attachmentDto),
          )
          .toList(growable: false),
      replyToMessageId: dto.replyToMessageId,
      isPinned: dto.isPinned ?? false,
      editedAt: dto.editedAt,
      isDeleted: dto.isDeleted ?? false,
      deletedAt: dto.deletedAt,
      createdAt: dto.createdAt,
      updatedAt: dto.updatedAt,
      deliveryStatus: MessageDeliveryStatus.fromString(dto.deliveryStatus),
    );
  }

  Message copyWith({
    String? messageId,
    String? clientMessageId,
    String? conversationId,
    String? senderId,
    MessageDeliveryStatus? deliveryStatus,
    String? text,
    bool? hasAttachments,
    List<MessageAttachment>? attachments,
    String? replyToMessageId,
    bool? isPinned,
    DateTime? editedAt,
    bool? isDeleted,
    DateTime? deletedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Message(
      messageId: messageId ?? this.messageId,
      clientMessageId: clientMessageId ?? this.clientMessageId,
      conversationId: conversationId ?? this.conversationId,
      senderId: senderId ?? this.senderId,
      deliveryStatus: deliveryStatus ?? this.deliveryStatus,
      text: text ?? this.text,
      hasAttachments: hasAttachments ?? this.hasAttachments,
      attachments: attachments ?? this.attachments,
      replyToMessageId: replyToMessageId ?? this.replyToMessageId,
      isPinned: isPinned ?? this.isPinned,
      editedAt: editedAt ?? this.editedAt,
      isDeleted: isDeleted ?? this.isDeleted,
      deletedAt: deletedAt ?? this.deletedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => <Object?>[
    messageId,
    clientMessageId,
    conversationId,
    senderId,
    deliveryStatus,
    text,
    hasAttachments,
    attachments,
    replyToMessageId,
    isPinned,
    editedAt,
    isDeleted,
    deletedAt,
    createdAt,
    updatedAt,
  ];
}
