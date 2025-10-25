// ignore_for_file: sort_constructors_first

import 'package:equatable/equatable.dart';

class ConversationParticipantDTO extends Equatable {
  const ConversationParticipantDTO({
    required this.id,
    required this.conversationId,
    required this.userId,
    required this.role, // string, see ConversationRole
    required this.joinedAt,
    required this.createdAt,
    required this.updatedAt,
    this.lastReadMsgId, // uuid?
  });

  final String id; // uuid
  final String conversationId; // uuid
  final String userId; // uuid
  final String role; // varchar
  final DateTime joinedAt; // timestamp
  final String? lastReadMsgId; // uuid?
  final DateTime createdAt; // timestamp
  final DateTime updatedAt; // timestamp

  factory ConversationParticipantDTO.fromJson(Map<String, dynamic> json) {
    DateTime parse(dynamic v) {
      if (v is DateTime) return v;
      if (v is int) return DateTime.fromMillisecondsSinceEpoch(v);
      return DateTime.parse(v as String);
    }

    return ConversationParticipantDTO(
      id: json['id'] as String,
      conversationId: json['conversationId'] as String,
      userId: json['userId'] as String,
      role: json['role'] as String,
      joinedAt: parse(json['joinedAt']),
      lastReadMsgId: json['lastReadMsgId'] as String?,
      createdAt: parse(json['createdAt']),
      updatedAt: parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'conversationId': conversationId,
    'userId': userId,
    'role': role,
    'joinedAt': joinedAt.toIso8601String(),
    'lastReadMsgId': lastReadMsgId,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };

  ConversationParticipantDTO copyWith({
    String? id,
    String? conversationId,
    String? userId,
    String? role,
    DateTime? joinedAt,
    String? lastReadMsgId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ConversationParticipantDTO(
      id: id ?? this.id,
      conversationId: conversationId ?? this.conversationId,
      userId: userId ?? this.userId,
      role: role ?? this.role,
      joinedAt: joinedAt ?? this.joinedAt,
      lastReadMsgId: lastReadMsgId ?? this.lastReadMsgId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => <Object?>[
    id,
    conversationId,
    userId,
    role,
    joinedAt,
    lastReadMsgId,
    createdAt,
    updatedAt,
  ];
}
