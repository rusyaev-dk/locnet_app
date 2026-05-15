// ignore_for_file: sort_constructors_first

import 'package:equatable/equatable.dart';
import 'package:locnet_app/features/conversation/subfeatures/channel/data/data.dart';

class Channel extends Equatable {
  const Channel({
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

  Channel copyWith({
    String? channelId,
    String? ownerId,
    String? title,
    String? description,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? avatarFileId,
    bool? isDeleted,
    DateTime? deletedAt,
    bool? isPublic,
  }) {
    return Channel(
      channelId: channelId ?? this.channelId,
      ownerId: ownerId ?? this.ownerId,
      title: title ?? this.title,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      avatarFileId: avatarFileId ?? this.avatarFileId,
      isDeleted: isDeleted ?? this.isDeleted,
      deletedAt: deletedAt ?? this.deletedAt,
      isPublic: isPublic ?? this.isPublic,
    );
  }

  factory Channel.fromDto(ChannelDto dto) {
    return Channel(
      channelId: dto.channelId,
      ownerId: dto.ownerId,
      title: dto.title,
      description: dto.description,
      createdAt: dto.createdAt,
      updatedAt: dto.updatedAt,
      avatarFileId: dto.avatarFileId,
      isDeleted: dto.isDeleted,
      deletedAt: dto.deletedAt,
      isPublic: dto.isPublic,
    );
  }

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
