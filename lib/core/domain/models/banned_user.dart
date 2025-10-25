// ignore_for_file: sort_constructors_first

import 'package:equatable/equatable.dart';
import 'package:locnet_app/core/data/data.dart';
import 'package:locnet_app/core/domain/domain.dart';

class BannedUser extends Equatable {
  const BannedUser({
    required this.id,
    required this.userId,
    required this.scope,
    required this.bannedByUserId,
    required this.createdAt,
    this.conversationId,
    this.reason,
  });

  final String id;
  final String userId;
  final BanScope scope;
  final String bannedByUserId;
  final String? conversationId;
  final String? reason;
  final DateTime createdAt;

  /// Convenience flags for UI/logic.
  bool get isGlobal => scope == BanScope.global;
  bool get isConversation => scope == BanScope.conversation;

  /// Convert from DTO to domain.
  factory BannedUser.fromDTO(BannedUserDTO dto) {
    return BannedUser(
      id: dto.id,
      userId: dto.userId,
      scope: BanScope.fromString(dto.scope),
      bannedByUserId: dto.bannedBy,
      conversationId: dto.conversationId,
      reason: dto.reason,
      createdAt: dto.createdAt,
    );
  }

  /// Convert domain back to DTO.
  BannedUserDTO toDTO() {
    return BannedUserDTO(
      id: id,
      userId: userId,
      scope: scope.value,
      bannedBy: bannedByUserId,
      conversationId: conversationId,
      reason: reason,
      createdAt: createdAt,
    );
  }

  BannedUser copyWith({
    String? id,
    String? userId,
    BanScope? scope,
    String? bannedByUserId,
    String? conversationId,
    String? reason,
    DateTime? createdAt,
  }) {
    return BannedUser(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      scope: scope ?? this.scope,
      bannedByUserId: bannedByUserId ?? this.bannedByUserId,
      conversationId: conversationId ?? this.conversationId,
      reason: reason ?? this.reason,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => <Object?>[
    id,
    userId,
    scope,
    bannedByUserId,
    conversationId,
    reason,
    createdAt,
  ];
}
