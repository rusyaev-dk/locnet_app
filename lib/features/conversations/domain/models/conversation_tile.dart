// ignore_for_file: sort_constructors_first

import 'package:equatable/equatable.dart';
import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/conversation/domain/domain.dart';
import 'package:locnet_app/features/conversations/data/data.dart';
import 'package:locnet_app/features/message/domain/domain.dart';

class ConversationTile extends Equatable {
  const ConversationTile({
    required this.conversation,
    this.lastMessage,
    this.companion,
  });

  final Conversation conversation;
  final User? companion;
  final Message? lastMessage;

  factory ConversationTile.fromDto(ConversationTileDto dto) {
    return ConversationTile(
      conversation: Conversation.fromDto(dto.conversation),
      lastMessage: dto.lastMessage != null
          ? Message.fromDto(dto.lastMessage!)
          : null,
      companion: dto.companion != null ? User.fromDto(dto.companion!) : null,
    );
  }

  ConversationTile copyWith({
    Conversation? conversation,
    Message? lastMessage,
    User? companion,
  }) {
    return ConversationTile(
      conversation: conversation ?? this.conversation,
      lastMessage: lastMessage ?? this.lastMessage,
      companion: companion ?? this.companion,
    );
  }

  @override
  List<Object?> get props => <Object?>[conversation, lastMessage, companion];
}
