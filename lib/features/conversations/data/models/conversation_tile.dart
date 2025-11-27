// ignore_for_file: sort_constructors_first

import 'package:equatable/equatable.dart';
import 'package:locnet_app/features/message/data/data.dart';
import 'package:locnet_app/features/conversation/data/data.dart';

class ConversationTileDTO extends Equatable {
  const ConversationTileDTO({
    required this.conversation,
    this.lastMessage,
    this.companionId,
  });

  final ConversationDTO conversation;
  final String? companionId;
  final MessageDTO? lastMessage;

  factory ConversationTileDTO.fromJSON(Map<String, dynamic> json) {
    return ConversationTileDTO(
      conversation: ConversationDTO.fromJSON(
        json['conversation'] as Map<String, dynamic>,
      ),
      lastMessage: json['lastMsg'] != null
          ? MessageDTO.fromJSON(json['lastMsg'] as Map<String, dynamic>)
          : null,
      companionId: json['companionId'] as String?,
    );
  }

  Map<String, dynamic> toJSON() => <String, dynamic>{
    'conversation': conversation.toJSON(),
    'lastMsg': lastMessage?.toJSON(),
    'companionId': companionId,
  };

  ConversationTileDTO copyWith({
    ConversationDTO? conversation,
    MessageDTO? lastMessage,
    String? companionId,
  }) {
    return ConversationTileDTO(
      conversation: conversation ?? this.conversation,
      lastMessage: lastMessage ?? this.lastMessage,
      companionId: companionId ?? this.companionId,
    );
  }

  @override
  List<Object?> get props => <Object?>[conversation, lastMessage, companionId];
}
