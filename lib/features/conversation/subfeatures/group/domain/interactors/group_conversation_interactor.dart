import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/conversation/subfeatures/group/data/data.dart';
import 'package:locnet_app/features/conversation/subfeatures/group/domain/domain.dart';

final class GroupConversationInteractor {
  GroupConversationInteractor({required IGroupRepo groupConversationRepo})
    : _groupConversationRepo = groupConversationRepo;

  final IGroupRepo _groupConversationRepo;

  Future<Group> createGroup({
    required String creatorId,
    required List<String> recipientsIds,
    required String title,
    String? description,
    String? avatarFileId,
  }) async {
    return await _groupConversationRepo.createGroup(
      creatorId: creatorId,
      recipientsIds: recipientsIds,
      title: title,
      description: description,
      avatarFileId: avatarFileId,
    );
  }

  Future<Group> getGroup({required String groupId}) async {
    return await _groupConversationRepo.getGroup(groupId: groupId);
  }

  Future<bool> joinToGroup({
    required String groupId,
    required String userId,
  }) async {
    return await _groupConversationRepo.addUserToGroup(
      groupId: groupId,
      userId: userId,
    );
  }

  Future<Group> updateGroup({required Group updatedGroup}) async {
    return await _groupConversationRepo.updateGroup(updatedGroup: updatedGroup);
  }

  Future<bool> toggleNotifications({
    required String groupId,
    required bool newNotificationsStatus,
  }) async {
    return await _groupConversationRepo.toggleNotifications(
      groupId: groupId,
      newNotificationsStatus: newNotificationsStatus,
    );
  }

  Future<bool> deleteGroup({required String groupId}) async {
    return _groupConversationRepo.deleteGroup(groupId: groupId);
  }

  Future<List<User>> loadGroupParticipants({required String groupId}) async {
    return _groupConversationRepo.loadGroupParticipants(groupId: groupId);
  }

  Future<bool> leaveGroup({
    required String groupId,
    required String userId,
  }) async {
    return await _groupConversationRepo.deleteUserFromGroup(
      groupId: groupId,
      userId: userId,
    );
  }

  Future<bool> addUserToGroup({
    required String groupId,
    required String userId,
  }) async {
    return _groupConversationRepo.addUserToGroup(
      groupId: groupId,
      userId: userId,
    );
  }

  Future<bool> banUserFromGroup({
    required String groupId,
    required String reason,
    required String userId,
    required String bannedByUserId,
  }) async {
    return _groupConversationRepo.banUserFromGroup(
      groupId: groupId,
      reason: reason,
      userId: userId,
      bannedByUserId: bannedByUserId,
    );
  }

  Future<bool> deleteUserFromGroup({
    required String groupId,
    required String userId,
  }) async {
    return await _groupConversationRepo.deleteUserFromGroup(
      groupId: groupId,
      userId: userId,
    );
  }

  Future<Group> getGroupById({required String groupId}) async {
    return await _groupConversationRepo.getGroup(groupId: groupId);
  }

  Future<List<GroupMessage>> loadMessagesPage({
    required String groupId,
    int page = 1,
  }) async {
    return await _groupConversationRepo.loadMessagesPage(
      groupId: groupId,
      page: page,
    );
  }

  Stream<GroupConversationMessageUpdateRec> get messagesUpdates =>
      _groupConversationRepo.messagesUpdates;
}
