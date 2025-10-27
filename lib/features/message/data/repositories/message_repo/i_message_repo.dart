import 'package:locnet_app/features/message/domain/domain.dart';

abstract interface class IMessageRepo {
  Future<bool> sendMessage({required Message message});
  Future<bool> editMessage({required Message newMessage});
  Future<bool> deleteMessage({required String messageId});
  Future<bool> pinMessage({required String messageId});

  Future<List<MessageRead>> loadMessageReads({
    required String conversationId,
    required String userId,
  });
}
