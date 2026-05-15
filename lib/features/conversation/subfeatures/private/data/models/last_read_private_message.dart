// ignore_for_file: sort_constructors_first

import 'package:equatable/equatable.dart';

class LastReadPrivateMessageDto extends Equatable {
  const LastReadPrivateMessageDto({
    required this.id,
    required this.userId,
    required this.messageId,
    required this.conversationId,
  });

  final String id;
  final String userId;
  final String messageId;
  final String conversationId;

  factory LastReadPrivateMessageDto.fromJson(Map<String, dynamic> json) {
    return LastReadPrivateMessageDto(
      id: json['id'] as String,
      userId: json['userId'] as String,
      messageId: json['messageId'] as String,
      conversationId: json['conversationId'] as String,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'userId': userId,
    'messageId': messageId,
    'conversationId': conversationId,
  };

  @override
  List<Object?> get props => [id, userId, messageId, conversationId];
}
