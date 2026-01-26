// ignore_for_file: sort_constructors_first

import 'dart:async';

import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/conversation/data/data.dart';
import 'package:locnet_app/features/conversation/domain/domain.dart';
import 'package:locnet_app/features/conversation/subfeatures/channel/data/data.dart';
import 'package:locnet_app/features/message/data/data.dart';
import 'package:locnet_app/features/message/domain/domain.dart';
import 'package:locnet_app/mock/mock.dart';

final class MockChannelRepo implements IChannelRepo {
  MockChannelRepo({required MockInMemoryBackend backendStorage})
    : _backendStorage = backendStorage;

  final MockInMemoryBackend _backendStorage;

  @override
  Future<Conversation> createChannel({
    required String creatorId,
    required List<String> subscribersIds,
    required String title,
    String? description,
    String? avatarFileId,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    // TODO: Implement channel creation
    throw UnimplementedError();
  }

  @override
  Future<Conversation> updateChannel({
    required Conversation updatedChannel,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    final ConversationDto updatedDto = _backendStorage.updateConversation(
      updatedChannel,
    );
    return Conversation.fromDto(updatedDto);
  }

  @override
  Future<bool> deleteChannel({required String channelId}) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    return _backendStorage.deleteConversation(
      conversationId: channelId,
    );
  }

  @override
  Future<List<User>> loadChannelSubscribers({required String channelId}) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    final List<ConversationParticipantDto> participants =
        _backendStorage.getAllParticipants(
      conversationId: channelId,
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
  Future<bool> addUserToChannel({
    required String channelId,
    required String userId,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    // TODO: Implement add user to channel
    return true;
  }

  @override
  Future<bool> banUserFromChannel({
    required String channelId,
    required String reason,
    required String userId,
    required String bannedByUserId,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    // TODO: Implement ban user from channel
    return true;
  }

  @override
  Future<bool> deleteUserFromChannel({
    required String channelId,
    required String userId,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    // TODO: Implement delete user from channel
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
