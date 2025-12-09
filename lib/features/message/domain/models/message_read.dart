// ignore_for_file: sort_constructors_first

import 'package:equatable/equatable.dart';
import 'package:locnet_app/features/message/data/data.dart';

class MessageRead extends Equatable {
  const MessageRead({
    required this.id,
    required this.messageId,
    required this.userId,
    required this.readAt,
  });

  final String id;
  final String messageId;
  final String userId;
  final DateTime readAt;

  /// Convert from DTO to domain.
  factory MessageRead.fromDto(MessageReadDto dto) {
    return MessageRead(
      id: dto.messageReadId,
      messageId: dto.messageId,
      userId: dto.userId,
      readAt: dto.readAt,
    );
  }

  /// Convert domain back to DTO.
  MessageReadDto toDto() {
    return MessageReadDto(
      messageReadId: id,
      messageId: messageId,
      userId: userId,
      readAt: readAt,
    );
  }

  MessageRead copyWith({
    String? id,
    String? messageId,
    String? userId,
    DateTime? readAt,
  }) {
    return MessageRead(
      id: id ?? this.id,
      messageId: messageId ?? this.messageId,
      userId: userId ?? this.userId,
      readAt: readAt ?? this.readAt,
    );
  }

  @override
  List<Object?> get props => <Object?>[id, messageId, userId, readAt];
}
