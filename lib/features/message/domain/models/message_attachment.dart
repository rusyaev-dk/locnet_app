// ignore_for_file: sort_constructors_first

import 'package:equatable/equatable.dart';
import 'package:locnet_app/features/message/data/data.dart';

class MessageAttachment extends Equatable {
  const MessageAttachment({
    required this.clientAttachmentId,
    required this.createdAt,
    required this.updatedAt,
    this.attachmentId,
    this.messageId,
    this.fileId,
    this.position,
  });

  final String clientAttachmentId;
  final String? attachmentId;
  final String? messageId;
  final String? fileId;
  final int? position;
  final DateTime createdAt;
  final DateTime updatedAt;

  bool get hasFile => fileId != null && fileId!.isNotEmpty;
  bool get isUploaded => attachmentId != null;

  factory MessageAttachment.fromDto(MessageAttachmentDto dto) {
    return MessageAttachment(
      clientAttachmentId: dto.clientAttachmentId,
      attachmentId: dto.attachmentId,
      messageId: dto.messageId,
      fileId: dto.fileId,
      position: dto.position,
      createdAt: dto.createdAt,
      updatedAt: dto.updatedAt,
    );
  }

  MessageAttachmentDto toDto() {
    return MessageAttachmentDto(
      clientAttachmentId: clientAttachmentId,
      attachmentId: attachmentId,
      messageId: messageId,
      fileId: fileId,
      position: position,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  MessageAttachment copyWith({
    String? clientAttachmentId,
    String? attachmentId,
    String? messageId,
    String? fileId,
    int? position,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return MessageAttachment(
      clientAttachmentId: clientAttachmentId ?? this.clientAttachmentId,
      attachmentId: attachmentId ?? this.attachmentId,
      messageId: messageId ?? this.messageId,
      fileId: fileId ?? this.fileId,
      position: position ?? this.position,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => <Object?>[
    clientAttachmentId,
    attachmentId,
    messageId,
    fileId,
    position,
    createdAt,
    updatedAt,
  ];
}
