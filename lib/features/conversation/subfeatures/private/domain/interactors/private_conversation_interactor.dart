import 'package:locnet_app/features/conversation/data/data.dart';
import 'package:locnet_app/features/conversation/domain/domain.dart';
import 'package:locnet_app/features/conversation/subfeatures/private/data/data.dart';

final class PrivateConversationInteractor {
  PrivateConversationInteractor({
    required IPrivateConversationRepo privateConversationRepo,
    required IConversationRepo conversationRepo,
  }) : _privateConversationRepo = privateConversationRepo,
       _conversationRepo = conversationRepo;

  final IPrivateConversationRepo _privateConversationRepo;
  final IConversationRepo _conversationRepo;

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
    required bool newNotificationsStatus,
  }) async {
    return await _conversationRepo.toggleNotifications(
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
}
