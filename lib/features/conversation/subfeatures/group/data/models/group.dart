// ignore_for_file: sort_constructors_first, prefer_const_constructors_in_immutables

import 'package:equatable/equatable.dart';
import 'package:locnet_app/core/core.dart';

class GroupDto extends Equatable {
  GroupDto({
    required this.groupId,
    required this.createdById,
    required this.title,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
    required this.avatarFileId,
    required this.isDeleted,
    required this.deletedAt,
    required this.isPublic,
  });

  final String groupId;
  final String createdById;
  final String title;
  final String? description;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? avatarFileId;
  final bool isDeleted;
  final DateTime? deletedAt;
  final bool isPublic;

  GroupDto copyWith({
    String? groupId,
    String? createdById,
    String? title,
    String? description,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? avatarFileId,
    bool? isDeleted,
    DateTime? deletedAt,
    bool? isPublic,
  }) {
    return GroupDto(
      groupId: groupId ?? this.groupId,
      createdById: createdById ?? this.createdById,
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

  factory GroupDto.fromJson(Map<String, dynamic> json) {
    return GroupDto(
      groupId: json['groupId'] as String,
      createdById: json['createdById'] as String,
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
    'groupId': groupId,
    'createdById': createdById,
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
    groupId,
    createdById,
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
