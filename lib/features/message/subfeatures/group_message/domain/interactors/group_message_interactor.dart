import 'package:locnet_app/features/conversation/subfeatures/group/domain/domain.dart';
import 'package:locnet_app/features/message/subfeatures/group_message/data/repositories/group_message_repo/i_group_message_repo.dart';

final class GroupMessageInteractor {
  GroupMessageInteractor({required IGroupMessageRepo messageRepo})
    : _messageRepo = messageRepo;

  final IGroupMessageRepo _messageRepo;

  Future<GroupMessage> sendMessage({
    required GroupMessage message,
  }) async {
    return _messageRepo.sendMessage(message: message);
  }

  Future<GroupMessage> editMessage({
    required GroupMessage updatedMessage,
  }) async {
    return _messageRepo.editMessage(updatedMessage: updatedMessage);
  }

  Future<bool> deleteMessage({required GroupMessage message}) async {
    return _messageRepo.deleteMessage(message: message);
  }

  Future<GroupMessage> toggleMessagePin({
    required GroupMessage message,
    required bool isPinned,
  }) async {
    return _messageRepo.toggleMessagePin(message: message, isPinned: isPinned);
  }

  Future<List<GroupMessageRead>> loadMessageReads({
    required String groupId,
    required String messageId,
  }) async {
    return _messageRepo.loadMessageReads(
      groupId: groupId,
      messageId: messageId,
    );
  }
}

