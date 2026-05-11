// ignore_for_file: sort_constructors_first

import 'dart:async';

import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/conversation/subfeatures/channel/channel.dart';
import 'package:locnet_app/features/conversation/subfeatures/group/group.dart';
import 'package:locnet_app/features/conversation/subfeatures/private/private.dart';
import 'package:locnet_app/features/conversations_list/data/data.dart';
import 'package:locnet_app/features/conversations_list/domain/domain.dart';
import 'package:locnet_app/mock/mock.dart';

final class MockConversationsListRepo implements IConversationsListRepo {
  MockConversationsListRepo({required MockInMemoryBackend backendStorage})
    : _backendStorage = backendStorage,
      _updatesController =
          StreamController<ConversationsListUpdateRec>.broadcast();

  final MockInMemoryBackend _backendStorage;
  final StreamController<ConversationsListUpdateRec> _updatesController;

  @override
  Stream<ConversationsListUpdateRec> get conversationsUpdates =>
      _updatesController.stream;

  @override
  Future<List<ConversationTile>> loadConversationsList({int page = 1}) async {
    final int safePage = page <= 0 ? 1 : page;

    final List<ConversationTile> result = <ConversationTile>[];

    // PRIVATE CHATS
    final privateDtos = _backendStorage.getAllPrivateConversations(
      page: safePage,
    );
    for (final PrivateConversationDto dto in privateDtos) {
      if (dto.isDeleted) continue;

      final PrivateMessageDto? lastMessageDto = _backendStorage
          .getLastPrivateMessage(conversationId: dto.conversationId);

      String? lastText;
      String? lastSenderId;
      DateTime? lastAt;
      if (lastMessageDto != null && !lastMessageDto.isDeleted) {
        lastText = lastMessageDto.text;
        lastSenderId = lastMessageDto.senderId;
        lastAt = lastMessageDto.createdAt;
      }

      // Resolve companion user (other participant, assuming current user is admin)
      User? companion;
      try {
        final adminId = MockUsers.adminUser.userId;
        final String companionId = dto.user1Id == adminId
            ? dto.user2Id
            : dto.user1Id;
        final UserDto companionDto = _backendStorage.getUserById(
          userId: companionId,
        );
        companion = User.fromDto(companionDto);
      } catch (_) {
        companion = null;
      }

      result.add(
        ConversationTile(
          id: dto.conversationId,
          type: ConversationTileType.private,
          title: 'Private chat',
          companion: companion,
          lastMessageText: lastText,
          lastMessageSenderId: lastSenderId,
          lastMessageAt: lastAt,
          updatedAt: dto.updatedAt,
        ),
      );
    }

    // GROUPS
    final groupDtos = _backendStorage.getAllGroups(page: safePage);
    for (final GroupDto dto in groupDtos) {
      if (dto.isDeleted) continue;

      final GroupMessageDto? lastMessageDto = _backendStorage
          .getLastGroupMessage(groupId: dto.groupId);

      String? lastText;
      String? lastSenderId;
      DateTime? lastAt;
      if (lastMessageDto != null && !lastMessageDto.isDeleted) {
        lastText = lastMessageDto.text;
        lastSenderId = lastMessageDto.senderId;
        lastAt = lastMessageDto.createdAt;
      }

      result.add(
        ConversationTile(
          id: dto.groupId,
          type: ConversationTileType.group,
          title: dto.title,
          description: dto.description,
          lastMessageText: lastText,
          lastMessageSenderId: lastSenderId,
          lastMessageAt: lastAt,
          updatedAt: dto.updatedAt,
        ),
      );
    }

    // CHANNELS
    final channelDtos = _backendStorage.getAllChannels(page: safePage);
    for (final ChannelDto dto in channelDtos) {
      if (dto.isDeleted) continue;

      final ChannelPublicationDto? lastPublicationDto = _backendStorage
          .getLastChannelPublication(channelId: dto.channelId);

      String? lastText;
      String? lastSenderId;
      DateTime? lastAt;
      if (lastPublicationDto != null && !lastPublicationDto.isDeleted) {
        lastText = lastPublicationDto.text;
        lastSenderId = lastPublicationDto.publishedById;
        lastAt = lastPublicationDto.createdAt;
      }

      result.add(
        ConversationTile(
          id: dto.channelId,
          type: ConversationTileType.channel,
          title: dto.title,
          description: dto.description,
          lastMessageText: lastText,
          lastMessageSenderId: lastSenderId,
          lastMessageAt: lastAt,
          updatedAt: dto.updatedAt,
        ),
      );
    }

    return result;
  }

  // void pushCreated(ConversationTile conversationTile) {
  //   final Conversation conversation = conversationTile.conversation;
  //   final ConversationDto conversationDto = _mapConversationToDto(conversation);

  //   final ConversationDto existing = _backendStorage.getConversationById(
  //     conversation.id,
  //   );

  //   _backendStorage.updateConversation(conversationDto);

  //   final Message? lastMessage = conversationTile.lastMessage;
  //   if (lastMessage != null) {
  //     final MessageDto messageDto = _mapMessageToDto(lastMessage);

  //     final MessageDto? existingMessage = _backendStorage.getMessageById(
  //       lastMessage.id,
  //     );

  //     if (existingMessage == null) {
  //       _backendStorage.addMessage(messageDto);
  //     } else {
  //       _backendStorage.updateMessage(messageDto);
  //     }
  //   }

  //   _updatesController.add((
  //     updateType: ConversationTileUpdateType.created,
  //     conversationTile: conversationTile,
  //   ));
  // }

  // void pushUpdated(ConversationTile conversationTile) {
  //   final Conversation conversation = conversationTile.conversation;
  //   final ConversationDto conversationDto = _mapConversationToDto(conversation);

  //   final ConversationDto existing = _backendStorage.getConversationById(
  //     conversation.id,
  //   );

  //   _backendStorage.updateConversation(conversationDto);

  //   final Message? lastMessage = conversationTile.lastMessage;
  //   if (lastMessage != null) {
  //     final MessageDto messageDto = _mapMessageToDto(lastMessage);

  //     final MessageDto? existingMessage = _backendStorage.getMessageById(
  //       lastMessage.id,
  //     );

  //     if (existingMessage == null) {
  //       _backendStorage.addMessage(messageDto);
  //     } else {
  //       _backendStorage.updateMessage(messageDto);
  //     }
  //   }

  //   _updatesController.add((
  //     updateType: ConversationTileUpdateType.updated,
  //     conversationTile: conversationTile,
  //   ));
  // }

  // void pushDeleted(String conversationId) {
  //   final conversationToDelete = _backendStorage.getConversationById(
  //     conversationId,
  //   );
  //   final deleteSuccess = _backendStorage.deleteConversation(
  //     conversationId: conversationId,
  //   );

  //   if (!deleteSuccess) {
  //     return;
  //   }

  //   final Conversation conversation = Conversation.fromDto(
  //     conversationToDelete,
  //   );

  //   final ({Message? lastMessage, String? companionId}) lastMessageData =
  //       _getLastMessageAndCompanionForConversation(conversation);

  //   final ConversationTile removedTile = ConversationTile(
  //     conversation: conversation,
  //     lastMessage: lastMessageData.lastMessage,
  //     companionId: lastMessageData.companionId,
  //   );

  //   _updatesController.add((
  //     updateType: ConversationTileUpdateType.deleted,
  //     conversationTile: removedTile,
  //   ));
  // }

  Future<void> dispose() async {
    await _updatesController.close();
  }
}
