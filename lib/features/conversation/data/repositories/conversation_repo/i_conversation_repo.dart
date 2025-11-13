import 'package:locnet_app/features/conversation/domain/domain.dart';

enum ConversationUpdateType { created, updated, deleted }

typedef ConversationsUpdateRec = ({
  ConversationUpdateType kind,
  Conversation conversation,
});

abstract interface class IConversationRepo {
  Future<List<Conversation>> loadConversations({int page = 1});

  Future<bool> toggleNotifications({
    required String conversationId,
    required bool newNotificationsStatus,
  });

  Stream<ConversationsUpdateRec> get conversationsUpdates;
}
