// ignore_for_file: sort_constructors_first

import 'dart:async';

import 'package:locnet_app/features/conversation/subfeatures/private/domain/domain.dart';
import 'package:locnet_app/features/message/domain/domain.dart';
import 'package:locnet_app/features/message/subfeatures/private_message/data/repositories/private_message_repo/i_private_message_repo.dart';
import 'package:locnet_app/mock/mock.dart';

final class MockPrivateMessageRepo implements IPrivateMessageRepo {
  MockPrivateMessageRepo({
    required MockInMemoryBackend backendStorage,
    required StreamController<PrivateConversationMessageUpdateRec>
        messagesUpdatesController,
  }) : _backendStorage = backendStorage,
       _messagesUpdatesController = messagesUpdatesController;

  final MockInMemoryBackend _backendStorage;
  final StreamController<PrivateConversationMessageUpdateRec>
      _messagesUpdatesController;

  @override
  Future<PrivateMessage> sendMessage({required PrivateMessage message}) async {
    _messagesUpdatesController.add((
      updateType: PrivateConversationMessageUpdateType.created,
      message: message,
    ));
    await Future<void>.delayed(const Duration(milliseconds: 200));
    final dto = _backendStorage.addPrivateMessage(newMessage: message);
    final sentMessage = message.copyWith(
      id: dto.id,
      deliveryStatus: MessageDeliveryStatus.sent,
      attachments: message.attachments
          .map((a) => a.copyWith(messageId: dto.id))
          .toList(),
    );
    _messagesUpdatesController.add((
      updateType: PrivateConversationMessageUpdateType.created,
      message: sentMessage,
    ));
    return sentMessage;
  }

  @override
  Future<PrivateMessage> editMessage({
    required PrivateMessage updatedMessage,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    final dto = _backendStorage.updatePrivateMessage(
      updatedMessage: updatedMessage,
    );
    final storedMessage = PrivateMessage.fromDto(dto);
    _messagesUpdatesController.add((
      updateType: PrivateConversationMessageUpdateType.updated,
      message: storedMessage,
    ));
    return storedMessage;
  }

  @override
  Future<bool> deleteMessage({required PrivateMessage message}) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    final ok = _backendStorage.deletePrivateMessage(message: message);
    if (ok) {
      _messagesUpdatesController.add((
        updateType: PrivateConversationMessageUpdateType.deleted,
        message: message.copyWith(isDeleted: true),
      ));
    }
    return ok;
  }

  @override
  Future<PrivateMessage> toggleMessagePin({
    required PrivateMessage message,
    required bool isPinned,
  }) async {
    final updated = message.copyWith(isPinned: isPinned);
    return editMessage(updatedMessage: updated);
  }

  @override
  Future<List<LastReadPrivateMessage>> loadMessageReads({
    required String conversationId,
    required String messageId,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    // No backing store for reads yet – return empty list.
    return <LastReadPrivateMessage>[];
  }
}

