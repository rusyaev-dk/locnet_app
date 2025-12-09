// ignore_for_file: sort_constructors_first

import 'package:equatable/equatable.dart';
import 'package:locnet_app/features/message/data/data.dart';

class Message extends Equatable {
  const Message({
    required this.messageId,
    required this.conversationId,
    required this.senderId,
    required this.hasAttachments,
    required this.createdAt,
    required this.updatedAt,
    this.text,
    this.replyToMessageId,
    this.isPinned = false,
    this.editedAt,
    this.isDeleted = false,
    this.deletedAt,
  });

  final String messageId;
  final String conversationId;
  final String senderId;
  final String? text;
  final bool hasAttachments;
  final String? replyToMessageId;
  final bool isPinned;
  final DateTime? editedAt;
  final bool isDeleted;
  final DateTime? deletedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  /// Convenience getters for UI/business logic.
  bool get isEdited => editedAt != null;
  bool get isActive => !isDeleted;

  /// Convert from DTO.
  factory Message.fromDto(MessageDto dto) {
    return Message(
      messageId: dto.messageId,
      conversationId: dto.conversationId,
      senderId: dto.senderId,
      text: dto.text,
      hasAttachments: dto.hasAttachments,
      replyToMessageId: dto.replyToMessageId,
      isPinned: dto.isPinned ?? false,
      editedAt: dto.editedAt,
      isDeleted: dto.isDeleted ?? false,
      deletedAt: dto.deletedAt,
      createdAt: dto.createdAt,
      updatedAt: dto.updatedAt,
    );
  }

  /// Convert back to DTO.
  MessageDto toDto() {
    return MessageDto(
      messageId: messageId,
      conversationId: conversationId,
      senderId: senderId,
      text: text,
      hasAttachments: hasAttachments,
      replyToMessageId: replyToMessageId,
      isPinned: isPinned,
      editedAt: editedAt,
      isDeleted: isDeleted,
      deletedAt: deletedAt,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  Message copyWith({
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
  }) {
    return Message(
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
  ];
}
