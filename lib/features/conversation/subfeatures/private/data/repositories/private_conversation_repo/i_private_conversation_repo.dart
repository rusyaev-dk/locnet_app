import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/message/domain/domain.dart';

enum PrivateConversationMessageUpdateType { created, updated, deleted }

typedef PrivateConversationMessageUpdateRec = ({
  PrivateConversationMessageUpdateType updateType,
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
    required Message message,
  });

  Future<Message> editMessage({required Message updatedMessage});

  Future<bool> deleteMessage({
    required Message message,
    required bool deleteAtRecipient,
  });

  Stream<PrivateConversationMessageUpdateRec> get messagesUpdates;
}
