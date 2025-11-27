// ignore_for_file: sort_constructors_first

import 'package:equatable/equatable.dart';
import 'package:locnet_app/features/conversation/domain/domain.dart';
import 'package:locnet_app/features/conversations/data/data.dart';
import 'package:locnet_app/features/message/domain/domain.dart';

class ConversationTile extends Equatable {
  const ConversationTile({
    required this.conversation,
    this.lastMessage,
    this.companionId,
  });

  final Conversation conversation;
  final String? companionId;
  final Message? lastMessage;

  factory ConversationTile.fromDTO(ConversationTileDTO dto) {
    return ConversationTile(
      conversation: Conversation.fromDTO(dto.conversation),
      lastMessage: dto.lastMessage != null
          ? Message.fromDTO(dto.lastMessage!)
          : null,
      companionId: dto.companionId,
    );
  }

  ConversationTile copyWith({
    Conversation? conversation,
    Message? lastMessage,
    String? companionId,
  }) {
    return ConversationTile(
      conversation: conversation ?? this.conversation,
      lastMessage: lastMessage ?? this.lastMessage,
      companionId: companionId ?? this.companionId,
    );
  }

  @override
  List<Object?> get props => <Object?>[conversation, lastMessage, companionId];
}
