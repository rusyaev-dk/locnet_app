// ignore_for_file: sort_constructors_first

import 'dart:async';

import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/conversation/data/data.dart';
import 'package:locnet_app/features/conversation/domain/domain.dart';
import 'package:locnet_app/features/conversation/subfeatures/group/data/data.dart';
import 'package:locnet_app/features/message/data/data.dart';
import 'package:locnet_app/features/message/domain/domain.dart';
import 'package:locnet_app/mock/mock.dart';

final class MockGroupConversationRepo implements IGroupConversationRepo {
  MockGroupConversationRepo({required MockInMemoryBackend backendStorage})
    : _backendStorage = backendStorage;

  final MockInMemoryBackend _backendStorage;

  @override
  Future<Conversation> createGroup({
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
  Future<Conversation> updateGroup({required Conversation updatedGroup}) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    final ConversationDto updatedDto = _backendStorage.updateConversation(
      updatedGroup,
    );
    return Conversation.fromDto(updatedDto);
  }

  @override
  Future<bool> deleteGroup({required String groupConversationId}) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    return _backendStorage.deleteConversation(
      conversationId: groupConversationId,
    );
  }

  @override
  Future<List<User>> loadGroupParticipants({
    required String groupConversationId,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    final List<ConversationParticipantDto> participants =
        _backendStorage.getAllParticipants(
      conversationId: groupConversationId,
    );

    final List<User> result = <User>[];
    for (final ConversationParticipantDto participantDto in participants) {
      final UserDto userDto = _backendStorage.getUserById(
        userId: participantDto.userId,
      );
      result.add(User.fromDto(userDto));
    }

    return result;
  }

  @override
  Future<bool> addUserToGroup({
    required String groupConversationId,
    required String userId,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    // TODO: Implement add user to group
    return true;
  }

  @override
  Future<bool> banUserFromGroup({
    required String groupConversationId,
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
    required String groupConversationId,
    required String userId,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    // TODO: Implement delete user from group
    return true;
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
  Future<Message> sendMessage({required Message message}) async {
    await Future<void>.delayed(const Duration(milliseconds: 1000));

    final resMsg = _backendStorage.addMessage(newMessage: message);

    return message.copyWith(
      deliveryStatus: MessageDeliveryStatus.sent,
      messageId: resMsg.messageId,
      attachments: message.attachments
          .map(
            (attachment) => attachment.copyWith(
              messageId: resMsg.messageId,
            ),
          )
          .toList(),
    );
  }

  @override
  Future<Message> editMessage({required Message updatedMessage}) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    final MessageDto stored = _backendStorage.updateMessage(
      updatedMessage: updatedMessage,
    );
    return Message.fromDto(stored);
  }

  @override
  Future<bool> deleteMessage({required Message message}) async {
    await Future.delayed(const Duration(milliseconds: 200));

    final deleteSuccess = _backendStorage.deleteMessage(message: message);

    return deleteSuccess;
  }
}
