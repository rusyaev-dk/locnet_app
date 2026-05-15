// ignore_for_file: sort_constructors_first

import 'package:equatable/equatable.dart';
import 'package:locnet_app/core/core.dart';

final class ChannelDto extends Equatable {
  const ChannelDto({
    required this.channelId,
    required this.ownerId,
    required this.title,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
    required this.avatarFileId,
    required this.isDeleted,
    required this.deletedAt,
    required this.isPublic,
  });

  final String channelId;
  final String ownerId;
  final String title;
  final String? description;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? avatarFileId;
  final bool isDeleted;
  final DateTime? deletedAt;
  final bool isPublic;

  factory ChannelDto.fromJson(Map<String, dynamic> json) {
    return ChannelDto(
      channelId: json['channelId'] as String,
      ownerId: json['ownerId'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      createdAt: DateTimeFormatter.parse(json['createdAt'] as String),
      updatedAt: DateTimeFormatter.parse(json['updatedAt'] as String),
      avatarFileId: json['avatarFileId'] as String?,
      isDeleted: json['isDeleted'] as bool,
      deletedAt: json['deletedAt'] != null
          ? DateTimeFormatter.parse(json['deletedAt'] as String)
          : null,
      isPublic: json['isPublic'] as bool,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'channelId': channelId,
    'ownerId': ownerId,
    'title': title,
    'description': description,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
    'avatarFileId': avatarFileId,
    'isDeleted': isDeleted,
    'deletedAt': deletedAt?.toIso8601String(),
    'isPublic': isPublic,
  };

  @override
  List<Object?> get props => [
    channelId,
    ownerId,
    title,
    description,
    createdAt,
    updatedAt,
    avatarFileId,
    isDeleted,
    deletedAt,
    isPublic,
  ];
}
