// ignore_for_file: sort_constructors_first

import 'package:equatable/equatable.dart';
import 'package:locnet_app/features/conversation/subfeatures/channel/data/data.dart';

class ChannelPublicationAttachment extends Equatable {
  const ChannelPublicationAttachment({
    required this.attachmentId,
    required this.publicationId,
    required this.fileId,
    required this.order,
    required this.createdAt,
  });

  final String attachmentId;
  final String publicationId;
  final String fileId;
  final int order;
  final DateTime createdAt;

  ChannelPublicationAttachment copyWith({
    String? attachmentId,
    String? publicationId,
    String? fileId,
    int? order,
    DateTime? createdAt,
  }) {
    return ChannelPublicationAttachment(
      attachmentId: attachmentId ?? this.attachmentId,
      publicationId: publicationId ?? this.publicationId,
      fileId: fileId ?? this.fileId,
      order: order ?? this.order,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory ChannelPublicationAttachment.fromDto(
    ChannelPublicationAttachmentDto dto,
  ) {
    return ChannelPublicationAttachment(
      attachmentId: dto.id,
      publicationId: dto.publicationId,
      fileId: dto.fileId,
      order: dto.order,
      createdAt: dto.createdAt,
    );
  }

  @override
  List<Object?> get props => [
    attachmentId,
    publicationId,
    fileId,
    order,
    createdAt,
  ];
}
