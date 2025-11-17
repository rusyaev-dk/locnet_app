// ignore_for_file: sort_constructors_first

import 'package:equatable/equatable.dart';

class ConversationDTO extends Equatable {
  const ConversationDTO({
    required this.conversationId,
    required this.createdBy,
    required this.type, // string value: "private", "group", "channel"
    required this.title,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
    this.description,
    this.avatarFileId,
    this.deletedAt,
    this.deletedBy,
  });

  final String conversationId; // uuid
  final String createdBy; // uuid
  final String type; // varchar
  final String title; // varchar
  final String? description; // varchar?
  final String? avatarFileId; // uuid?
  final bool isDeleted; // boolean
  final DateTime? deletedAt; // timestamp?
  final String? deletedBy; // uuid?
  final DateTime createdAt; // timestamp
  final DateTime updatedAt; // timestamp

  factory ConversationDTO.fromJSON(Map<String, dynamic> json) {
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

    return ConversationDTO(
      conversationId: json['conversationId'] as String,
      createdBy: json['createdBy'] as String,
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

  Map<String, dynamic> toJSON() => <String, dynamic>{
    'conversationId': conversationId,
    'createdBy': createdBy,
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

  ConversationDTO copyWith({
    String? conversationId,
    String? createdBy,
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
    return ConversationDTO(
      conversationId: conversationId ?? this.conversationId,
      createdBy: createdBy ?? this.createdBy,
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
    createdBy,
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
