// ignore_for_file: sort_constructors_first

import 'package:equatable/equatable.dart';
import 'package:locnet_app/features/conversation/subfeatures/private/data/data.dart';
import 'package:locnet_app/features/conversation/subfeatures/private/domain/domain.dart';
import 'package:locnet_app/features/message/domain/domain.dart';

class PrivateMessage extends Equatable {
  const PrivateMessage({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.text,
    required this.attachments,
    required this.createdAt,
    required this.updatedAt,
    required this.isDeleted,
    required this.deletedById,
    required this.replyToMessageId,
    required this.deliveryStatus,
    required this.clientMessageId,
    required this.isPinned,
    required this.editedAt,
  });

  final String id;
  final String conversationId;
  final String senderId;
  final MessageDeliveryStatus deliveryStatus;
  final String? clientMessageId;
  final String text;
  final List<PrivateMessageAttachment> attachments;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isDeleted;
  final String? deletedById;
  final String? replyToMessageId;
  final bool isPinned;
  final DateTime? editedAt;
  factory PrivateMessage.fromDto(PrivateMessageDto dto) {
    return PrivateMessage(
      id: dto.id,
      conversationId: dto.conversationId,
      senderId: dto.senderId,
      deliveryStatus: MessageDeliveryStatus.fromString(dto.deliveryStatus),
      clientMessageId: dto.clientMessageId,
      text: dto.text,
      attachments: dto.attachments
          .map(PrivateMessageAttachment.fromDto)
          .toList(),
      createdAt: dto.createdAt,
      updatedAt: dto.updatedAt,
      isDeleted: dto.isDeleted,
      deletedById: dto.deletedById,
      replyToMessageId: dto.replyToMessageId,
      isPinned: dto.isPinned,
      editedAt: dto.editedAt,
    );
  }

  PrivateMessage copyWith({
    String? id,
    String? conversationId,
    String? senderId,
    String? text,
    List<PrivateMessageAttachment>? attachments,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isDeleted,
    String? deletedById,
    String? replyToMessageId,
    MessageDeliveryStatus? deliveryStatus,
    String? clientMessageId,
    bool? isPinned,
    DateTime? editedAt,
  }) {
    return PrivateMessage(
      id: id ?? this.id,
      conversationId: conversationId ?? this.conversationId,
      senderId: senderId ?? this.senderId,
      deliveryStatus: deliveryStatus ?? this.deliveryStatus,
      clientMessageId: clientMessageId ?? this.clientMessageId,
      text: text ?? this.text,
      attachments: attachments ?? this.attachments,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isDeleted: isDeleted ?? this.isDeleted,
      deletedById: deletedById ?? this.deletedById,
      replyToMessageId: replyToMessageId ?? this.replyToMessageId,
      isPinned: isPinned ?? this.isPinned,
      editedAt: editedAt ?? this.editedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    conversationId,
    senderId,
    text,
    attachments,
    createdAt,
    updatedAt,
    isDeleted,
    deletedById,
    replyToMessageId,
    deliveryStatus,
    clientMessageId,
    isPinned,
    editedAt,
  ];
}
