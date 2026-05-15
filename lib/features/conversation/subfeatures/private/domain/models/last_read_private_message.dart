// ignore_for_file: sort_constructors_first

import 'package:equatable/equatable.dart';
import 'package:locnet_app/features/conversation/subfeatures/private/data/data.dart';

class LastReadPrivateMessage extends Equatable {
  const LastReadPrivateMessage({
    required this.id,
    required this.userId,
    required this.messageId,
    required this.conversationId,
  });

  final String id;
  final String userId;
  final String messageId;
  final String conversationId;

  factory LastReadPrivateMessage.fromDto(LastReadPrivateMessageDto dto) {
    return LastReadPrivateMessage(
      id: dto.id,
      userId: dto.userId,
      messageId: dto.messageId,
      conversationId: dto.conversationId,
    );
  }

  LastReadPrivateMessage copyWith({
    String? id,
    String? userId,
    String? messageId,
    String? conversationId,
  }) {
    return LastReadPrivateMessage(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      messageId: messageId ?? this.messageId,
      conversationId: conversationId ?? this.conversationId,
    );
  }

  @override
  List<Object?> get props => [id, userId, messageId, conversationId];
}
