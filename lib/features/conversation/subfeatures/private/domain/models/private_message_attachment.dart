// ignore_for_file: sort_constructors_first

import 'package:equatable/equatable.dart';
import 'package:locnet_app/features/conversation/subfeatures/private/data/data.dart';

class PrivateMessageAttachment extends Equatable {
  const PrivateMessageAttachment({
    required this.id,
    required this.messageId,
    required this.fileId,
    required this.order,
    required this.createdAt,
  });

  final String id;
  final String messageId;
  final String fileId;
  final int order;
  final DateTime createdAt;

  factory PrivateMessageAttachment.fromDto(PrivateMessageAttachmentDto dto) {
    return PrivateMessageAttachment(
      id: dto.id,
      messageId: dto.messageId,
      fileId: dto.fileId,
      order: dto.order,
      createdAt: dto.createdAt,
    );
  }

  PrivateMessageAttachment copyWith({
    String? id,
    String? messageId,
    String? fileId,
    int? order,
    DateTime? createdAt,
  }) {
    return PrivateMessageAttachment(
      id: id ?? this.id,
      messageId: messageId ?? this.messageId,
      fileId: fileId ?? this.fileId,
      order: order ?? this.order,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [id, messageId, fileId, order, createdAt];
}
