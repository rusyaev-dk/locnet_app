import 'dart:async';

import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/conversation/data/data.dart';
import 'package:locnet_app/features/conversation/domain/domain.dart';

final class MockWebSocketConversationRepo implements IConversationRepo {
  MockWebSocketConversationRepo({
    required ILogger logger,
    List<Conversation>? initialConversations,
    Duration? artificialDelay,
    int? mockConversationsCount,
  }) : _logger = logger,
       _artificialDelay = artificialDelay ?? const Duration(milliseconds: 200),
       _conversations = List<Conversation>.from(
         initialConversations ??
             _createDefaultMockConversations(
               mockConversationsCount: mockConversationsCount,
             ),
       ),
       _updatesController =
           StreamController<ConversationsUpdateRec>.broadcast();

  final ILogger _logger;
  final Duration _artificialDelay;
  final List<Conversation> _conversations;
  final StreamController<ConversationsUpdateRec> _updatesController;

  static const int _defaultLimit = 20;

  static const int _minDefaultMockConversationsCount = 10;
  static const int _maxDefaultMockConversationsCount = 20;
  static const int _defaultMockConversationsCount = 15;

  @override
  Stream<ConversationsUpdateRec> get conversationsUpdates =>
      _updatesController.stream;

  @override
  Future<List<Conversation>> loadConversationsList({int page = 1}) async {
    try {
      await Future<void>.delayed(_artificialDelay);

      final int safePage = page <= 0 ? 1 : page;
      final int startIndex = (safePage - 1) * _defaultLimit;

      if (startIndex >= _conversations.length) {
        return <Conversation>[];
      }

      final int endIndex = (startIndex + _defaultLimit).clamp(
        0,
        _conversations.length,
      );

      return _conversations.sublist(startIndex, endIndex);
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

  void pushCreated(Conversation conversation) {
    _conversations.insert(0, conversation);
    _updatesController.add((
      kind: ConversationUpdateType.created,
      conversation: conversation,
    ));
  }

  void pushUpdated(Conversation conversation) {
    final int existingIndex = _conversations.indexWhere(
      (Conversation existing) => existing.id == conversation.id,
    );

    if (existingIndex >= 0) {
      _conversations[existingIndex] = conversation;
    } else {
      _conversations.insert(0, conversation);
    }

    _updatesController.add((
      kind: ConversationUpdateType.updated,
      conversation: conversation,
    ));
  }

  void pushDeleted(String conversationId) {
    final int existingIndex = _conversations.indexWhere(
      (Conversation conversation) => conversation.id == conversationId,
    );

    if (existingIndex < 0) {
      return;
    }

    final Conversation removedConversation = _conversations.removeAt(
      existingIndex,
    );

    _updatesController.add((
      kind: ConversationUpdateType.deleted,
      conversation: removedConversation,
    ));
  }

  Future<void> dispose() async {
    await _updatesController.close();
  }

  static List<Conversation> _createDefaultMockConversations({
    int? mockConversationsCount,
  }) {
    final int requestedCount =
        mockConversationsCount ?? _defaultMockConversationsCount;

    final int effectiveCount = requestedCount.clamp(
      _minDefaultMockConversationsCount,
      _maxDefaultMockConversationsCount,
    );

    final DateTime now = DateTime.now();

    final List<Conversation> result = <Conversation>[];

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
        Duration(minutes: humanIndex * 5),
      );

      final Conversation conversation = Conversation(
        id: 'mock-conversation-$humanIndex',
        createdByUserId: 'mock-user-${(index % 4) + 1}',
        type: type,
        title: 'Mock conversation #$humanIndex',
        description: index.isEven
            ? 'Mock description for conversation #$humanIndex'
            : null,
        avatarFileId: index.isOdd ? 'mock-avatar-file-$humanIndex' : null,
        isDeleted: false,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );

      result.add(conversation);
    }

    return result;
  }
}
