// ignore_for_file: sort_constructors_first

import 'package:equatable/equatable.dart';

class BannedUserDto extends Equatable {
  const BannedUserDto({
    required this.id,
    required this.userId,
    required this.scope, // "global" | "conversation"
    required this.bannedBy,
    required this.createdAt,
    this.conversationId, // nullable for global scope
    this.reason,
  });

  final String id; // uuid
  final String userId; // uuid
  final String scope; // enum as string
  final String bannedBy; // uuid
  final String? conversationId; // uuid?
  final String? reason; // text?
  final DateTime createdAt; // timestamp

  factory BannedUserDto.fromJson(Map<String, dynamic> json) {
    DateTime parse(dynamic v) {
      if (v is DateTime) return v;
      if (v is int) return DateTime.fromMillisecondsSinceEpoch(v);
      return DateTime.parse(v as String);
    }

    return BannedUserDto(
      id: json['id'] as String,
      userId: json['userId'] as String,
      scope: json['scope'] as String,
      bannedBy: json['bannedBy'] as String,
      conversationId: json['conversationId'] as String?,
      reason: json['reason'] as String?,
      createdAt: parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'userId': userId,
    'scope': scope,
    'bannedBy': bannedBy,
    'conversationId': conversationId,
    'reason': reason,
    'createdAt': createdAt.toIso8601String(),
  };

  BannedUserDto copyWith({
    String? id,
    String? userId,
    String? scope,
    String? bannedBy,
    String? conversationId,
    String? reason,
    DateTime? createdAt,
  }) {
    return BannedUserDto(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      scope: scope ?? this.scope,
      bannedBy: bannedBy ?? this.bannedBy,
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
    bannedBy,
    conversationId,
    reason,
    createdAt,
  ];
}
