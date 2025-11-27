// ignore_for_file: sort_constructors_first

import 'dart:async';
import 'dart:math';

import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/conversation/data/data.dart';
import 'package:locnet_app/features/conversation/subfeatures/private/data/data.dart';
import 'package:locnet_app/features/message/data/data.dart';
import 'package:locnet_app/features/message/domain/domain.dart';
import 'package:locnet_app/mock/mock_backend_storage.dart';

final class MockPrivateConversationRepo implements IPrivateConversationRepo {
  MockPrivateConversationRepo({
    required ILogger logger,
    required MockBackendStorage backendStorage,
    Duration? artificialDelay,
    int? pageLimit,
  }) : _logger = logger,
       _backendStorage = backendStorage,
       _artificialDelay = artificialDelay ?? const Duration(milliseconds: 200),
       _pageLimit = pageLimit ?? 30,
       _random = Random(42),
       _updatesController =
           StreamController<PrivateConversationMessageUpdateRec>.broadcast();

  final ILogger _logger;
  final MockBackendStorage _backendStorage;
  final Duration _artificialDelay;
  final int _pageLimit;
  final Random _random;
  final StreamController<PrivateConversationMessageUpdateRec>
  _updatesController;

  static const int _maxLimit = 1000;

  @override
  Stream<PrivateConversationMessageUpdateRec> get messagesUpdates =>
      _updatesController.stream;

  @override
  Future<bool> blockCompanion({
    required String companionId,
    required String blockedByUserId,
    required String reason,
  }) async {
    try {
      await Future<void>.delayed(_artificialDelay);

      // In real implementation there would be API/WebSocket call.
      return true;
    } catch (e, st) {
      _logger.exception(e, st);
      rethrow;
    }
  }

  @override
  Future<User> getCompanion({required String conversationId}) async {
    try {
      await Future<void>.delayed(_artificialDelay);

      final ConversationDTO? conversation = _backendStorage.getConversationById(
        conversationId,
      );

      if (conversation == null) {
        throw StateError('Conversation $conversationId not found');
      }

      final List<MessageDTO> messageDtos = _backendStorage
          .getMessagesForConversation(
            conversationId: conversationId,
            page: 1,
            limit: _maxLimit,
          );

      final Set<String> participantIds = <String>{};

      for (final MessageDTO dto in messageDtos) {
        participantIds.add(dto.senderId);
      }

      final String createdByUserId = conversation.createdBy;

      String companionId;

      if (participantIds.isEmpty) {
        companionId = createdByUserId;
      } else if (participantIds.length == 1) {
        companionId = participantIds.first;
      } else {
        if (participantIds.contains(createdByUserId)) {
          companionId = participantIds.firstWhere(
            (String id) => id != createdByUserId,
          );
        } else {
          companionId = participantIds.first;
        }
      }

      final UserDTO? userDto = _backendStorage.getUserById(companionId);

      if (userDto == null) {
        throw StateError('User $companionId not found in storage');
      }

      final User companion = User.fromDTO(userDto);

      return companion;
    } catch (e, st) {
      _logger.exception(e, st);
      rethrow;
    }
  }

  @override
  Future<bool> deleteConversation({
    required String conversationId,
    required bool deleteAtRecipient,
  }) async {
    try {
      await Future<void>.delayed(_artificialDelay);

      final ConversationDTO? updated = _backendStorage.markConversationDeleted(
        conversationId: conversationId,
        deletedByUserId: 'mock-current-user',
      );

      return updated != null;
    } catch (e, st) {
      _logger.exception(e, st);
      rethrow;
    }
  }

  @override
  Future<List<Message>> loadMessagesPage({
    required String conversationId,
    int page = 1,
  }) async {
    try {
      await Future<void>.delayed(_artificialDelay);

      final int safePage = page <= 0 ? 1 : page;
      final int safeLimit = _pageLimit.clamp(1, _maxLimit);

      final List<MessageDTO> messageDtos = _backendStorage
          .getMessagesForConversation(
            conversationId: conversationId,
            page: safePage,
            limit: safeLimit,
          );

      final List<Message> result = <Message>[];

      for (final MessageDTO dto in messageDtos) {
        if (dto.isDeleted == true) {
          continue;
        }
        result.add(Message.fromDTO(dto));
      }

      return result;
    } catch (e, st) {
      _logger.exception(e, st);
      rethrow;
    }
  }

  @override
  Future<Message> sendMessage({
    required String conversationId,
    required String senderId,
    required Message message,
    String? replyToMessageId,
  }) async {
    try {
      await Future<void>.delayed(_artificialDelay);

      final DateTime now = DateTime.now();
      final String messageId = _buildMessageId(conversationId: conversationId);

      // Incoming Message используется как шаблон: берем text, hasAttachments и т.д.,
      // а id, createdAt и updatedAt генерим на стороне репозитория.
      final MessageDTO dtoToStore = MessageDTO(
        messageId: messageId,
        conversationId: conversationId,
        senderId: senderId,
        message: message.text,
        hasAttachments: message.hasAttachments,
        replyToMessageId: replyToMessageId ?? message.replyToMessageId,
        isPinned: message.isPinned ? true : null,
        createdAt: now,
        updatedAt: now,
      );

      _backendStorage.addMessage(dtoToStore);

      final Message storedMessage = Message.fromDTO(dtoToStore);

      _updatesController.add((
        kind: PrivateConversationMessageUpdateType.created,
        message: storedMessage,
      ));

      return storedMessage;
    } catch (e, st) {
      _logger.exception(e, st);
      rethrow;
    }
  }

  @override
  Future<Message?> editMessage({
    required String messageId,
    required Message newMessage,
  }) async {
    try {
      await Future<void>.delayed(_artificialDelay);

      final MessageDTO? existing = _backendStorage.getMessageById(messageId);
      if (existing == null) {
        return null;
      }

      final DateTime now = DateTime.now();

      // Поля идентичности берем из existing, а изменяемые поля берем из newMessage.
      final MessageDTO updatedDto = MessageDTO(
        messageId: existing.messageId,
        conversationId: existing.conversationId,
        senderId: existing.senderId,
        message: newMessage.text,
        hasAttachments: newMessage.hasAttachments,
        replyToMessageId: newMessage.replyToMessageId,
        isPinned: newMessage.isPinned ? true : null,
        editedAt: now,
        isDeleted: existing.isDeleted,
        deletedAt: existing.deletedAt,
        createdAt: existing.createdAt,
        updatedAt: now,
      );

      final MessageDTO? stored = _backendStorage.updateMessage(updatedDto);
      if (stored == null) {
        return null;
      }

      final Message storedMessage = Message.fromDTO(stored);

      _updatesController.add((
        kind: PrivateConversationMessageUpdateType.updated,
        message: storedMessage,
      ));

      return storedMessage;
    } catch (e, st) {
      _logger.exception(e, st);
      rethrow;
    }
  }

  @override
  Future<bool> deleteMessage({
    required String messageId,
    required bool deleteAtRecipient,
  }) async {
    try {
      await Future<void>.delayed(_artificialDelay);

      final MessageDTO? updated = _backendStorage.markMessageDeleted(
        messageId: messageId,
      );
      if (updated == null) {
        return false;
      }

      final Message message = Message.fromDTO(updated);

      _updatesController.add((
        kind: PrivateConversationMessageUpdateType.deleted,
        message: message,
      ));

      return true;
    } catch (e, st) {
      _logger.exception(e, st);
      rethrow;
    }
  }

  Future<void> dispose() async {
    await _updatesController.close();
  }

  String _buildMessageId({required String conversationId}) {
    final int randomSuffix = _random.nextInt(1 << 31);
    final String sanitizedConversationId = conversationId.replaceAll(
      RegExp(r'[^a-zA-Z0-9\-]'),
      '-',
    );
    return 'mock-msg-$sanitizedConversationId-$randomSuffix';
  }

  // Helpers to simulate WebSocket events in tests/demo.

  void pushIncomingTextMessage({
    required String conversationId,
    required String senderId,
    required String text,
  }) {
    final DateTime now = DateTime.now();
    final String messageId = _buildMessageId(conversationId: conversationId);

    final MessageDTO dto = MessageDTO(
      messageId: messageId,
      conversationId: conversationId,
      senderId: senderId,
      message: text,
      hasAttachments: false,
      createdAt: now,
      updatedAt: now,
    );

    _backendStorage.addMessage(dto);

    final Message message = Message.fromDTO(dto);

    _updatesController.add((
      kind: PrivateConversationMessageUpdateType.created,
      message: message,
    ));
  }

  void pushUpdatedMessage(Message message) {
    final MessageDTO dto = message.toDTO();

    final MessageDTO? stored = _backendStorage.updateMessage(dto);
    if (stored == null) {
      return;
    }

    final Message normalized = Message.fromDTO(stored);

    _updatesController.add((
      kind: PrivateConversationMessageUpdateType.updated,
      message: normalized,
    ));
  }

  void pushDeletedMessage(String messageId) {
    final MessageDTO? updated = _backendStorage.markMessageDeleted(
      messageId: messageId,
    );
    if (updated == null) {
      return;
    }

    final Message message = Message.fromDTO(updated);

    _updatesController.add((
      kind: PrivateConversationMessageUpdateType.deleted,
      message: message,
    ));
  }
}
