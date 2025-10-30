import 'package:locnet_app/features/conversation/domain/domain.dart';

abstract interface class IConversationRepo {
  Future<List<Conversation>> loadConversations({
    required String userId,
    int page = 1,
  });

  Future<bool> toggleNotifications({
    required String conversationId,
    required String userId,
    required bool newNotificationsStatus,
  });
}
