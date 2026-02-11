// ignore_for_file: sort_constructors_first

import 'package:equatable/equatable.dart';
import 'package:locnet_app/features/conversation/subfeatures/group/group.dart';

class GroupMessageAttachment extends Equatable {
  const GroupMessageAttachment({
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

  factory GroupMessageAttachment.fromDto(GroupMessageAttachmentDto dto) {
    return GroupMessageAttachment(
      id: dto.id,
      messageId: dto.messageId,
      fileId: dto.fileId,
      order: dto.order,
      createdAt: dto.createdAt,
    );
  }

  GroupMessageAttachment copyWith({
    String? id,
    String? messageId,
    String? fileId,
    int? order,
    DateTime? createdAt,
  }) {
    return GroupMessageAttachment(
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
