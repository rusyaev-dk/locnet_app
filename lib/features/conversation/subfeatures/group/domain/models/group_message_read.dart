// ignore_for_file: sort_constructors_first

import 'package:equatable/equatable.dart';
import 'package:locnet_app/features/conversation/subfeatures/group/group.dart';

class GroupMessageRead extends Equatable {
  const GroupMessageRead({
    required this.id,
    required this.messageId,
    required this.userId,
    required this.readAt,
  });

  final String id;
  final String messageId;
  final String userId;
  final DateTime readAt;

  factory GroupMessageRead.fromDto(GroupMessageReadDto dto) {
    return GroupMessageRead(
      id: dto.id,
      messageId: dto.messageId,
      userId: dto.userId,
      readAt: dto.readAt,
    );
  }

  GroupMessageRead copyWith({
    String? id,
    String? messageId,
    String? userId,
    DateTime? readAt,
  }) {
    return GroupMessageRead(
      id: id ?? this.id,
      messageId: messageId ?? this.messageId,
      userId: userId ?? this.userId,
      readAt: readAt ?? this.readAt,
    );
  }

  @override
  List<Object?> get props => [id, messageId, userId, readAt];
}
