// ignore_for_file: sort_constructors_first

import 'package:equatable/equatable.dart';
import 'package:locnet_app/features/conversation/subfeatures/channel/channel.dart';
import 'package:locnet_app/features/message/domain/domain.dart';

class ChannelPublication extends Equatable {
  const ChannelPublication({
    required this.publicationId,
    required this.channelId,
    required this.publishedById,
    required this.text,
    required this.attachments,
    required this.avatarFileId,
    required this.replyToPublicationId,
    required this.isDeleted,
    required this.deletedById,
    required this.createdAt,
    required this.updatedAt,
    required this.deliveryStatus,
    required this.clientPublicationId,
    required this.isPinned,
    required this.editedAt,
  });

  final String publicationId;
  final String channelId;
  final String publishedById;
  final MessageDeliveryStatus deliveryStatus;
  final String? clientPublicationId;
  final String? text;
  final List<ChannelPublicationAttachment> attachments;
  final String? replyToPublicationId;
  final String? avatarFileId;
  final bool isDeleted;
  final bool isPinned;
  final String? deletedById;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? editedAt;
  ChannelPublication copyWith({
    String? publicationId,
    String? channelId,
    String? publishedById,
    String? text,
    List<ChannelPublicationAttachment>? attachments,
    String? avatarFileId,
    String? replyToPublicationId,
    bool? isDeleted,
    String? deletedById,
    DateTime? createdAt,
    DateTime? updatedAt,
    MessageDeliveryStatus? deliveryStatus,
    String? clientPublicationId,
    bool? isPinned,
    DateTime? editedAt,
  }) {
    return ChannelPublication(
      publicationId: publicationId ?? this.publicationId,
      channelId: channelId ?? this.channelId,
      publishedById: publishedById ?? this.publishedById,
      text: text ?? this.text,
      attachments: attachments ?? this.attachments,
      avatarFileId: avatarFileId ?? this.avatarFileId,
      replyToPublicationId: replyToPublicationId ?? this.replyToPublicationId,
      isDeleted: isDeleted ?? this.isDeleted,
      deletedById: deletedById ?? this.deletedById,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deliveryStatus: deliveryStatus ?? this.deliveryStatus,
      clientPublicationId: clientPublicationId ?? this.clientPublicationId,
      isPinned: isPinned ?? this.isPinned,
      editedAt: editedAt ?? this.editedAt,
    );
  }

  factory ChannelPublication.fromDto(ChannelPublicationDto dto) {
    return ChannelPublication(
      publicationId: dto.publicationId,
      channelId: dto.channelId,
      publishedById: dto.publishedById,
      text: dto.text,
      attachments: dto.attachments
          .map(ChannelPublicationAttachment.fromDto)
          .toList(),
      avatarFileId: dto.avatarFileId,
      replyToPublicationId: dto.replyToPublicationId,
      isDeleted: dto.isDeleted,
      deletedById: dto.deletedById,
      createdAt: dto.createdAt,
      updatedAt: dto.updatedAt,
      deliveryStatus: MessageDeliveryStatus.fromString(dto.deliveryStatus),
      clientPublicationId: dto.clientPublicationId,
      isPinned: dto.isPinned,
      editedAt: dto.editedAt,
    );
  }

  @override
  List<Object?> get props => [
    publicationId,
    channelId,
    publishedById,
    text,
    attachments,
    avatarFileId,
    replyToPublicationId,
    isDeleted,
    deletedById,
    createdAt,
    updatedAt,
    deliveryStatus,
    clientPublicationId,
    isPinned,
    editedAt,
  ];
}
