// ignore_for_file: sort_constructors_first

import 'package:equatable/equatable.dart';
import 'package:locnet_app/features/message/data/data.dart';
import 'package:locnet_app/features/conversation/data/data.dart';

class ConversationTileDTO extends Equatable {
  const ConversationTileDTO({required this.conversation, this.lastMessage});

  final ConversationDTO conversation;
  final MessageDTO? lastMessage;

  factory ConversationTileDTO.fromJSON(Map<String, dynamic> json) {
    return ConversationTileDTO(
      conversation: ConversationDTO.fromJSON(
        json['conversation'] as Map<String, dynamic>,
      ),
      lastMessage: json['lastMsg'] != null
          ? MessageDTO.fromJSON(json['lastMsg'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJSON() => <String, dynamic>{
    'conversation': conversation.toJSON(),
    'lastMsg': lastMessage?.toJSON(),
  };

  ConversationTileDTO copyWith({
    ConversationDTO? conversation,
    MessageDTO? lastMessage,
  }) {
    return ConversationTileDTO(
      conversation: conversation ?? this.conversation,
      lastMessage: lastMessage ?? this.lastMessage,
    );
  }

  @override
  List<Object?> get props => <Object?>[conversation, lastMessage];
}
