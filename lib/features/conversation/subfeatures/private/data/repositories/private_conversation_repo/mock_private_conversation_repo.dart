// ignore_for_file: sort_constructors_first

import 'dart:async';

import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/conversation/data/data.dart';
import 'package:locnet_app/features/conversation/subfeatures/private/data/data.dart';
import 'package:locnet_app/features/message/data/data.dart';
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
  Future<User> getCompanion({required String conversationId}) async {
    final participants = _backendStorage.getAllParticipants(
      conversationId: conversationId,
    );
    final participantDto = participants
        .where(
          (ConversationParticipantDto participant) =>
              participant.userId != MockUsers.adminUser.userId,
        )
        .first;
    final companionDto = _backendStorage.getUserById(
      userId: participantDto.userId,
    );
    return User.fromDto(companionDto);
  }

  @override
  Future<bool> deleteConversation({
    required String conversationId,
    required bool deleteAtRecipient,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));

    final deleteSuccess = _backendStorage.deleteConversation(
      conversationId: conversationId,
    );

    return deleteSuccess;
  }

  @override
  Future<List<Message>> loadMessagesPage({
    required String conversationId,
    int page = 1,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));

    final int safePage = page <= 0 ? 1 : page;

    final List<MessageDto> messageDtos = _backendStorage
        .getAllMessagesByConversationId(
          conversationId: conversationId,
          page: safePage,
        );

    final List<Message> result = <Message>[];

    for (final MessageDto dto in messageDtos) {
      if (dto.isDeleted == true) {
        continue;
      }
      result.add(Message.fromDto(dto));
    }

    return result;
  }

  @override
  Future<Message> sendMessage({
    required Message message,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));

    _backendStorage.addMessage(newMessage: message);

    _updatesController.add((
      updateType: PrivateConversationMessageUpdateType.created,
      message: message,
    ));
    return message;
  }

  @override
  Future<Message> editMessage({required Message updatedMessage}) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    final MessageDto stored = _backendStorage.updateMessage(
      updatedMessage: updatedMessage,
    );
    final Message storedMessage = Message.fromDto(stored);

    _updatesController.add((
      updateType: PrivateConversationMessageUpdateType.updated,
      message: storedMessage,
    ));

    return storedMessage;
  }

  @override
  Future<bool> deleteMessage({
    required Message message,
    required bool deleteAtRecipient,
  }) async {
    await Future.delayed(const Duration(milliseconds: 200));

    final deleteSuccess = _backendStorage.deleteMessage(message: message);

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
