import 'package:locnet_app/features/conversations/domain/domain.dart';

enum ConversationTileUpdateType { created, updated, deleted }

typedef ConversationsListUpdateRec = ({
  ConversationTileUpdateType updateType,
  ConversationTile conversationTile,
});

abstract interface class IConversationsListRepo {
  Future<List<ConversationTile>> loadConversationsList({int page = 1});

  Stream<ConversationsListUpdateRec> get conversationsUpdates;
}
