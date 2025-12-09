// ignore_for_file: sort_constructors_first

import 'package:equatable/equatable.dart';

class ConversationDto extends Equatable {
  const ConversationDto({
    required this.conversationId,
    required this.initiatorId,
    required this.type,
    required this.title,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
    this.description,
    this.avatarFileId,
    this.deletedAt,
    this.deletedBy,
  });

  final String conversationId;
  final String initiatorId;
  final String type;
  final String title;
  final String? description;
  final String? avatarFileId;
  final bool isDeleted;
  final DateTime? deletedAt;
  final String? deletedBy;
  final DateTime createdAt;
  final DateTime updatedAt;

  factory ConversationDto.fromJson(Map<String, dynamic> json) {
    DateTime? parseNullable(dynamic v) {
      if (v == null) return null;
      if (v is DateTime) return v;
      if (v is int) return DateTime.fromMillisecondsSinceEpoch(v);
      return DateTime.parse(v as String);
    }

    DateTime parseNonNull(dynamic v) {
      if (v is DateTime) return v;
      if (v is int) return DateTime.fromMillisecondsSinceEpoch(v);
      return DateTime.parse(v as String);
    }

    return ConversationDto(
      conversationId: json['conversationId'] as String,
      initiatorId: json['initiatorId'] as String,
      type: json['type'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      avatarFileId: json['avatarFileId'] as String?,
      isDeleted: json['isDeleted'] as bool,
      deletedAt: parseNullable(json['deletedAt']),
      deletedBy: json['deletedBy'] as String?,
      createdAt: parseNonNull(json['createdAt']),
      updatedAt: parseNonNull(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'conversationId': conversationId,
    'initiatorId': initiatorId,
    'type': type,
    'title': title,
    'description': description,
    'avatarFileId': avatarFileId,
    'isDeleted': isDeleted,
    'deletedAt': deletedAt?.toIso8601String(),
    'deletedBy': deletedBy,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };

  ConversationDto copyWith({
    String? conversationId,
    String? initiatorId,
    String? type,
    String? title,
    String? description,
    String? avatarFileId,
    bool? isDeleted,
    DateTime? deletedAt,
    String? deletedBy,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ConversationDto(
      conversationId: conversationId ?? this.conversationId,
      initiatorId: initiatorId ?? this.initiatorId,
      type: type ?? this.type,
      title: title ?? this.title,
      description: description ?? this.description,
      avatarFileId: avatarFileId ?? this.avatarFileId,
      isDeleted: isDeleted ?? this.isDeleted,
      deletedAt: deletedAt ?? this.deletedAt,
      deletedBy: deletedBy ?? this.deletedBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => <Object?>[
    conversationId,
    initiatorId,
    type,
    title,
    description,
    avatarFileId,
    isDeleted,
    deletedAt,
    deletedBy,
    createdAt,
    updatedAt,
  ];
}
