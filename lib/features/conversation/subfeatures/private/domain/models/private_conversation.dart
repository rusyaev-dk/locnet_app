// ignore_for_file: sort_constructors_first

import 'package:equatable/equatable.dart';
import 'package:locnet_app/features/conversation/subfeatures/private/data/data.dart';

class PrivateConversation extends Equatable {
  const PrivateConversation({
    required this.id,
    required this.user1Id,
    required this.user2Id,
    required this.createdAt,
    required this.updatedAt,
    required this.isDeleted,
  });

  final String id;
  final String user1Id;
  final String user2Id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isDeleted;

  factory PrivateConversation.fromDto(PrivateConversationDto dto) {
    return PrivateConversation(
      id: dto.conversationId,
      user1Id: dto.user1Id,
      user2Id: dto.user2Id,
      createdAt: dto.createdAt,
      updatedAt: dto.updatedAt,
      isDeleted: dto.isDeleted,
    );
  }

  PrivateConversation copyWith({
    String? id,
    String? user1Id,
    String? user2Id,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isDeleted,
  }) {
    return PrivateConversation(
      id: id ?? this.id,
      user1Id: user1Id ?? this.user1Id,
      user2Id: user2Id ?? this.user2Id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }

  @override
  List<Object?> get props => [
    id,
    user1Id,
    user2Id,
    createdAt,
    updatedAt,
    isDeleted,
  ];
}
