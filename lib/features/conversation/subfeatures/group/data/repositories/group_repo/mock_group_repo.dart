// ignore_for_file: sort_constructors_first

import 'dart:async';

import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/conversation/subfeatures/group/data/data.dart';
import 'package:locnet_app/features/conversation/subfeatures/group/domain/domain.dart';
import 'package:locnet_app/features/message/domain/domain.dart';
import 'package:locnet_app/mock/mock.dart';

final class MockGroupRepo implements IGroupRepo {
  MockGroupRepo({
    required MockInMemoryBackend backendStorage,
    required StreamController<GroupConversationMessageUpdateRec>
        messagesUpdatesController,
  }) : _backendStorage = backendStorage,
       _messagesUpdatesController = messagesUpdatesController;

  final MockInMemoryBackend _backendStorage;
  final StreamController<GroupConversationMessageUpdateRec>
      _messagesUpdatesController;

  @override
  Stream<GroupConversationMessageUpdateRec> get messagesUpdates =>
      _messagesUpdatesController.stream;

  @override
  Future<Group> createGroup({
    required String creatorId,
    required List<String> recipientsIds,
    required String title,
    String? description,
    String? avatarFileId,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    // TODO: Implement group creation
    throw UnimplementedError();
  }

  @override
  Future<Group> getGroup({required String groupId}) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    final dto = _backendStorage.getGroupById(groupId);
    return Group.fromDto(dto);
  }

  @override
  Future<Group> updateGroup({required Group updatedGroup}) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    final updatedDto = _backendStorage.updateGroup(updatedGroup);
    return Group.fromDto(updatedDto);
  }

  @override
  Future<bool> deleteGroup({required String groupId}) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    return _backendStorage.deleteGroup(groupId: groupId);
  }

  @override
  Future<bool> toggleNotifications({
    required String groupId,
    required bool newNotificationsStatus,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    return true;
  }

  @override
  Future<List<User>> loadGroupParticipants({required String groupId}) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    final userDtos = _backendStorage.getGroupParticipants(groupId: groupId);
    return userDtos.map(User.fromDto).toList();
  }

  @override
  Future<bool> addUserToGroup({
    required String groupId,
    required String userId,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    // TODO: Implement add user to group
    return true;
  }

  @override
  Future<bool> banUserFromGroup({
    required String groupId,
    required String reason,
    required String userId,
    required String bannedByUserId,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    // TODO: Implement ban user from group
    return true;
  }

  @override
  Future<bool> deleteUserFromGroup({
    required String groupId,
    required String userId,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    // TODO: Implement delete user from group
    return true;
  }

  @override
  Future<List<GroupMessage>> loadMessagesPage({
    required String groupId,
    int page = 1,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));

    final int safePage = page <= 0 ? 1 : page;

    final List<GroupMessageDto> dtos = _backendStorage
        .getAllGroupMessagesByGroupId(
          groupId: groupId,
          page: safePage,
        );

    final List<GroupMessage> result = <GroupMessage>[];

    for (final GroupMessageDto dto in dtos) {
      if (dto.isDeleted) {
        continue;
      }
      result.add(GroupMessage.fromDto(dto));
    }

    return result;
  }

  @override
  Future<GroupMessage> sendMessage({required GroupMessage message}) async {
    await Future<void>.delayed(const Duration(milliseconds: 1000));

    final resDto = _backendStorage.addGroupMessage(newMessage: message);

    return message.copyWith(
      id: resDto.id,
      deliveryStatus: MessageDeliveryStatus.sent,
      attachments: message.attachments
          .map((a) => a.copyWith(messageId: resDto.id))
          .toList(),
    );
  }

  @override
  Future<GroupMessage> editMessage({
    required GroupMessage updatedMessage,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    final storedDto = _backendStorage.updateGroupMessage(
      updatedMessage: updatedMessage,
    );
    return GroupMessage.fromDto(storedDto);
  }

  @override
  Future<bool> deleteMessage({required GroupMessage message}) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _backendStorage.deleteGroupMessage(message: message);
  }
}
