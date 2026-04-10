import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/conversation/subfeatures/private/data/data.dart';
import 'package:locnet_app/features/conversation/subfeatures/private/domain/domain.dart';

final class PrivateConversationInteractor {
  PrivateConversationInteractor({
    required IPrivateConversationRepo privateConversationRepo,
  }) : _privateConversationRepo = privateConversationRepo;

  final IPrivateConversationRepo _privateConversationRepo;

  Future<bool> toggleNotifications({
    required String conversationId,
    required bool newNotificationsStatus,
  }) async {
    return await _privateConversationRepo.toggleNotifications(
      conversationId: conversationId,
      newNotificationsStatus: newNotificationsStatus,
    );
  }

  Future<bool> deleteConversation({
    required String conversationId,
    required bool deleteAtRecipient,
  }) async {
    return await _privateConversationRepo.deleteConversation(
      conversationId: conversationId,
      deleteAtRecipient: deleteAtRecipient,
    );
  }

  Future<bool> blockCompanion({
    required String companionId,
    required String blockedByUserId,
    required String reason,
  }) async {
    return _privateConversationRepo.blockCompanion(
      companionId: companionId,
      blockedByUserId: blockedByUserId,
      reason: reason,
    );
  }

  Future<User> getCompanion({required String conversationId}) async {
    return await _privateConversationRepo.getCompanion(
      conversationId: conversationId,
    );
  }

  Future<PrivateConversation> getOrCreateByCompanion({
    required String companionId,
  }) async {
    return await _privateConversationRepo.getOrCreateByCompanion(
      companionId: companionId,
    );
  }

  Future<List<PrivateConversation>> listConversations({int page = 1}) async {
    return await _privateConversationRepo.listConversations(page: page);
  }

  Future<List<PrivateMessage>> loadMessagesPage({
    required String conversationId,
    int page = 1,
  }) async {
    return await _privateConversationRepo.loadMessagesPage(
      conversationId: conversationId,
      page: page,
    );
  }

  Stream<PrivateConversationMessageUpdateRec> get messagesUpdates =>
      _privateConversationRepo.messagesUpdates;
}
