import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/conversation/subfeatures/private/data/data.dart';
import 'package:locnet_app/features/conversation/subfeatures/private/domain/domain.dart';

final class PrivateConversationInteractor {
  PrivateConversationInteractor({
    required IPrivateConversationRepo privateConversationRepo,
  }) : _privateConversationRepo = privateConversationRepo;

  final IPrivateConversationRepo _privateConversationRepo;

  Stream<PrivateConversationMessageUpdateRec> get messagesUpdates =>
      _privateConversationRepo.messagesUpdates;

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

  Future<PrivateConversation> getConversationById({
    required String conversationId,
  }) async {
    return await _privateConversationRepo.getPrivateConversation(
      conversationId: conversationId,
    );
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

  Future<PrivateMessage> sendMessage({
    required PrivateMessage message,
  }) async {
    return await _privateConversationRepo.sendMessage(message: message);
  }

  Future<PrivateMessage> editMessage({
    required PrivateMessage newMessage,
  }) async {
    return await _privateConversationRepo.editMessage(
      updatedMessage: newMessage,
    );
  }

  Future<bool> deleteMessage({
    required PrivateMessage message,
    required bool deleteAtRecipient,
  }) async {
    return await _privateConversationRepo.deleteMessage(
      message: message,
      deleteAtRecipient: deleteAtRecipient,
    );
  }
}
