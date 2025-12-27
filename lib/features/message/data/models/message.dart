// ignore_for_file: sort_constructors_first

import 'package:equatable/equatable.dart';

class MessageDto extends Equatable {
  const MessageDto({
    required this.messageId,
    required this.clientMessageId,
    required this.conversationId,
    required this.senderId,
    required this.hasAttachments,
    required this.createdAt,
    required this.updatedAt,
    required this.deliveryStatus,
    this.text,
    this.replyToMessageId,
    this.isPinned,
    this.editedAt,
    this.isDeleted,
    this.deletedAt,
  });

  final String messageId;
  final String clientMessageId;
  final String conversationId;
  final String deliveryStatus;
  final String senderId;
  final String? text;
  final bool hasAttachments;
  final String? replyToMessageId;
  final bool? isPinned;
  final DateTime? editedAt;
  final bool? isDeleted;
  final DateTime? deletedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  factory MessageDto.fromJson(Map<String, dynamic> json) {
    DateTime? parseNullable(dynamic value) {
      if (value == null) return null;
      if (value is DateTime) return value;
      if (value is int) {
        return DateTime.fromMillisecondsSinceEpoch(value);
      }
      return DateTime.parse(value as String);
    }

    DateTime parseNonNull(dynamic value) {
      if (value is DateTime) return value;
      if (value is int) {
        return DateTime.fromMillisecondsSinceEpoch(value);
      }
      return DateTime.parse(value as String);
    }

    return MessageDto(
      messageId: json['messageId'] as String,
      conversationId: json['conversationId'] as String,
      senderId: json['senderId'] as String,
      text: json['text'] as String?,
      hasAttachments: json['hasAttachments'] as bool,
      replyToMessageId: json['replyToMessageId'] as String?,
      isPinned: json['isPinned'] as bool?,
      editedAt: parseNullable(json['editedAt']),
      isDeleted: json['isDeleted'] as bool?,
      deletedAt: parseNullable(json['deletedAt']),
      createdAt: parseNonNull(json['createdAt']),
      updatedAt: parseNonNull(json['updatedAt']),
      clientMessageId: json['clientMessageId'] as String,
      deliveryStatus: json['deliveryStatus'] as String,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'messageId': messageId,
    'conversationId': conversationId,
    'senderId': senderId,
    'text': text,
    'hasAttachments': hasAttachments,
    'replyToMessageId': replyToMessageId,
    'isPinned': isPinned,
    'editedAt': editedAt?.toIso8601String(),
    'isDeleted': isDeleted,
    'deletedAt': deletedAt?.toIso8601String(),
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
    'clientMessageId': clientMessageId,
    'deliveryStatus': deliveryStatus,
  };

  MessageDto copyWith({
    String? messageId,
    String? conversationId,
    String? senderId,
    String? text,
    bool? hasAttachments,
    String? replyToMessageId,
    bool? isPinned,
    DateTime? editedAt,
    bool? isDeleted,
    DateTime? deletedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? clientMessageId,
    String? deliveryStatus,
  }) {
    return MessageDto(
      messageId: messageId ?? this.messageId,
      conversationId: conversationId ?? this.conversationId,
      senderId: senderId ?? this.senderId,
      text: text ?? this.text,
      hasAttachments: hasAttachments ?? this.hasAttachments,
      replyToMessageId: replyToMessageId ?? this.replyToMessageId,
      isPinned: isPinned ?? this.isPinned,
      editedAt: editedAt ?? this.editedAt,
      isDeleted: isDeleted ?? this.isDeleted,
      deletedAt: deletedAt ?? this.deletedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      clientMessageId: clientMessageId ?? this.clientMessageId,
      deliveryStatus: deliveryStatus ?? this.deliveryStatus,
    );
  }

  @override
  List<Object?> get props => <Object?>[
    messageId,
    conversationId,
    senderId,
    text,
    hasAttachments,
    replyToMessageId,
    isPinned,
    editedAt,
    isDeleted,
    deletedAt,
    createdAt,
    updatedAt,
    clientMessageId,
    deliveryStatus,
  ];
}
