// ignore_for_file: sort_constructors_first

import 'package:equatable/equatable.dart';
import 'package:locnet_app/features/conversation/subfeatures/channel/data/data.dart';

class ChannelAdmin extends Equatable {
  const ChannelAdmin({
    required this.id,
    required this.channelId,
    required this.userId,
    required this.role,
    required this.createdAt,
  });

  final String id;
  final String channelId;
  final String userId;
  final String role;
  final DateTime createdAt;

  ChannelAdmin copyWith({
    String? id,
    String? channelId,
    String? userId,
    String? role,
    DateTime? createdAt,
  }) {
    return ChannelAdmin(
      id: id ?? this.id,
      channelId: channelId ?? this.channelId,
      userId: userId ?? this.userId,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory ChannelAdmin.fromDto(ChannelAdminDto dto) {
    return ChannelAdmin(
      id: dto.id,
      channelId: dto.channelId,
      userId: dto.userId,
      role: dto.role,
      createdAt: dto.createdAt,
    );
  }

  @override
  List<Object?> get props => [id, channelId, userId, role, createdAt];
}
