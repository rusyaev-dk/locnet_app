import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/conversation/domain/domain.dart';
import 'package:locnet_app/features/message/domain/domain.dart';

abstract interface class IChannelRepo {
  Future<Conversation> createChannel({
    required String creatorId,
    required List<String> subscribersIds,
    required String title,
    String? description,
    String? avatarFileId,
  });

  Future<Conversation> updateChannel({required Conversation updatedChannel});

  Future<bool> deleteChannel({required String channelId});

  Future<List<User>> loadChannelSubscribers({required String channelId});

  Future<bool> addUserToChannel({
    required String channelId,
    required String userId,
  });

  Future<bool> banUserFromChannel({
    required String channelId,
    required String reason,
    required String userId,
    required String bannedByUserId,
  });

  Future<bool> deleteUserFromChannel({
    required String channelId,
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
