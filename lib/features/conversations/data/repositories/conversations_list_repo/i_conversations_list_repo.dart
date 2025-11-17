import 'package:locnet_app/features/conversations/domain/domain.dart';

enum ConversationTileUpdateType { created, updated, deleted }

typedef ConversationsListUpdateRec = ({
  ConversationTileUpdateType kind,
  ConversationTile conversationTile,
});

abstract interface class IConversationsListRepo {
  Future<List<ConversationTile>> loadConversationsList({int page = 1});

  Future<bool> toggleNotifications({
    required String conversationId,
    required bool newNotificationsStatus,
  });

  Stream<ConversationsListUpdateRec> get conversationsUpdates;
}
