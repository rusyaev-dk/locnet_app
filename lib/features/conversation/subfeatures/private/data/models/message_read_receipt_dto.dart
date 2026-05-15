// ignore_for_file: sort_constructors_first

import 'package:equatable/equatable.dart';
import 'package:locnet_app/core/presentation/utils/utils.dart';

class MessageReadReceiptDto extends Equatable {
  const MessageReadReceiptDto({
    required this.conversationId,
    required this.messageId,
    required this.senderId,
    required this.readerId,
    required this.readAt,
    required this.deliveryStatus,
  });

  final String conversationId;
  final String messageId;
  final String senderId;
  final String readerId;
  final DateTime readAt;
  final String deliveryStatus;

  factory MessageReadReceiptDto.fromJson(Map<String, dynamic> json) {
    return MessageReadReceiptDto(
      conversationId: json['conversationId'] as String,
      messageId: json['messageId'] as String,
      senderId: json['senderId'] as String,
      readerId: json['readerId'] as String,
      readAt: DateTimeFormatter.parse(json['readAt'] as String),
      deliveryStatus: json['deliveryStatus'] as String,
    );
  }

  @override
  List<Object?> get props =>
      [conversationId, messageId, senderId, readerId, readAt, deliveryStatus];
}
