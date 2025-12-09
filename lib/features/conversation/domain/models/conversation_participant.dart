// ignore_for_file: sort_constructors_first

import 'package:equatable/equatable.dart';
import 'package:locnet_app/features/conversation/data/data.dart';

class ConversationParticipant extends Equatable {
  const ConversationParticipant({
    required this.id,
    required this.conversationId,
    required this.userId,
    required this.role,
    required this.joinedAt,
    required this.createdAt,
    required this.updatedAt,
    this.lastReadMessageId,
  });

  final String id;
  final String conversationId;
  final String userId;
  final String role; // custom role as free-form string
  final DateTime joinedAt;
  final String? lastReadMessageId;
  final DateTime createdAt;
  final DateTime updatedAt;

  /// Whether participant likely has admin privileges (heuristic).
  bool get isAdminLike =>
      role.toLowerCase().contains('admin') ||
      role.toLowerCase().contains('owner') ||
      role.toLowerCase().contains('moderator');

  /// Convert from DTO.
  factory ConversationParticipant.fromDto(ConversationParticipantDto dto) {
    return ConversationParticipant(
      id: dto.id,
      conversationId: dto.conversationId,
      userId: dto.userId,
      role: dto.role,
      joinedAt: dto.joinedAt,
      lastReadMessageId: dto.lastReadMsgId,
      createdAt: dto.createdAt,
      updatedAt: dto.updatedAt,
    );
  }

  /// Convert back to DTO.
  ConversationParticipantDto toDto() {
    return ConversationParticipantDto(
      id: id,
      conversationId: conversationId,
      userId: userId,
      role: role,
      joinedAt: joinedAt,
      lastReadMsgId: lastReadMessageId,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  ConversationParticipant copyWith({
    String? id,
    String? conversationId,
    String? userId,
    String? role,
    DateTime? joinedAt,
    String? lastReadMessageId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ConversationParticipant(
      id: id ?? this.id,
      conversationId: conversationId ?? this.conversationId,
      userId: userId ?? this.userId,
      role: role ?? this.role,
      joinedAt: joinedAt ?? this.joinedAt,
      lastReadMessageId: lastReadMessageId ?? this.lastReadMessageId,
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
    lastReadMessageId,
    createdAt,
    updatedAt,
  ];
}
