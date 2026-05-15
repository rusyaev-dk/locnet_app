// ignore_for_file: sort_constructors_first

import 'package:equatable/equatable.dart';
import 'package:locnet_app/core/core.dart';

class ChannelAdminDto extends Equatable {
  ChannelAdminDto({
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

  factory ChannelAdminDto.fromJson(Map<String, dynamic> json) {
    return ChannelAdminDto(
      id: json['id'] as String,
      channelId: json['channelId'] as String,
      userId: json['userId'] as String,
      role: json['role'] as String,
      createdAt: DateTimeFormatter.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'channelId': channelId,
    'userId': userId,
    'role': role,
    'createdAt': createdAt.toIso8601String(),
  };

  @override
  List<Object?> get props => [id, channelId, userId, role, createdAt];
}
