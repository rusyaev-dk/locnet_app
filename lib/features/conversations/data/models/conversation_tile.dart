// ignore_for_file: sort_constructors_first

import 'package:equatable/equatable.dart';
import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/conversation/data/data.dart';
import 'package:locnet_app/features/message/data/data.dart';

class ConversationTileDto extends Equatable {
  const ConversationTileDto({
    required this.conversation,
    this.lastMessage,
    this.companion,
  });

  final ConversationDto conversation;
  final UserDto? companion;
  final MessageDto? lastMessage;

  factory ConversationTileDto.fromJson(Map<String, dynamic> json) {
    return ConversationTileDto(
      conversation: ConversationDto.fromJson(
        json['conversation'] as Map<String, dynamic>,
      ),
      lastMessage: json['lastMsg'] != null
          ? MessageDto.fromJson(json['lastMsg'] as Map<String, dynamic>)
          : null,
      companion: json['companion'] != null
          ? UserDto.fromJson(json['companion'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'conversation': conversation.toJson(),
    'lastMsg': lastMessage?.toJson(),
    'companion': companion?.toJson(),
  };

  ConversationTileDto copyWith({
    ConversationDto? conversation,
    MessageDto? lastMessage,
    UserDto? companion,
  }) {
    return ConversationTileDto(
      conversation: conversation ?? this.conversation,
      lastMessage: lastMessage ?? this.lastMessage,
      companion: companion ?? this.companion,
    );
  }

  @override
  List<Object?> get props => <Object?>[conversation, lastMessage, companion];
}
