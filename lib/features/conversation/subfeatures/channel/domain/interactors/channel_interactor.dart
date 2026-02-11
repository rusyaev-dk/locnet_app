import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/conversation/subfeatures/channel/channel.dart';

final class ChannelInteractor {
  ChannelInteractor({required IChannelRepo channelRepo}) : _channelRepo = channelRepo;

  final IChannelRepo _channelRepo;

  Future<Channel> createChannel({
    required String creatorId,
    required List<String> subscribersIds,
    required String title,
    String? description,
    String? avatarFileId,
  }) async {
    return await _channelRepo.createChannel(
      creatorId: creatorId,
      subscribersIds: subscribersIds,
      title: title,
      description: description,
      avatarFileId: avatarFileId,
    );
  }

  Future<Channel> getChannel({required String channelId}) async {
    return await _channelRepo.getChannel(channelId: channelId);
  }

  Future<Channel> updateChannel({required Channel updatedChannel}) async {
    return await _channelRepo.updateChannel(updatedChannel: updatedChannel);
  }

  Future<bool> toggleNotifications({
    required String channelId,
    required bool newNotificationsStatus,
  }) async {
    return await _channelRepo.toggleNotifications(
      channelId: channelId,
      newNotificationsStatus: newNotificationsStatus,
    );
  }

  Future<bool> deleteChannel({required String channelId}) async {
    return await _channelRepo.deleteChannel(channelId: channelId);
  }

  Future<bool> subscribeToChannel({
    required String channelId,
    required String subscriberId,
  }) async {
    return await _channelRepo.addUserToChannel(
      channelId: channelId,
      userId: subscriberId,
    );
  }

  Future<bool> leaveChannel({
    required String channelId,
    required String subscriberId,
  }) async {
    return await _channelRepo.deleteUserFromChannel(
      channelId: channelId,
      userId: subscriberId,
    );
  }

  Future<bool> addUserToChannel({
    required String channelId,
    required String userId,
  }) async {
    return await _channelRepo.addUserToChannel(
      channelId: channelId,
      userId: userId,
    );
  }

  Future<List<User>> loadChannelSubscribers({required String channelId}) async {
    return _channelRepo.loadChannelSubscribers(channelId: channelId);
  }

  Future<bool> banUserFromChannel({
    required String channelId,
    required String reason,
    required String userId,
    required String bannedByUserId,
  }) async {
    return _channelRepo.banUserFromChannel(
      channelId: channelId,
      reason: reason,
      userId: userId,
      bannedByUserId: bannedByUserId,
    );
  }

  Future<bool> deleteUserFromChannel({
    required String channelId,
    required String userId,
  }) async {
    return _channelRepo.deleteUserFromChannel(
      channelId: channelId,
      userId: userId,
    );
  }

  Future<List<ChannelPublication>> loadPublications({
    required String channelId,
    int page = 1,
  }) async {
    return await _channelRepo.loadPublications(
      channelId: channelId,
      page: page,
    );
  }
}
