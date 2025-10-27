import 'package:locnet_app/features/conversation/domain/domain.dart';

abstract interface class IPrivateConversationRepo {
  Future<Conversation> createConversation({
    required String initiatorId,
    required String recipientId,
  });

  Future<bool> toggleNotifications({
    required String conversationId,
    required bool newNotificationsStatus,
  });

  Future<bool> deleteConversation({
    required String conversationId,
    required bool deleteAtRecipient,
  });
}
