// ignore_for_file: sort_constructors_first

import 'package:equatable/equatable.dart';
import 'package:locnet_app/features/conversation/data/data.dart';
import 'package:locnet_app/features/conversation/domain/domain.dart';

class Conversation extends Equatable {
  const Conversation({
    required this.id,
    required this.createdByUserId,
    required this.type,
    required this.title,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
    this.description,
    this.avatarFileId,
    this.deletedAt,
    this.deletedByUserId,
  });

  final String id;
  final String createdByUserId;
  final ConversationType type;
  final String title;
  final String? description;
  final String? avatarFileId;
  final bool isDeleted;
  final DateTime? deletedAt;
  final String? deletedByUserId;
  final DateTime createdAt;
  final DateTime updatedAt;

  /// Convenience flag for UI/filters.
  bool get isActive => !isDeleted;

  /// Convert from DTO to domain.
  factory Conversation.fromDTO(ConversationDTO dto) {
    return Conversation(
      id: dto.conversationId,
      createdByUserId: dto.createdBy,
      type: ConversationType.fromString(dto.type),
      title: dto.title,
      description: dto.description,
      avatarFileId: dto.avatarFileId,
      isDeleted: dto.isDeleted,
      deletedAt: dto.deletedAt,
      deletedByUserId: dto.deletedBy,
      createdAt: dto.createdAt,
      updatedAt: dto.updatedAt,
    );
  }

  Conversation copyWith({
    String? id,
    String? createdByUserId,
    ConversationType? type,
    String? title,
    String? description,
    String? avatarFileId,
    bool? isDeleted,
    DateTime? deletedAt,
    String? deletedByUserId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Conversation(
      id: id ?? this.id,
      createdByUserId: createdByUserId ?? this.createdByUserId,
      type: type ?? this.type,
      title: title ?? this.title,
      description: description ?? this.description,
      avatarFileId: avatarFileId ?? this.avatarFileId,
      isDeleted: isDeleted ?? this.isDeleted,
      deletedAt: deletedAt ?? this.deletedAt,
      deletedByUserId: deletedByUserId ?? this.deletedByUserId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => <Object?>[
    id,
    createdByUserId,
    type,
    title,
    description,
    avatarFileId,
    isDeleted,
    deletedAt,
    deletedByUserId,
    createdAt,
    updatedAt,
  ];
}
