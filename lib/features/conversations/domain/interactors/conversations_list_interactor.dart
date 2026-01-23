import 'package:locnet_app/features/conversations/data/data.dart';
import 'package:locnet_app/features/conversations/domain/domain.dart';

final class ConversationsListInteractor {
  ConversationsListInteractor({
    required IConversationsListRepo conversationsListRepo,
  }) : _conversationsListRepo = conversationsListRepo;

  final IConversationsListRepo _conversationsListRepo;

  Stream<ConversationsListUpdateRec> get conversationsUpdates =>
      _conversationsListRepo.conversationsUpdates;

  Future<List<ConversationTile>> loadConversations({int page = 1}) async {
    final List<ConversationTile> conversations = await _conversationsListRepo
        .loadConversationsList(page: page);
    return conversations;
  }
}
