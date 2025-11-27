// ignore_for_file: sort_constructors_first

import 'dart:async';

import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/conversation/data/data.dart';
import 'package:locnet_app/features/conversation/domain/domain.dart';
import 'package:locnet_app/features/conversations/data/data.dart';
import 'package:locnet_app/features/conversations/domain/domain.dart';
import 'package:locnet_app/features/message/data/data.dart';
import 'package:locnet_app/features/message/domain/domain.dart';
import 'package:locnet_app/mock/mock_backend_storage.dart';

final class MockConversationsListRepo implements IConversationsListRepo {
  MockConversationsListRepo({
    required ILogger logger,
    required MockBackendStorage backendStorage,
    List<ConversationTile>? initialTiles,
    Duration? artificialDelay,
    int? mockConversationsCount,
  }) : _logger = logger,
       _backendStorage = backendStorage,
       _artificialDelay = artificialDelay ?? const Duration(milliseconds: 200),
       _updatesController =
           StreamController<ConversationsListUpdateRec>.broadcast() {
    _seedInitialTiles(initialTiles: initialTiles);
    // mockConversationsCount intentionally not used here, data is already seeded in storage.
  }

  final ILogger _logger;
  final MockBackendStorage _backendStorage;
  final Duration _artificialDelay;
  final StreamController<ConversationsListUpdateRec> _updatesController;

  static const int _defaultLimit = 20;

  @override
  Stream<ConversationsListUpdateRec> get conversationsUpdates =>
      _updatesController.stream;

  @override
  Future<List<ConversationTile>> loadConversationsList({int page = 1}) async {
    try {
      await Future<void>.delayed(_artificialDelay);

      final int safePage = page <= 0 ? 1 : page;

      final List<ConversationDTO> conversationDtos = _backendStorage
          .getConversationsPage(page: safePage, limit: _defaultLimit);

      final List<ConversationTile> result = <ConversationTile>[];

      for (final ConversationDTO dto in conversationDtos) {
        if (dto.isDeleted) {
          continue;
        }

        final Conversation conversation = Conversation.fromDTO(dto);

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
    } catch (e, st) {
      _logger.exception(e, st);
      rethrow;
    }
  }

  @override
  Future<bool> toggleNotifications({
    required String conversationId,
    required bool newNotificationsStatus,
  }) async {
    await Future<void>.delayed(_artificialDelay);
    return true;
  }

  void pushCreated(ConversationTile conversationTile) {
    final Conversation conversation = conversationTile.conversation;
    final ConversationDTO conversationDto = _mapConversationToDto(conversation);

    final ConversationDTO? existing = _backendStorage.getConversationById(
      conversation.id,
    );

    if (existing == null) {
      _backendStorage.addConversation(conversationDto);
    } else {
      _backendStorage.updateConversation(conversationDto);
    }

    final Message? lastMessage = conversationTile.lastMessage;
    if (lastMessage != null) {
      final MessageDTO messageDto = _mapMessageToDto(lastMessage);

      final MessageDTO? existingMessage = _backendStorage.getMessageById(
        lastMessage.id,
      );

      if (existingMessage == null) {
        _backendStorage.addMessage(messageDto);
      } else {
        _backendStorage.updateMessage(messageDto);
      }
    }

    _updatesController.add((
      kind: ConversationTileUpdateType.created,
      conversationTile: conversationTile,
    ));
  }

  void pushUpdated(ConversationTile conversationTile) {
    final Conversation conversation = conversationTile.conversation;
    final ConversationDTO conversationDto = _mapConversationToDto(conversation);

    final ConversationDTO? existing = _backendStorage.getConversationById(
      conversation.id,
    );

    if (existing == null) {
      _backendStorage.addConversation(conversationDto);
    } else {
      _backendStorage.updateConversation(conversationDto);
    }

    final Message? lastMessage = conversationTile.lastMessage;
    if (lastMessage != null) {
      final MessageDTO messageDto = _mapMessageToDto(lastMessage);

      final MessageDTO? existingMessage = _backendStorage.getMessageById(
        lastMessage.id,
      );

      if (existingMessage == null) {
        _backendStorage.addMessage(messageDto);
      } else {
        _backendStorage.updateMessage(messageDto);
      }
    }

    _updatesController.add((
      kind: ConversationTileUpdateType.updated,
      conversationTile: conversationTile,
    ));
  }

  void pushDeleted(String conversationId) {
    final ConversationDTO? updatedDto = _backendStorage.markConversationDeleted(
      conversationId: conversationId,
      deletedByUserId: 'mock-system',
    );

    if (updatedDto == null) {
      return;
    }

    final Conversation conversation = Conversation.fromDTO(updatedDto);

    final ({Message? lastMessage, String? companionId}) lastMessageData =
        _getLastMessageAndCompanionForConversation(conversation);

    final ConversationTile removedTile = ConversationTile(
      conversation: conversation,
      lastMessage: lastMessageData.lastMessage,
      companionId: lastMessageData.companionId,
    );

    _updatesController.add((
      kind: ConversationTileUpdateType.deleted,
      conversationTile: removedTile,
    ));
  }

  Future<void> dispose() async {
    await _updatesController.close();
  }

  void _seedInitialTiles({required List<ConversationTile>? initialTiles}) {
    if (initialTiles == null || initialTiles.isEmpty) {
      return;
    }

    for (final ConversationTile tile in initialTiles) {
      final Conversation conversation = tile.conversation;
      final ConversationDTO conversationDto = _mapConversationToDto(
        conversation,
      );

      final ConversationDTO? existingConversation = _backendStorage
          .getConversationById(conversation.id);

      if (existingConversation == null) {
        _backendStorage.addConversation(conversationDto);
      } else {
        _backendStorage.updateConversation(conversationDto);
      }

      final Message? lastMessage = tile.lastMessage;
      if (lastMessage != null) {
        final MessageDTO messageDto = _mapMessageToDto(lastMessage);

        final MessageDTO? existingMessage = _backendStorage.getMessageById(
          lastMessage.id,
        );

        if (existingMessage == null) {
          _backendStorage.addMessage(messageDto);
        } else {
          _backendStorage.updateMessage(messageDto);
        }
      }
    }
  }

  ({Message? lastMessage, String? companionId})
  _getLastMessageAndCompanionForConversation(Conversation conversation) {
    final List<MessageDTO> messageDtos = _backendStorage
        .getMessagesForConversation(
          conversationId: conversation.id,
          page: 1,
          limit: 1000000,
        );

    if (messageDtos.isEmpty) {
      return (lastMessage: null, companionId: null);
    }

    if (conversation.type != ConversationType.private) {
      final MessageDTO lastDto = messageDtos.last;
      return (lastMessage: Message.fromDTO(lastDto), companionId: null);
    }

    final Set<String> senderIds = <String>{};
    for (final MessageDTO dto in messageDtos) {
      senderIds.add(dto.senderId);
    }

    if (senderIds.isEmpty) {
      final MessageDTO lastDto = messageDtos.last;
      return (lastMessage: Message.fromDTO(lastDto), companionId: null);
    }

    final String companionId = senderIds.first;

    MessageDTO? lastCompanionMessageDto;
    for (final MessageDTO dto in messageDtos.reversed) {
      if (dto.senderId == companionId) {
        lastCompanionMessageDto = dto;
        break;
      }
    }

    final MessageDTO effectiveLastDto =
        lastCompanionMessageDto ?? messageDtos.last;

    return (
      lastMessage: Message.fromDTO(effectiveLastDto),
      companionId: companionId,
    );
  }

  ConversationDTO _mapConversationToDto(Conversation conversation) {
    return ConversationDTO(
      conversationId: conversation.id,
      createdBy: conversation.createdByUserId,
      type: conversation.type.value,
      title: conversation.title,
      description: conversation.description,
      avatarFileId: conversation.avatarFileId,
      isDeleted: conversation.isDeleted,
      deletedAt: conversation.deletedAt,
      deletedBy: conversation.deletedByUserId,
      createdAt: conversation.createdAt,
      updatedAt: conversation.updatedAt,
    );
  }

  MessageDTO _mapMessageToDto(Message message) {
    return MessageDTO(
      messageId: message.id,
      conversationId: message.conversationId,
      senderId: message.senderId,
      message: message.text,
      hasAttachments: message.hasAttachments,
      replyToMessageId: message.replyToMessageId,
      isPinned: message.isPinned ? true : null,
      editedAt: message.editedAt,
      isDeleted: message.isDeleted ? true : null,
      deletedAt: message.deletedAt,
      createdAt: message.createdAt,
      updatedAt: message.updatedAt,
    );
  }
}
