import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/conversation/subfeatures/group/domain/domain.dart';

abstract interface class IGroupRepo {
  Future<Group> createGroup({
    required String creatorId,
    required List<String> recipientsIds,
    required String title,
    String? description,
    String? avatarFileId,
  });

  Future<Group> getGroup({required String groupId});

  Future<Group> updateGroup({required Group updatedGroup});

  Future<bool> deleteGroup({required String groupId});

  Future<bool> toggleNotifications({
    required String groupId,
    required bool newNotificationsStatus,
  });

  Future<List<User>> loadGroupParticipants({required String groupId});

  Future<bool> addUserToGroup({
    required String groupId,
    required String userId,
  });

  Future<bool> banUserFromGroup({
    required String groupId,
    required String reason,
    required String userId,
    required String bannedByUserId,
  });

  Future<bool> deleteUserFromGroup({
    required String groupId,
    required String userId,
  });

  Future<List<GroupMessage>> loadMessagesPage({
    required String groupId,
    int page = 1,
  });

  Future<GroupMessage> sendMessage({required GroupMessage message});

  Future<GroupMessage> editMessage({required GroupMessage updatedMessage});

  Future<bool> deleteMessage({required GroupMessage message});
}
