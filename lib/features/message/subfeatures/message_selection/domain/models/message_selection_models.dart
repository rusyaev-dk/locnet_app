import 'package:equatable/equatable.dart';

typedef MessageId = String;

enum ConversationKind {
  private,
  group,
  channel,
}

class MessageSelectionKey extends Equatable {
  const MessageSelectionKey({
    required this.conversationId,
    required this.conversationKind,
    required this.messageId,
  });

  final String conversationId;
  final ConversationKind conversationKind;
  final MessageId messageId;

  @override
  List<Object> get props => <Object>[
        conversationId,
        conversationKind,
        messageId,
      ];
}

