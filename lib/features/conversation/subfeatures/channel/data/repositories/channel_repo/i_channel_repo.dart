import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/conversation/subfeatures/channel/channel.dart';

abstract interface class IChannelRepo {
  Future<Channel> getChannel({required String channelId});

  Future<Channel> createChannel({
    required String creatorId,
    required List<String> subscribersIds,
    required String title,
    String? description,
    String? avatarFileId,
  });

  Future<Channel> updateChannel({required Channel updatedChannel});

  Future<bool> deleteChannel({required String channelId});

  Future<bool> toggleNotifications({
    required String channelId,
    required bool newNotificationsStatus,
  });

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

  Future<List<ChannelPublication>> loadPublications({
    required String channelId,
    int page = 1,
  });

  Future<ChannelPublication> sendPublication({
    required ChannelPublication publication,
  });

  Future<ChannelPublication> editPublication({
    required ChannelPublication updatedPublication,
  });

  Future<bool> deletePublication({required ChannelPublication publication});
}
