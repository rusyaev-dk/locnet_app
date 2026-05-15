// ignore_for_file: sort_constructors_first

import 'package:equatable/equatable.dart';
import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/conversation/subfeatures/channel/data/data.dart';

final class ChannelPublicationDto extends Equatable {
  const ChannelPublicationDto({
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
  final String deliveryStatus;
  final String? clientPublicationId;
  final String? text;
  final List<ChannelPublicationAttachmentDto> attachments;
  final String? avatarFileId;
  final String? replyToPublicationId;
  final bool isDeleted;
  final String? deletedById;
  final bool isPinned;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? editedAt;
  factory ChannelPublicationDto.fromJson(Map<String, dynamic> json) {
    return ChannelPublicationDto(
      publicationId: json['id'] as String,
      channelId: json['channelId'] as String,
      publishedById: json['publishedById'] as String,
      text: json['text'] as String?,
      attachments:
          (json['attachments'] as List<dynamic>?)
              ?.map(
                (e) => ChannelPublicationAttachmentDto.fromJson(
                  e as Map<String, dynamic>,
                ),
              )
              .toList() ??
          const <ChannelPublicationAttachmentDto>[],
      avatarFileId: json['avatarFileId'] as String?,
      replyToPublicationId: json['replyToPublicationId'] as String?,
      isDeleted: json['isDeleted'] as bool,
      deletedById: json['deletedById'] as String?,
      createdAt: DateTimeFormatter.parse(json['createdAt'] as String),
      updatedAt: DateTimeFormatter.parse(json['updatedAt'] as String),
      deliveryStatus: json['deliveryStatus'] as String,
      clientPublicationId: json['clientPublicationId'] as String?,
      isPinned: json['isPinned'] as bool,
      editedAt: json['editedAt'] != null
          ? DateTimeFormatter.parse(json['editedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': publicationId,
    'channelId': channelId,
    'publishedById': publishedById,
    'text': text,
    'attachments': attachments
        .map((ChannelPublicationAttachmentDto e) => e.toJson())
        .toList(),
    'avatarFileId': avatarFileId,
    'replyToPublicationId': replyToPublicationId,
    'isDeleted': isDeleted,
    'deletedById': deletedById,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
    'deliveryStatus': deliveryStatus,
    'clientPublicationId': clientPublicationId,
    'isPinned': isPinned,
    'editedAt': editedAt?.toIso8601String(),
  };

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
