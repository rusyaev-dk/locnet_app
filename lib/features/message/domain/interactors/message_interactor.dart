import 'package:locnet_app/features/message/data/data.dart';
import 'package:locnet_app/features/message/domain/domain.dart';

final class MessageInteractor {
  MessageInteractor({required IMessageRepo messageRepo})
    : _messageRepo = messageRepo;

  final IMessageRepo _messageRepo;

  Future<bool> sendMessage({required Message message}) async {
    return await _messageRepo.sendMessage(message: message);
  }

  Future<bool> editMessage({required Message newMessage}) async {
    return await _messageRepo.editMessage(newMessage: newMessage);
  }

  Future<bool> deleteMessage({required String messageId}) async {
    return await _messageRepo.deleteMessage(messageId: messageId);
  }

  Future<bool> pinMessage({required String messageId}) async {
    return await _messageRepo.pinMessage(messageId: messageId);
  }

  Future<List<MessageRead>> loadMessageReads({
    required String conversationId,
    required String messageId,
  }) async {
    return await _messageRepo.loadMessageReads(
      conversationId: conversationId,
      messageId: messageId,
    );
  }
}
