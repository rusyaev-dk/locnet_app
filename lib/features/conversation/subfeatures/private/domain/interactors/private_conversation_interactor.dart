import 'package:locnet_app/features/conversation/domain/domain.dart';
import 'package:locnet_app/features/conversation/subfeatures/private/data/data.dart';

final class PrivateConversationInteractor {
  PrivateConversationInteractor({
    required IPrivateConversationRepo privateConversationRepo,
  }) : _privateConversationRepo = privateConversationRepo;

  final IPrivateConversationRepo _privateConversationRepo;

  Future<Conversation> startConversation({
    required String initiatorId,
    required String recipientId,
  }) async {
    return await _privateConversationRepo.createConversation(
      initiatorId: initiatorId,
      recipientId: recipientId,
    );
  }

  Future<bool> toggleNotifications({
    required String conversationId,
    required String userId,
    required bool newNotificationsStatus,
  }) async {
    return await _privateConversationRepo.toggleNotifications(
      conversationId: conversationId,
      userId: userId,
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
}
