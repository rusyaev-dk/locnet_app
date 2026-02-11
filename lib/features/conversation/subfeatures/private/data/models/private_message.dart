// ignore_for_file: sort_constructors_first

import 'package:equatable/equatable.dart';
import 'package:locnet_app/core/presentation/utils/utils.dart';
import 'package:locnet_app/features/conversation/subfeatures/private/private.dart';

class PrivateMessageDto extends Equatable {
  const PrivateMessageDto({
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
  final String deliveryStatus;
  final String? clientMessageId;
  final String text;
  final List<PrivateMessageAttachmentDto> attachments;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isDeleted;
  final bool isPinned;
  final DateTime? editedAt;
  final String? deletedById;
  final String? replyToMessageId;

  factory PrivateMessageDto.fromJson(Map<String, dynamic> json) {
    return PrivateMessageDto(
      id: json['id'] as String,
      conversationId: json['conversationId'] as String,
      senderId: json['senderId'] as String,
      deliveryStatus: json['deliveryStatus'] as String,
      clientMessageId: json['clientMessageId'] as String?,
      text: json['text'] as String,
      attachments: json['attachments'] as List<PrivateMessageAttachmentDto>,
      createdAt: DateTimeFormatter.parse(json['createdAt'] as String),
      updatedAt: DateTimeFormatter.parse(json['updatedAt'] as String),
      isDeleted: json['isDeleted'] as bool,
      isPinned: json['isPinned'] as bool,
      deletedById: json['deletedById'] as String?,
      replyToMessageId: json['replyToMessageId'] as String?,
      editedAt: json['editedAt'] != null
          ? DateTimeFormatter.parse(json['editedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'conversationId': conversationId,
    'senderId': senderId,
    'deliveryStatus': deliveryStatus,
    'clientMessageId': clientMessageId,
    'text': text,
    'attachments': attachments
        .map((PrivateMessageAttachmentDto attachment) => attachment.toJson())
        .toList(),
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
    'isDeleted': isDeleted,
    'isPinned': isPinned,
    'deletedById': deletedById,
    'replyToMessageId': replyToMessageId,
    'editedAt': editedAt?.toIso8601String(),
  };

  @override
  List<Object?> get props => [
    id,
    conversationId,
    senderId,
    deliveryStatus,
    clientMessageId,
    text,
    attachments,
    createdAt,
    updatedAt,
    isDeleted,
    isPinned,
    deletedById,
    replyToMessageId,
    editedAt,
  ];
}
