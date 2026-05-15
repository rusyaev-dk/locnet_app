// ignore_for_file: sort_constructors_first

import 'package:equatable/equatable.dart';
import 'package:locnet_app/core/core.dart';

final class ChannelSubscriberDto extends Equatable {
  const ChannelSubscriberDto({
    required this.id,
    required this.userId,
    required this.channelId,
    required this.joinedAt,
  });

  final String id;
  final String userId;
  final String channelId;
  final DateTime joinedAt;

  factory ChannelSubscriberDto.fromJson(Map<String, dynamic> json) {
    return ChannelSubscriberDto(
      id: json['id'] as String,
      userId: json['userId'] as String,
      channelId: json['channelId'] as String,
      joinedAt: DateTimeFormatter.parse(json['joinedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'userId': userId,
    'channelId': channelId,
    'joinedAt': joinedAt.toIso8601String(),
  };

  @override
  List<Object?> get props => [id, userId, channelId, joinedAt];
}
