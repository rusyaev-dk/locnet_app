// ignore_for_file: sort_constructors_first

import 'package:equatable/equatable.dart';
import 'package:locnet_app/core/core.dart';

final class ChannelPublicationAttachmentDto extends Equatable {
  const ChannelPublicationAttachmentDto({
    required this.id,
    required this.publicationId,
    required this.fileId,
    required this.order,
    required this.createdAt,
  });

  final String id;
  final String publicationId;
  final String fileId;
  final int order;
  final DateTime createdAt;

  factory ChannelPublicationAttachmentDto.fromJson(Map<String, dynamic> json) {
    return ChannelPublicationAttachmentDto(
      id: json['id'] as String,
      publicationId: json['publicationId'] as String,
      fileId: json['fileId'] as String,
      order: json['order'] as int,
      createdAt: DateTimeFormatter.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'publicationId': publicationId,
    'fileId': fileId,
    'order': order,
    'createdAt': createdAt.toIso8601String(),
  };

  @override
  List<Object?> get props => [id, publicationId, fileId, order, createdAt];
}
