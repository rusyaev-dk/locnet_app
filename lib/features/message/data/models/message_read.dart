// ignore_for_file: sort_constructors_first

import 'package:equatable/equatable.dart';

class MessageReadDTO extends Equatable {
  const MessageReadDTO({
    required this.messageReadId,
    required this.messageId,
    required this.userId,
    required this.readAt,
  });

  final String messageReadId; // uuid
  final String messageId; // uuid
  final String userId; // uuid
  final DateTime readAt; // timestamp

  factory MessageReadDTO.fromJson(Map<String, dynamic> json) {
    DateTime parseNonNull(dynamic v) {
      if (v is DateTime) return v;
      if (v is int) return DateTime.fromMillisecondsSinceEpoch(v);
      return DateTime.parse(v as String);
    }

    return MessageReadDTO(
      messageReadId: json['messageReadId'] as String,
      messageId: json['messageId'] as String,
      userId: json['userId'] as String,
      readAt: parseNonNull(json['readAt']),
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'messageReadId': messageReadId,
    'messageId': messageId,
    'userId': userId,
    'readAt': readAt.toIso8601String(),
  };

  MessageReadDTO copyWith({
    String? messageReadId,
    String? messageId,
    String? userId,
    DateTime? readAt,
  }) {
    return MessageReadDTO(
      messageReadId: messageReadId ?? this.messageReadId,
      messageId: messageId ?? this.messageId,
      userId: userId ?? this.userId,
      readAt: readAt ?? this.readAt,
    );
  }

  @override
  List<Object?> get props => <Object?>[
    messageReadId,
    messageId,
    userId,
    readAt,
  ];
}
