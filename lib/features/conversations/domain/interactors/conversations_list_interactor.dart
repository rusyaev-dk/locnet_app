import 'package:locnet_app/features/conversation/data/data.dart';
import 'package:locnet_app/features/conversation/domain/domain.dart';

final class ConversationsListInteractor {
  ConversationsListInteractor({required IConversationRepo conversationRepo})
    : _conversationRepo = conversationRepo;

  final IConversationRepo _conversationRepo;

  Future<List<Conversation>> loadConversations({int page = 1}) async {
    final List<Conversation> conversations = await _conversationRepo
        .loadConversations(page: page);
    return conversations;
  }
}
