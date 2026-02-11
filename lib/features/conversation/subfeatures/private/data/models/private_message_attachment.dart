// ignore_for_file: sort_constructors_first

import 'package:equatable/equatable.dart';
import 'package:locnet_app/core/presentation/utils/utils.dart';

class PrivateMessageAttachmentDto extends Equatable {
  const PrivateMessageAttachmentDto({
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

  factory PrivateMessageAttachmentDto.fromJson(Map<String, dynamic> json) {
    return PrivateMessageAttachmentDto(
      id: json['id'] as String,
      messageId: json['messageId'] as String,
      fileId: json['fileId'] as String,
      order: json['order'] as int,
      createdAt: DateTimeFormatter.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'messageId': messageId,
    'fileId': fileId,
    'order': order,
    'createdAt': createdAt.toIso8601String(),
  };
  @override
  List<Object?> get props => [id, messageId, fileId, order, createdAt];
}
