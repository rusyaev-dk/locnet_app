// ignore_for_file: sort_constructors_first

import 'package:equatable/equatable.dart';
import 'package:locnet_app/core/presentation/utils/utils.dart';

class GroupMessageReadDto extends Equatable {
  const GroupMessageReadDto({
    required this.id,
    required this.messageId,
    required this.userId,
    required this.readAt,
  });

  final String id;
  final String messageId;
  final String userId;
  final DateTime readAt;

  factory GroupMessageReadDto.fromJson(Map<String, dynamic> json) {
    return GroupMessageReadDto(
      id: json['id'] as String,
      messageId: json['messageId'] as String,
      userId: json['userId'] as String,
      readAt: DateTimeFormatter.parse(json['readAt'] as String),
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'messageId': messageId,
    'userId': userId,
    'readAt': readAt.toIso8601String(),
  };

  @override
  List<Object?> get props => [id, messageId, userId, readAt];
}
