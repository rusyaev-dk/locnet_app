// ignore_for_file: sort_constructors_first

import 'package:equatable/equatable.dart';
import 'package:locnet_app/features/message/data/data.dart';

class MessageAttachment extends Equatable {
  const MessageAttachment({
    required this.id,
    required this.messageId,
    required this.createdAt,
    required this.updatedAt,
    this.fileId,
    this.position,
  });

  final String id;
  final String messageId;
  final String? fileId;
  final int? position;
  final DateTime createdAt;
  final DateTime updatedAt;

  /// Convenience flag for UI/business logic.
  bool get hasFile => fileId != null && fileId!.isNotEmpty;

  /// Convert from DTO to domain.
  factory MessageAttachment.fromDTO(MessageAttachmentDTO dto) {
    return MessageAttachment(
      id: dto.attachmentId,
      messageId: dto.messageId,
      fileId: dto.fileId,
      position: dto.position,
      createdAt: dto.createdAt,
      updatedAt: dto.updatedAt,
    );
  }

  /// Convert from domain back to DTO.
  MessageAttachmentDTO toDTO() {
    return MessageAttachmentDTO(
      attachmentId: id,
      messageId: messageId,
      fileId: fileId,
      position: position,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  MessageAttachment copyWith({
    String? id,
    String? messageId,
    String? fileId,
    int? position,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return MessageAttachment(
      id: id ?? this.id,
      messageId: messageId ?? this.messageId,
      fileId: fileId ?? this.fileId,
      position: position ?? this.position,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => <Object?>[
    id,
    messageId,
    fileId,
    position,
    createdAt,
    updatedAt,
  ];
}
