import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/conversation/domain/domain.dart';
import 'package:locnet_app/features/conversation/subfeatures/group/data/data.dart';

final class GroupConversationInteractor {
  GroupConversationInteractor({
    required IGroupConversationRepo groupConversationRepo,
  }) : _groupConversationRepo = groupConversationRepo;

  final IGroupConversationRepo _groupConversationRepo;

  Future<Conversation> createGroup({
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
      description: creatorId,
      avatarFileId: avatarFileId,
    );
  }

  Future<bool> joinToGroup({
    required String groupConversationId,
    required String userId,
  }) async {
    return await _groupConversationRepo.addUserToGroup(
      groupConversationId: groupConversationId,
      userId: userId,
    );
  }

  Future<Conversation> updateGroup({required Conversation updatedGroup}) async {
    return await _groupConversationRepo.updateGroup(updatedGroup: updatedGroup);
  }

  Future<bool> toggleNotifications({
    required String groupConversationId,
    required String userId,
    required bool newNotificationsStatus,
  }) async {
    return await _groupConversationRepo.toggleNotifications(
      groupConversationId: groupConversationId,
      userId: userId,
      newNotificationsStatus: newNotificationsStatus,
    );
  }

  Future<bool> deleteGroup({required String groupConversationId}) async {
    return _groupConversationRepo.deleteGroup(
      groupConversationId: groupConversationId,
    );
  }

  Future<List<User>> loadGroupParticipants({
    required String groupConversationId,
  }) async {
    return _groupConversationRepo.loadGroupParticipants(
      groupConversationId: groupConversationId,
    );
  }

  Future<bool> leaveGroup({
    required String groupConversationId,
    required String userId,
  }) async {
    return await _groupConversationRepo.deleteUserFromGroup(
      groupConversationId: groupConversationId,
      userId: userId,
    );
  }

  Future<bool> addUserToGroup({
    required String groupConversationId,
    required String userId,
  }) async {
    return _groupConversationRepo.addUserToGroup(
      groupConversationId: groupConversationId,
      userId: userId,
    );
  }

  Future<bool> banUserFromGroup({
    required String groupConversationId,
    required String reason,
    required String userId,
    required String bannedByUserId,
  }) async {
    return _groupConversationRepo.banUserFromGroup(
      groupConversationId: groupConversationId,
      reason: reason,
      userId: userId,
      bannedByUserId: bannedByUserId,
    );
  }

  Future<bool> deleteUserFromGroup({
    required String groupConversationId,
    required String userId,
  }) async {
    return await _groupConversationRepo.deleteGroup(
      groupConversationId: groupConversationId,
    );
  }
}
