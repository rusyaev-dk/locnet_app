// ignore_for_file: sort_constructors_first

import 'package:equatable/equatable.dart';
import 'package:locnet_app/core/core.dart';

class GroupAdminDto extends Equatable {
  const GroupAdminDto({
    required this.id,
    required this.groupId,
    required this.userId,
    required this.role,
    required this.createdAt,
  });

  final String id;
  final String groupId;
  final String userId;
  final String role;
  final DateTime createdAt;

  factory GroupAdminDto.fromJson(Map<String, dynamic> json) {
    return GroupAdminDto(
      id: json['id'] as String,
      groupId: json['groupId'] as String,
      userId: json['userId'] as String,
      role: json['role'] as String,
      createdAt: DateTimeFormatter.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'groupId': groupId,
    'userId': userId,
    'role': role,
    'createdAt': createdAt.toIso8601String(),
  };

  @override
  List<Object?> get props => [id, groupId, userId, role, createdAt];
}
