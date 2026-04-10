// ignore_for_file: sort_constructors_first, prefer_const_constructors_in_immutables

import 'package:equatable/equatable.dart';
import 'package:locnet_app/core/presentation/utils/utils.dart';

class PrivateConversationDto extends Equatable {
  PrivateConversationDto({
    required this.conversationId,
    required this.user1Id,
    required this.user2Id,
    required this.createdAt,
    required this.updatedAt,
    required this.isDeleted,
  });

  final String conversationId;
  final String user1Id;
  final String user2Id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isDeleted;

  PrivateConversationDto copyWith({
    String? conversationId,
    String? user1Id,
    String? user2Id,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isDeleted,
  }) {
    return PrivateConversationDto(
      conversationId: conversationId ?? this.conversationId,
      user1Id: user1Id ?? this.user1Id,
      user2Id: user2Id ?? this.user2Id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }

  factory PrivateConversationDto.fromJson(Map<String, dynamic> json) {
    final String? createdAtRaw = json['createdAt'] as String?;
    final String? updatedAtRaw = json['updatedAt'] as String?;
    final DateTime now = DateTime.now();

    return PrivateConversationDto(
      conversationId: (json['conversationId'] ?? json['id']) as String,
      user1Id: (json['user1Id'] ?? json['user1']) as String,
      user2Id: (json['user2Id'] ?? json['user2']) as String,
      createdAt: createdAtRaw != null && createdAtRaw.isNotEmpty
          ? DateTimeFormatter.parse(createdAtRaw)
          : now,
      updatedAt: updatedAtRaw != null && updatedAtRaw.isNotEmpty
          ? DateTimeFormatter.parse(updatedAtRaw)
          : now,
      isDeleted: (json['isDeleted'] ?? false) as bool,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'conversationId': conversationId,
    'user1Id': user1Id,
    'user2Id': user2Id,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
    'isDeleted': isDeleted,
  };

  @override
  List<Object?> get props => [
    conversationId,
    user1Id,
    user2Id,
    createdAt,
    updatedAt,
    isDeleted,
  ];
}
