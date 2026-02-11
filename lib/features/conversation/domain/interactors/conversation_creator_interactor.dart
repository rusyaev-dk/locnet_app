import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/conversation/domain/domain.dart';

final class ConversationCreatorInteractor {
  ConversationCreatorInteractor({required ILogger logger}) : _logger = logger;

  final ILogger _logger;

  Future<bool> createConversation({
    required ConversationType type,
    required String title,
    String? description,
    List<String> participantIds = const [],
  }) async {
    _logger.info("Creating conversation");
    return true;
  }
}
