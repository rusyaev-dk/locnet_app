import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/conversation/subfeatures/private/domain/domain.dart';

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

  Stream<PrivateConversationMessageUpdateRec> get messagesUpdates;
}
