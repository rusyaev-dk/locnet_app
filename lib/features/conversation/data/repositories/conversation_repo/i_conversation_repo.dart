import 'package:locnet_app/features/conversation/domain/domain.dart';

abstract interface class IConversationRepo {
  Future<Conversation> getConversationById({required String conversationId});

  Future<bool> toggleNotifications({
    required String conversationId,
    required bool newNotificationsStatus,
  });
}
