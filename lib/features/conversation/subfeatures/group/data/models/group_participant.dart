// ignore_for_file: sort_constructors_first

import 'package:equatable/equatable.dart';
import 'package:locnet_app/core/presentation/utils/utils.dart';

class GroupParticipantDto extends Equatable {
  const GroupParticipantDto({
    required this.id,
    required this.groupId,
    required this.userId,
    required this.joinedAt,
  });

  final String id;
  final String groupId;
  final String userId;
  final DateTime joinedAt;

  factory GroupParticipantDto.fromJson(Map<String, dynamic> json) {
    return GroupParticipantDto(
      id: json['id'] as String,
      groupId: json['groupId'] as String,
      userId: json['userId'] as String,
      joinedAt: DateTimeFormatter.parse(json['joinedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'groupId': groupId,
    'userId': userId,
    'joinedAt': joinedAt.toIso8601String(),
  };

  @override
  List<Object?> get props => [id, groupId, userId, joinedAt];
}
