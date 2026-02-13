// ignore_for_file: sort_constructors_first

import 'dart:async';

import 'package:locnet_app/features/conversation/subfeatures/group/domain/domain.dart';
import 'package:locnet_app/features/message/domain/domain.dart';
import 'package:locnet_app/features/message/subfeatures/group_message/data/repositories/group_message_repo/i_group_message_repo.dart';
import 'package:locnet_app/mock/mock.dart';

final class MockGroupMessageRepo implements IGroupMessageRepo {
  MockGroupMessageRepo({
    required MockInMemoryBackend backendStorage,
    required StreamController<GroupConversationMessageUpdateRec>
        messagesUpdatesController,
  }) : _backendStorage = backendStorage,
       _messagesUpdatesController = messagesUpdatesController;

  final MockInMemoryBackend _backendStorage;
  final StreamController<GroupConversationMessageUpdateRec>
      _messagesUpdatesController;

  @override
  Future<GroupMessage> sendMessage({required GroupMessage message}) async {
    _messagesUpdatesController.add((
      updateType: GroupConversationMessageUpdateType.created,
      message: message,
    ));
    await Future<void>.delayed(const Duration(milliseconds: 200));
    final dto = _backendStorage.addGroupMessage(newMessage: message);
    final sentMessage = message.copyWith(
      id: dto.id,
      deliveryStatus: MessageDeliveryStatus.sent,
      attachments: message.attachments
          .map((a) => a.copyWith(messageId: dto.id))
          .toList(),
    );
    _messagesUpdatesController.add((
      updateType: GroupConversationMessageUpdateType.created,
      message: sentMessage,
    ));
    return GroupMessage.fromDto(dto);
  }

  @override
  Future<GroupMessage> editMessage({
    required GroupMessage updatedMessage,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    final dto = _backendStorage.updateGroupMessage(
      updatedMessage: updatedMessage,
    );
    final storedMessage = GroupMessage.fromDto(dto);
    _messagesUpdatesController.add((
      updateType: GroupConversationMessageUpdateType.updated,
      message: storedMessage,
    ));
    return storedMessage;
  }

  @override
  Future<bool> deleteMessage({required GroupMessage message}) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    final ok = _backendStorage.deleteGroupMessage(message: message);
    if (ok) {
      _messagesUpdatesController.add((
        updateType: GroupConversationMessageUpdateType.deleted,
        message: message.copyWith(isDeleted: true),
      ));
    }
    return ok;
  }

  @override
  Future<GroupMessage> toggleMessagePin({
    required GroupMessage message,
    required bool isPinned,
  }) async {
    final updated = message.copyWith(isPinned: isPinned);
    return editMessage(updatedMessage: updated);
  }

  @override
  Future<List<GroupMessageRead>> loadMessageReads({
    required String groupId,
    required String messageId,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    // No backing store for reads yet – return empty list.
    return <GroupMessageRead>[];
  }
}

