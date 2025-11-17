// ignore_for_file: sort_constructors_first

import 'package:equatable/equatable.dart';

class MessageDTO extends Equatable {
  const MessageDTO({
    required this.messageId,
    required this.conversationId,
    required this.senderId,
    required this.hasAttachments,
    required this.createdAt,
    required this.updatedAt,
    this.message,
    this.replyToMessageId,
    this.isPinned,
    this.editedAt,
    this.isDeleted,
    this.deletedAt,
  });

  final String messageId; // uuid
  final String conversationId; // uuid
  final String senderId; // uuid
  final String? message; // text?
  final bool hasAttachments; // boolean
  final String? replyToMessageId; // uuid?
  final bool? isPinned; // boolean?
  final DateTime? editedAt; // timestamp?
  final bool? isDeleted; // boolean?
  final DateTime? deletedAt; // timestamp?
  final DateTime createdAt; // timestamp
  final DateTime updatedAt; // timestamp

  factory MessageDTO.fromJSON(Map<String, dynamic> json) {
    DateTime? parseNullable(dynamic v) {
      if (v == null) return null;
      if (v is DateTime) return v;
      if (v is int) return DateTime.fromMillisecondsSinceEpoch(v);
      return DateTime.parse(v as String);
    }

    DateTime parseNonNull(dynamic v) {
      if (v is DateTime) return v;
      if (v is int) return DateTime.fromMillisecondsSinceEpoch(v);
      return DateTime.parse(v as String);
    }

    return MessageDTO(
      messageId: json['messageId'] as String,
      conversationId: json['conversationId'] as String,
      senderId: json['senderId'] as String,
      message: json['message'] as String?,
      hasAttachments: json['hasAttachments'] as bool,
      replyToMessageId: json['replyToMessageId'] as String?,
      isPinned: json['isPinned'] as bool?,
      editedAt: parseNullable(json['editedAt']),
      isDeleted: json['isDeleted'] as bool?,
      deletedAt: parseNullable(json['deletedAt']),
      createdAt: parseNonNull(json['createdAt']),
      updatedAt: parseNonNull(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJSON() => <String, dynamic>{
    'messageId': messageId,
    'conversationId': conversationId,
    'senderId': senderId,
    'message': message,
    'hasAttachments': hasAttachments,
    'replyToMessageId': replyToMessageId,
    'isPinned': isPinned,
    'editedAt': editedAt?.toIso8601String(),
    'isDeleted': isDeleted,
    'deletedAt': deletedAt?.toIso8601String(),
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };

  MessageDTO copyWith({
    String? messageId,
    String? conversationId,
    String? senderId,
    String? message,
    bool? hasAttachments,
    String? replyToMessageId,
    bool? isPinned,
    DateTime? editedAt,
    bool? isDeleted,
    DateTime? deletedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return MessageDTO(
      messageId: messageId ?? this.messageId,
      conversationId: conversationId ?? this.conversationId,
      senderId: senderId ?? this.senderId,
      message: message ?? this.message,
      hasAttachments: hasAttachments ?? this.hasAttachments,
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
    conversationId,
    senderId,
    message,
    hasAttachments,
    replyToMessageId,
    isPinned,
    editedAt,
    isDeleted,
    deletedAt,
    createdAt,
    updatedAt,
  ];
}
