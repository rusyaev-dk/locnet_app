import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/conversation/data/data.dart';
import 'package:locnet_app/features/conversation/domain/domain.dart';
import 'package:locnet_app/features/conversation/subfeatures/private/data/data.dart';
import 'package:locnet_app/features/message/domain/domain.dart';

final class PrivateConversationInteractor {
  PrivateConversationInteractor({
    required IPrivateConversationRepo privateConversationRepo,
    required IConversationRepo conversationRepo,
  }) : _privateConversationRepo = privateConversationRepo,
       _conversationRepo = conversationRepo;

  final IPrivateConversationRepo _privateConversationRepo;
  final IConversationRepo _conversationRepo;

  Stream<PrivateConversationMessageUpdateRec> get messagesUpdates =>
      _privateConversationRepo.messagesUpdates;

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

  Future<User> getCompanion({required String conversationId}) async {
    return await _privateConversationRepo.getCompanion(
      conversationId: conversationId,
    );
  }

  Future<Conversation> getConversationById({
    required String conversationId,
  }) async {
    return await _conversationRepo.getConversationById(
      conversationId: conversationId,
    );
  }

  Future<List<Message>> loadMessagesPage({
    required String conversationId,
    int page = 1,
  }) async {
    return await _privateConversationRepo.loadMessagesPage(
      conversationId: conversationId,
      page: page,
    );
  }

  Future<Message> sendMessage({
    required String conversationId,
    required String senderId,
    required Message message,
    String? replyToMessageId,
  }) async {
    return await _privateConversationRepo.sendMessage(
      conversationId: conversationId,
      senderId: senderId,
      message: message,
      replyToMessageId: replyToMessageId,
    );
  }

  Future<Message?> editMessage({
    required String messageId,
    required Message newMessage,
  }) async {
    return await _privateConversationRepo.editMessage(
      messageId: messageId,
      newMessage: newMessage,
    );
  }

  Future<bool> deleteMessage({
    required String messageId,
    required bool deleteAtRecipient,
  }) async {
    return await _privateConversationRepo.deleteMessage(
      messageId: messageId,
      deleteAtRecipient: deleteAtRecipient,
    );
  }
}
