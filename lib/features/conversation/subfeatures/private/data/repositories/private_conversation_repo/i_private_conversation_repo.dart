import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/message/domain/domain.dart';

enum PrivateConversationMessageUpdateType { created, updated, deleted }

typedef PrivateConversationMessageUpdateRec = ({
  PrivateConversationMessageUpdateType kind,
  Message message,
});

abstract interface class IPrivateConversationRepo {
  Future<bool> blockCompanion({
    required String companionId,
    required String blockedByUserId,
    required String reason,
  });

  Future<bool> deleteConversation({
    required String conversationId,
    required bool deleteAtRecipient,
  });

  Future<User> getCompanion({required String conversationId});

  Future<List<Message>> loadMessagesPage({
    required String conversationId,
    int page = 1,
  });

  Future<Message> sendMessage({
    required String conversationId,
    required String senderId,
    required Message message,
    String? replyToMessageId,
  });

  Future<Message?> editMessage({
    required String messageId,
    required Message newMessage,
  });

  Future<bool> deleteMessage({
    required String messageId,
    required bool deleteAtRecipient,
  });

  Stream<PrivateConversationMessageUpdateRec> get messagesUpdates;
}
