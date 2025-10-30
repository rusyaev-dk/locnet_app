import 'package:locnet_app/features/conversation/data/data.dart';
import 'package:locnet_app/features/conversation/domain/domain.dart';

final class FeedInteractor {
  FeedInteractor({required IConversationRepo conversationRepo})
    : _conversationRepo = conversationRepo;

  final IConversationRepo _conversationRepo;

  Future<List<Conversation>> loadConversations({
    required String userId,
    int page = 1,
  }) async {
    return await _conversationRepo.loadConversations(userId: userId);
  }
}
