// ignore_for_file: sort_constructors_first

import 'package:equatable/equatable.dart';
import 'package:locnet_app/features/conversation/subfeatures/group/data/data.dart';

class GroupAdmin extends Equatable {
  const GroupAdmin({
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

  factory GroupAdmin.fromDto(GroupAdminDto dto) {
    return GroupAdmin(
      id: dto.id,
      groupId: dto.groupId,
      userId: dto.userId,
      role: dto.role,
      createdAt: dto.createdAt,
    );
  }

  GroupAdmin copyWith({
    String? id,
    String? groupId,
    String? userId,
    String? role,
    DateTime? createdAt,
  }) {
    return GroupAdmin(
      id: id ?? this.id,
      groupId: groupId ?? this.groupId,
      userId: userId ?? this.userId,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [id, groupId, userId, role, createdAt];
}
