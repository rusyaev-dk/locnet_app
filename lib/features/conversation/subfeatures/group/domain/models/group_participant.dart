// ignore_for_file: sort_constructors_first

import 'package:equatable/equatable.dart';
import 'package:locnet_app/features/conversation/subfeatures/group/group.dart';

class GroupParticipant extends Equatable {
  const GroupParticipant({
    required this.id,
    required this.groupId,
    required this.userId,
    required this.joinedAt,
  });

  final String id;
  final String groupId;
  final String userId;
  final DateTime joinedAt;

  GroupParticipant copyWith({
    String? id,
    String? groupId,
    String? userId,
    DateTime? joinedAt,
  }) {
    return GroupParticipant(
      id: id ?? this.id,
      groupId: groupId ?? this.groupId,
      userId: userId ?? this.userId,
      joinedAt: joinedAt ?? this.joinedAt,
    );
  }

  factory GroupParticipant.fromDto(GroupParticipantDto dto) {
    return GroupParticipant(
      id: dto.id,
      groupId: dto.groupId,
      userId: dto.userId,
      joinedAt: dto.joinedAt,
    );
  }

  @override
  List<Object?> get props => [id, groupId, userId, joinedAt];
}
