// ignore_for_file: sort_constructors_first

import 'dart:async';

import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/conversation/domain/domain.dart';
import 'package:locnet_app/features/conversations/data/data.dart';
import 'package:locnet_app/features/conversations/domain/domain.dart';
import 'package:locnet_app/features/message/data/data.dart';
import 'package:locnet_app/features/message/domain/domain.dart';

final class MockWebSocketConversationsListRepo
    implements IConversationsListRepo {
  MockWebSocketConversationsListRepo({
    required ILogger logger,
    List<ConversationTile>? initialTiles,
    Duration? artificialDelay,
    int? mockConversationsCount,
  }) : _logger = logger,
       _artificialDelay = artificialDelay ?? const Duration(milliseconds: 200),
       _tiles = List<ConversationTile>.from(
         initialTiles ??
             _createDefaultMockTiles(
               mockConversationsCount: mockConversationsCount,
             ),
       ),
       _updatesController =
           StreamController<ConversationsListUpdateRec>.broadcast();

  final ILogger _logger;
  final Duration _artificialDelay;
  final List<ConversationTile> _tiles;
  final StreamController<ConversationsListUpdateRec> _updatesController;

  static const int _defaultLimit = 20;

  static const int _minMockCount = 30;
  static const int _maxMockCount = 35;
  static const int _defaultMockCount = 32;

  @override
  Stream<ConversationsListUpdateRec> get conversationsUpdates =>
      _updatesController.stream;

  @override
  Future<List<ConversationTile>> loadConversationsList({int page = 1}) async {
    try {
      await Future<void>.delayed(_artificialDelay);

      final int safePage = page <= 0 ? 1 : page;
      final int startIndex = (safePage - 1) * _defaultLimit;

      if (startIndex >= _tiles.length) {
        return <ConversationTile>[];
      }

      final int endIndex = (startIndex + _defaultLimit).clamp(0, _tiles.length);

      return _tiles.sublist(startIndex, endIndex);
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
    _tiles.insert(0, conversationTile);
    _updatesController.add((
      kind: ConversationTileUpdateType.created,
      conversationTile: conversationTile,
    ));
  }

  void pushUpdated(ConversationTile conversationTile) {
    final int existingIndex = _tiles.indexWhere(
      (ConversationTile existing) =>
          existing.conversation.id == conversationTile.conversation.id,
    );

    if (existingIndex >= 0) {
      _tiles[existingIndex] = conversationTile;
    } else {
      _tiles.insert(0, conversationTile);
    }

    _updatesController.add((
      kind: ConversationTileUpdateType.updated,
      conversationTile: conversationTile,
    ));
  }

  void pushDeleted(String conversationId) {
    final int existingIndex = _tiles.indexWhere(
      (ConversationTile tile) => tile.conversation.id == conversationId,
    );

    if (existingIndex < 0) {
      return;
    }

    final ConversationTile removedTile = _tiles.removeAt(existingIndex);

    _updatesController.add((
      kind: ConversationTileUpdateType.deleted,
      conversationTile: removedTile,
    ));
  }

  Future<void> dispose() async {
    await _updatesController.close();
  }

  static List<ConversationTile> _createDefaultMockTiles({
    int? mockConversationsCount,
  }) {
    final int requestedCount = mockConversationsCount ?? _defaultMockCount;

    final int effectiveCount = requestedCount.clamp(
      _minMockCount,
      _maxMockCount,
    );

    final DateTime now = DateTime.now();

    final List<ConversationTile> result = <ConversationTile>[];

    final int lastMessageThreshold = (effectiveCount * 0.9)
        .round(); // about 90%

    for (int index = 0; index < effectiveCount; index++) {
      final int humanIndex = index + 1;

      final ConversationType type;
      switch (index % 3) {
        case 0:
          type = ConversationType.private;
          break;
        case 1:
          type = ConversationType.group;
          break;
        default:
          type = ConversationType.channel;
          break;
      }

      final DateTime createdAt = now.subtract(Duration(days: humanIndex));
      final DateTime updatedAt = createdAt.add(
        Duration(minutes: humanIndex * 3),
      );

      final Conversation conversation = Conversation(
        id: 'mock-conversation-$humanIndex',
        createdByUserId: 'mock-user-${(index % 5) + 1}',
        type: type,
        title: _buildMockTitle(type: type, index: humanIndex),
        description: index.isEven
            ? 'Mock conversation description #$humanIndex'
            : null,
        avatarFileId: index.isOdd ? 'mock-avatar-file-$humanIndex' : null,
        isDeleted: false,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );

      final bool hasLastMessage = humanIndex <= lastMessageThreshold;

      final Message? lastMessage = hasLastMessage
          ? _buildMockMessage(conversation, index, now)
          : null;

      final ConversationTile tile = ConversationTile(
        conversation: conversation,
        lastMessage: lastMessage,
      );

      result.add(tile);
    }

    return result;
  }

  static String _buildMockTitle({
    required ConversationType type,
    required int index,
  }) {
    switch (type) {
      case ConversationType.private:
        return 'Direct chat #$index';
      case ConversationType.group:
        return 'Project group chat #$index';
      case ConversationType.channel:
        return 'News channel #$index';
    }
  }

  static Message _buildMockMessage(
    Conversation conversation,
    int index,
    DateTime now,
  ) {
    final int humanIndex = index + 1;

    final String text;
    switch (index % 3) {
      case 0:
        text = 'Hello, this is mock message #$humanIndex';
        break;
      case 1:
        text = 'Пример тестового сообщения №$humanIndex для списка диалогов';
        break;
      default:
        text = 'Salom, bu sinov xabari #$humanIndex';
        break;
    }

    final DateTime createdAt = now.subtract(Duration(minutes: humanIndex * 7));
    final DateTime updatedAt = createdAt.add(const Duration(minutes: 1));

    final bool hasAttachments = humanIndex % 5 == 0;

    final MessageDTO dto = MessageDTO(
      messageId: 'mock-message-$humanIndex',
      conversationId: conversation.id,
      senderId: 'mock-sender-${(index % 4) + 1}',
      message: text,
      hasAttachments: hasAttachments,
      isPinned: humanIndex % 8 == 0 ? true : null,
      editedAt: humanIndex % 6 == 0
          ? createdAt.add(const Duration(minutes: 2))
          : null,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );

    return Message.fromDTO(dto);
  }
}
