// ignore_for_file: sort_constructors_first

import 'package:equatable/equatable.dart';
import 'package:locnet_app/features/conversation/subfeatures/private/data/data.dart';

class PrivateConversation extends Equatable {
  const PrivateConversation({
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

  factory PrivateConversation.fromDto(PrivateConversationDto dto) {
    return PrivateConversation(
      conversationId: dto.conversationId,
      user1Id: dto.user1Id,
      user2Id: dto.user2Id,
      createdAt: dto.createdAt,
      updatedAt: dto.updatedAt,
      isDeleted: dto.isDeleted,
    );
  }

  PrivateConversation copyWith({
    String? conversationId,
    String? user1Id,
    String? user2Id,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isDeleted,
  }) {
    return PrivateConversation(
      conversationId: conversationId ?? this.conversationId,
      user1Id: user1Id ?? this.user1Id,
      user2Id: user2Id ?? this.user2Id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }

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
