import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/conversation/subfeatures/private/domain/domain.dart';

enum PrivateConversationMessageUpdateType { created, updated, deleted }

typedef PrivateConversationMessageUpdateRec = ({
  PrivateConversationMessageUpdateType updateType,
  PrivateMessage message,
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

  Future<PrivateConversation> getPrivateConversation({
    required String conversationId,
  });

  Future<User> getCompanion({required String conversationId});

  Future<bool> toggleNotifications({
    required String conversationId,
    required bool newNotificationsStatus,
  });

  Future<List<PrivateMessage>> loadMessagesPage({
    required String conversationId,
    int page = 1,
  });

  Future<PrivateMessage> sendMessage({
    required PrivateMessage message,
  });

  Future<PrivateMessage> editMessage({
    required PrivateMessage updatedMessage,
  });

  Future<bool> deleteMessage({
    required PrivateMessage message,
    required bool deleteAtRecipient,
  });

  Stream<PrivateConversationMessageUpdateRec> get messagesUpdates;
}
