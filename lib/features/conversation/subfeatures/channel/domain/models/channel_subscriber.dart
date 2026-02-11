// ignore_for_file: sort_constructors_first

import 'package:equatable/equatable.dart';
import 'package:locnet_app/features/conversation/subfeatures/channel/data/data.dart';

class ChannelSubscriber extends Equatable {
  const ChannelSubscriber({
    required this.subscribeId,
    required this.userId,
    required this.channelId,
    required this.joinedAt,
  });

  final String subscribeId;
  final String userId;
  final String channelId;
  final DateTime joinedAt;

  ChannelSubscriber copyWith({
    String? subscribeId,
    String? userId,
    String? channelId,
    DateTime? joinedAt,
  }) {
    return ChannelSubscriber(
      subscribeId: subscribeId ?? this.subscribeId,
      userId: userId ?? this.userId,
      channelId: channelId ?? this.channelId,
      joinedAt: joinedAt ?? this.joinedAt,
    );
  }

  factory ChannelSubscriber.fromDto(ChannelSubscriberDto dto) {
    return ChannelSubscriber(
      subscribeId: dto.id,
      userId: dto.userId,
      channelId: dto.channelId,
      joinedAt: dto.joinedAt,
    );
  }

  @override
  List<Object?> get props => [subscribeId, userId, channelId, joinedAt];
}
