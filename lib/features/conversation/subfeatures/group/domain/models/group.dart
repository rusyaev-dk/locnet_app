// ignore_for_file: sort_constructors_first

import 'package:equatable/equatable.dart';
import 'package:locnet_app/features/conversation/subfeatures/group/group.dart';

class Group extends Equatable {
  const Group({
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

  Group copyWith({
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
    return Group(
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

  factory Group.fromDto(GroupDto dto) {
    return Group(
      groupId: dto.groupId,
      createdById: dto.createdById,
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
