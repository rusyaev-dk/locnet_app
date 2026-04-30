import 'package:locnet_app/features/conversation/subfeatures/private/domain/domain.dart';
import 'package:locnet_app/features/message/subfeatures/private_message/data/repositories/private_message_repo/i_private_message_repo.dart';

final class PrivateMessageInteractor {
  PrivateMessageInteractor({required IPrivateMessageRepo messageRepo})
    : _messageRepo = messageRepo;

  final IPrivateMessageRepo _messageRepo;

  Future<PrivateMessage> sendMessage({required PrivateMessage message}) async {
    return _messageRepo.sendMessage(message: message);
  }

  Future<PrivateMessage> editMessage({
    required PrivateMessage updatedMessage,
  }) async {
    return _messageRepo.editMessage(updatedMessage: updatedMessage);
  }

  Future<bool> deleteMessage({required PrivateMessage message}) async {
    return _messageRepo.deleteMessage(message: message);
  }

  Future<PrivateMessage> toggleMessagePin({
    required PrivateMessage message,
    required bool isPinned,
  }) async {
    return _messageRepo.toggleMessagePin(message: message, isPinned: isPinned);
  }

  Future<List<LastReadPrivateMessage>> loadMessageReads({
    required String conversationId,
    required String messageId,
  }) async {
    return _messageRepo.loadMessageReads(
      conversationId: conversationId,
      messageId: messageId,
    );
  }
}
