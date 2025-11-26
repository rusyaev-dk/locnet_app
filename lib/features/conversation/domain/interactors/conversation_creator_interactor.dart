import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/conversation/data/data.dart';
import 'package:locnet_app/features/conversation/domain/domain.dart';

final class ConversationCreatorInteractor {
  ConversationCreatorInteractor({
    required IConversationRepo conversationRepo,
    required ILogger logger,
  }) : _conversationRepo = conversationRepo,
       _logger = logger;

  final IConversationRepo _conversationRepo;
  final ILogger _logger;

  Future<bool> createConversation({
    required ConversationType type,
    required String title,
    String? description,
    List<String> participantIds = const [],
  }) async {
    _conversationRepo.hashCode;
    _logger.info("Creating conversation");
    return true;
  }
}
