// ignore_for_file: sort_constructors_first

import 'package:equatable/equatable.dart';
import 'package:locnet_app/features/conversation/subfeatures/group/group.dart';
import 'package:locnet_app/features/message/domain/domain.dart';

class GroupMessage extends Equatable {
  const GroupMessage({
    required this.id,
    required this.senderId,
    required this.groupId,
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
  final String senderId;
  final MessageDeliveryStatus deliveryStatus;
  final String? clientMessageId;
  final String groupId;
  final String text;
  final List<GroupMessageAttachment> attachments;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isDeleted;
  final bool isPinned;
  final String? deletedById;
  final String? replyToMessageId;
  final DateTime? editedAt;
  factory GroupMessage.fromDto(GroupMessageDto dto) {
    return GroupMessage(
      id: dto.id,
      senderId: dto.senderId,
      groupId: dto.groupId,
      text: dto.text,
      attachments: dto.attachments.map(GroupMessageAttachment.fromDto).toList(),
      createdAt: dto.createdAt,
      updatedAt: dto.updatedAt,
      isDeleted: dto.isDeleted,
      deletedById: dto.deletedById,
      replyToMessageId: dto.replyToMessageId,
      deliveryStatus: MessageDeliveryStatus.fromString(dto.deliveryStatus),
      clientMessageId: dto.clientMessageId,
      isPinned: dto.isPinned,
      editedAt: dto.editedAt,
    );
  }

  GroupMessage copyWith({
    String? id,
    String? senderId,
    String? groupId,
    String? text,
    List<GroupMessageAttachment>? attachments,
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
    return GroupMessage(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      groupId: groupId ?? this.groupId,
      text: text ?? this.text,
      attachments: attachments ?? this.attachments,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isDeleted: isDeleted ?? this.isDeleted,
      deletedById: deletedById ?? this.deletedById,
      replyToMessageId: replyToMessageId ?? this.replyToMessageId,
      deliveryStatus: deliveryStatus ?? this.deliveryStatus,
      clientMessageId: clientMessageId ?? this.clientMessageId,
      isPinned: isPinned ?? this.isPinned,
      editedAt: editedAt ?? this.editedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    senderId,
    groupId,
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
