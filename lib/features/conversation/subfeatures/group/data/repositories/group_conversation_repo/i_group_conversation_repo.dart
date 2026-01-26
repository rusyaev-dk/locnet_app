import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/conversation/domain/domain.dart';
import 'package:locnet_app/features/message/domain/domain.dart';

abstract interface class IGroupConversationRepo {
  Future<Conversation> createGroup({
    required String creatorId,
    required List<String> recipientsIds,
    required String title,
    String? description,
    String? avatarFileId,
  });

  Future<Conversation> updateGroup({required Conversation updatedGroup});

  Future<bool> deleteGroup({required String groupConversationId});

  Future<List<User>> loadGroupParticipants({
    required String groupConversationId,
  });

  Future<bool> addUserToGroup({
    required String groupConversationId,
    required String userId,
  });

  Future<bool> banUserFromGroup({
    required String groupConversationId,
    required String reason,
    required String userId,
    required String bannedByUserId,
  });

  Future<bool> deleteUserFromGroup({
    required String groupConversationId,
    required String userId,
  });

  Future<List<Message>> loadMessagesPage({
    required String conversationId,
    int page = 1,
  });

  Future<Message> sendMessage({
    required Message message,
  });

  Future<Message> editMessage({required Message updatedMessage});

  Future<bool> deleteMessage({
    required Message message,
  });
}
