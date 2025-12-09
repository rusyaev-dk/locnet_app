// ignore_for_file: sort_constructors_first

import 'package:equatable/equatable.dart';
import 'package:locnet_app/features/conversation/data/data.dart';
import 'package:locnet_app/features/message/data/data.dart';

class ConversationTileDto extends Equatable {
  const ConversationTileDto({
    required this.conversation,
    this.lastMessage,
    this.companionId,
  });

  final ConversationDto conversation;
  final String? companionId;
  final MessageDto? lastMessage;

  factory ConversationTileDto.fromJson(Map<String, dynamic> json) {
    return ConversationTileDto(
      conversation: ConversationDto.fromJson(
        json['conversation'] as Map<String, dynamic>,
      ),
      lastMessage: json['lastMsg'] != null
          ? MessageDto.fromJson(json['lastMsg'] as Map<String, dynamic>)
          : null,
      companionId: json['companionId'] as String?,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'conversation': conversation.toJson(),
    'lastMsg': lastMessage?.toJson(),
    'companionId': companionId,
  };

  ConversationTileDto copyWith({
    ConversationDto? conversation,
    MessageDto? lastMessage,
    String? companionId,
  }) {
    return ConversationTileDto(
      conversation: conversation ?? this.conversation,
      lastMessage: lastMessage ?? this.lastMessage,
      companionId: companionId ?? this.companionId,
    );
  }

  @override
  List<Object?> get props => <Object?>[conversation, lastMessage, companionId];
}
