// ignore_for_file: sort_constructors_first

import 'dart:async';

import 'package:locnet_app/features/conversation/data/data.dart';
import 'package:locnet_app/features/conversation/domain/domain.dart';
import 'package:locnet_app/features/conversations/data/data.dart';
import 'package:locnet_app/features/conversations/domain/domain.dart';
import 'package:locnet_app/features/message/data/data.dart';
import 'package:locnet_app/features/message/domain/domain.dart';
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
    await Future<void>.delayed(const Duration(milliseconds: 200));

    final int safePage = page <= 0 ? 1 : page;

    final conversationDtos = _backendStorage.getAllConversations(
      page: safePage,
    );

    final List<ConversationTile> result = <ConversationTile>[];

    for (final ConversationDto dto in conversationDtos) {
      if (dto.isDeleted) {
        continue;
      }

      final Conversation conversation = Conversation.fromDto(dto);

      final ({Message? lastMessage, String? companionId}) lastMessageData =
          _getLastMessageAndCompanionForConversation(conversation);

      result.add(
        ConversationTile(
          conversation: conversation,
          lastMessage: lastMessageData.lastMessage,
          companionId: lastMessageData.companionId,
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

  ({Message? lastMessage, String? companionId})
  _getLastMessageAndCompanionForConversation(Conversation conversation) {
    final List<MessageDto> messageDtos = _backendStorage.getAllMessages(
      conversationId: conversation.conversationId,
    );

    if (messageDtos.isEmpty) {
      return (lastMessage: null, companionId: null);
    }

    if (conversation.type != ConversationType.private) {
      final MessageDto lastDto = messageDtos.last;
      return (lastMessage: Message.fromDto(lastDto), companionId: null);
    }

    final Set<String> senderIds = <String>{};
    for (final MessageDto dto in messageDtos) {
      senderIds.add(dto.senderId);
    }

    if (senderIds.isEmpty) {
      final MessageDto lastDto = messageDtos.last;
      return (lastMessage: Message.fromDto(lastDto), companionId: null);
    }

    final String companionId = senderIds.first;

    MessageDto? lastCompanionMessageDto;
    for (final MessageDto dto in messageDtos.reversed) {
      if (dto.senderId == companionId) {
        lastCompanionMessageDto = dto;
        break;
      }
    }

    final MessageDto effectiveLastDto =
        lastCompanionMessageDto ?? messageDtos.last;

    return (
      lastMessage: Message.fromDto(effectiveLastDto),
      companionId: companionId,
    );
  }

  Future<void> dispose() async {
    await _updatesController.close();
  }
}
