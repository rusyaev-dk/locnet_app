// ignore_for_file: sort_constructors_first

import 'dart:async';

import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/conversation/subfeatures/private/data/data.dart';
import 'package:locnet_app/features/conversation/subfeatures/private/domain/domain.dart';
import 'package:locnet_app/features/message/domain/domain.dart';
import 'package:locnet_app/mock/mock.dart';

final class MockPrivateConversationRepo implements IPrivateConversationRepo {
  MockPrivateConversationRepo({required MockInMemoryBackend backendStorage})
    : _backendStorage = backendStorage,
      _updatesController =
          StreamController<PrivateConversationMessageUpdateRec>.broadcast();

  final MockInMemoryBackend _backendStorage;
  final StreamController<PrivateConversationMessageUpdateRec>
  _updatesController;

  @override
  Stream<PrivateConversationMessageUpdateRec> get messagesUpdates =>
      _updatesController.stream;

  @override
  Future<bool> blockCompanion({
    required String companionId,
    required String blockedByUserId,
    required String reason,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    return true;
  }

  @override
  Future<PrivateConversation> getPrivateConversation({
    required String conversationId,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    final dto = _backendStorage.getPrivateConversationById(conversationId);
    return PrivateConversation.fromDto(dto);
  }

  @override
  Future<bool> toggleNotifications({
    required String conversationId,
    required bool newNotificationsStatus,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    return true;
  }

  @override
  Future<User> getCompanion({required String conversationId}) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    final conv = _backendStorage.getPrivateConversationById(conversationId);
    final companionId = conv.user1Id == MockUsers.adminUser.userId
        ? conv.user2Id
        : conv.user1Id;
    final companionDto = _backendStorage.getUserById(userId: companionId);
    return User.fromDto(companionDto);
  }

  @override
  Future<bool> deleteConversation({
    required String conversationId,
    required bool deleteAtRecipient,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    return _backendStorage.deletePrivateConversation(
      privateConversationId: conversationId,
    );
  }

  @override
  Future<List<PrivateMessage>> loadMessagesPage({
    required String conversationId,
    int page = 1,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));

    final int safePage = page <= 0 ? 1 : page;

    final List<PrivateMessageDto> dtos = _backendStorage
        .getAllPrivateMessagesByConversationId(
          conversationId: conversationId,
          page: safePage,
        );

    final List<PrivateMessage> result = <PrivateMessage>[];

    for (final PrivateMessageDto dto in dtos) {
      if (dto.isDeleted) {
        continue;
      }
      result.add(PrivateMessage.fromDto(dto));
    }

    return result;
  }

  @override
  Future<PrivateMessage> sendMessage({required PrivateMessage message}) async {
    _updatesController.add((
      updateType: PrivateConversationMessageUpdateType.created,
      message: message,
    ));

    await Future<void>.delayed(const Duration(milliseconds: 1000));

    final resDto = _backendStorage.addPrivateMessage(newMessage: message);

    final sentMessage = message.copyWith(
      id: resDto.id,
      deliveryStatus: MessageDeliveryStatus.sent,
      attachments: message.attachments
          .map((a) => a.copyWith(messageId: resDto.id))
          .toList(),
    );

    _updatesController.add((
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
    final storedDto = _backendStorage.updatePrivateMessage(
      updatedMessage: updatedMessage,
    );
    final storedMessage = PrivateMessage.fromDto(storedDto);

    _updatesController.add((
      updateType: PrivateConversationMessageUpdateType.updated,
      message: storedMessage,
    ));

    return storedMessage;
  }

  @override
  Future<bool> deleteMessage({
    required PrivateMessage message,
    required bool deleteAtRecipient,
  }) async {
    await Future.delayed(const Duration(milliseconds: 200));

    final deleteSuccess = _backendStorage.deletePrivateMessage(message: message);

    if (!deleteSuccess) {
      return false;
    }

    _updatesController.add((
      updateType: PrivateConversationMessageUpdateType.deleted,
      message: message.copyWith(isDeleted: true),
    ));

    return true;
  }

  Future<void> dispose() async {
    await _updatesController.close();
  }
}
