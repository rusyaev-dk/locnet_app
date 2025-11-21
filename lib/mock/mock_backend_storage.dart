// ignore_for_file: sort_constructors_first

import 'dart:math';

import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/conversation/data/data.dart';
import 'package:locnet_app/features/conversation/domain/domain.dart';
import 'package:locnet_app/features/message/data/data.dart';
import 'package:locnet_app/mock/mock_users.dart';

/// Single in-memory storage for users, conversations and messages.
final class MockBackendStorage {
  MockBackendStorage()
    : _random = Random(42),
      _now = DateTime.now(),
      _usersById = <String, UserDTO>{},
      _conversationsById = <String, ConversationDTO>{},
      _messagesById = <String, MessageDTO>{},
      _conversationMessagesIds = <String, List<String>>{} {
    _seedUsers();
    _seedConversationsAndMessages();
  }

  final Random _random;
  final DateTime _now;

  final Map<String, UserDTO> _usersById;
  final Map<String, ConversationDTO> _conversationsById;
  final Map<String, MessageDTO> _messagesById;
  final Map<String, List<String>> _conversationMessagesIds;

  // ---------------- USERS ----------------

  UserDTO? getUserById(String userId) => _usersById[userId];

  List<UserDTO> getAllUsers() => _usersById.values.toList(growable: false);

  bool updateUser(UserDTO updatedUser) {
    if (!_usersById.containsKey(updatedUser.userId)) {
      return false;
    }
    _usersById[updatedUser.userId] = updatedUser;
    return true;
  }

  // ---------------- CONVERSATIONS ----------------

  ConversationDTO? getConversationById(String conversationId) =>
      _conversationsById[conversationId];

  List<ConversationDTO> getAllConversations() =>
      _conversationsById.values.toList(growable: false)..sort(
        (ConversationDTO a, ConversationDTO b) =>
            b.updatedAt.compareTo(a.updatedAt),
      );

  List<ConversationDTO> getConversationsPage({
    required int page,
    required int limit,
  }) {
    final int safePage = page <= 0 ? 1 : page;
    final List<ConversationDTO> sorted = getAllConversations();

    final int startIndex = (safePage - 1) * limit;
    if (startIndex >= sorted.length) {
      return <ConversationDTO>[];
    }

    final int endIndex = (startIndex + limit).clamp(0, sorted.length);
    return sorted.sublist(startIndex, endIndex);
  }

  ConversationDTO addConversation(ConversationDTO conversation) {
    _conversationsById[conversation.conversationId] = conversation;
    _conversationMessagesIds.putIfAbsent(
      conversation.conversationId,
      () => <String>[],
    );
    return conversation;
  }

  ConversationDTO? updateConversation(ConversationDTO updatedConversation) {
    if (!_conversationsById.containsKey(updatedConversation.conversationId)) {
      return null;
    }
    _conversationsById[updatedConversation.conversationId] =
        updatedConversation;
    return updatedConversation;
  }

  /// Insert or update conversation in storage.
  ConversationDTO upsertConversation(ConversationDTO conversation) {
    final bool exists = _conversationsById.containsKey(
      conversation.conversationId,
    );

    if (exists) {
      _conversationsById[conversation.conversationId] = conversation;
    } else {
      _conversationsById[conversation.conversationId] = conversation;
      _conversationMessagesIds.putIfAbsent(
        conversation.conversationId,
        () => <String>[],
      );
    }

    return conversation;
  }

  ConversationDTO? markConversationDeleted({
    required String conversationId,
    required String deletedByUserId,
  }) {
    final ConversationDTO? existing = _conversationsById[conversationId];
    if (existing == null) {
      return null;
    }

    final ConversationDTO updated = ConversationDTO(
      conversationId: existing.conversationId,
      createdBy: existing.createdBy,
      type: existing.type,
      title: existing.title,
      description: existing.description,
      avatarFileId: existing.avatarFileId,
      isDeleted: true,
      deletedAt: _now,
      deletedBy: deletedByUserId,
      createdAt: existing.createdAt,
      updatedAt: _now,
    );

    _conversationsById[conversationId] = updated;
    return updated;
  }

  /// Logically deletes conversation and returns updated DTO
  /// (used by MockWebSocketConversationRepo.pushDeleted).
  ConversationDTO? removeConversationById(String conversationId) {
    final ConversationDTO? existing = _conversationsById[conversationId];
    if (existing == null) {
      return null;
    }

    final String deletedByUserId = existing.deletedBy ?? 'mock-system';

    return markConversationDeleted(
      conversationId: conversationId,
      deletedByUserId: deletedByUserId,
    );
  }

  // ---------------- MESSAGES ----------------

  MessageDTO? getMessageById(String messageId) => _messagesById[messageId];

  List<MessageDTO> getMessagesForConversation({
    required String conversationId,
    required int page,
    required int limit,
  }) {
    final List<String>? messageIds = _conversationMessagesIds[conversationId];

    if (messageIds == null || messageIds.isEmpty) {
      return <MessageDTO>[];
    }

    final List<MessageDTO> sorted =
        messageIds
            .map((String id) => _messagesById[id])
            .whereType<MessageDTO>()
            .toList(growable: false)
          ..sort(
            (MessageDTO a, MessageDTO b) => a.createdAt.compareTo(b.createdAt),
          );

    final int safePage = page <= 0 ? 1 : page;
    final int startIndex = (safePage - 1) * limit;
    if (startIndex >= sorted.length) {
      return <MessageDTO>[];
    }

    final int endIndex = (startIndex + limit).clamp(0, sorted.length);
    return sorted.sublist(startIndex, endIndex);
  }

  MessageDTO addMessage(MessageDTO newMessage) {
    _messagesById[newMessage.messageId] = newMessage;
    final List<String> messagesIds = _conversationMessagesIds.putIfAbsent(
      newMessage.conversationId,
      () => <String>[],
    );
    messagesIds.add(newMessage.messageId);
    return newMessage;
  }

  MessageDTO? updateMessage(MessageDTO updatedMessage) {
    if (!_messagesById.containsKey(updatedMessage.messageId)) {
      return null;
    }
    _messagesById[updatedMessage.messageId] = updatedMessage;
    return updatedMessage;
  }

  MessageDTO? markMessageDeleted({required String messageId}) {
    final MessageDTO? existing = _messagesById[messageId];
    if (existing == null) {
      return null;
    }

    final MessageDTO updated = MessageDTO(
      messageId: existing.messageId,
      conversationId: existing.conversationId,
      senderId: existing.senderId,
      message: existing.message,
      hasAttachments: existing.hasAttachments,
      replyToMessageId: existing.replyToMessageId,
      isPinned: existing.isPinned,
      editedAt: existing.editedAt,
      isDeleted: true,
      deletedAt: _now,
      createdAt: existing.createdAt,
      updatedAt: _now,
    );

    _messagesById[messageId] = updated;
    return updated;
  }

  // ---------------- SEEDING ----------------

  void _seedUsers() {
    for (final User user in MockUsers.allUsers) {
      final UserDTO dto = UserDTO(
        userId: user.userId,
        username: user.username,
        languageCode: user.languageCode,
        password: 'hash_${user.username}_pw',
        firstName: user.firstName,
        lastName: user.lastName,
        description: user.description,
        avatarId: user.avatarId,
        isDeleted: user.isDeleted,
        isBanned: user.isBanned,
        createdAt: user.createdAt,
        updatedAt: user.updatedAt,
      );
      _usersById[user.userId] = dto;
    }
  }

  void _seedConversationsAndMessages() {
    const int conversationsCount = 15;
    final List<User> users = MockUsers.allUsers
        .where((User user) => !user.isDeleted && !user.isBanned)
        .toList();

    if (users.length < 2) {
      return;
    }

    for (int index = 0; index < conversationsCount; index++) {
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

      final List<User> participants = _pickParticipants(
        users: users,
        type: type,
      );
      final User createdByUser = participants.first;

      final DateTime createdAt = _now.subtract(
        Duration(
          days: _random.nextInt(60) + humanIndex,
          hours: _random.nextInt(24),
          minutes: _random.nextInt(60),
        ),
      );
      final DateTime updatedAt = createdAt.add(
        Duration(minutes: humanIndex * 5),
      );

      final String conversationId =
          'mock-conversation-${humanIndex.toString().padLeft(3, '0')}';

      final String typeValue = switch (type) {
        ConversationType.private => ConversationType.private.value,
        ConversationType.group => ConversationType.group.value,
        ConversationType.channel => ConversationType.channel.value,
      };

      final ConversationDTO conversationDTO = ConversationDTO(
        conversationId: conversationId,
        createdBy: createdByUser.userId,
        type: typeValue,
        title: _buildConversationTitle(
          type: type,
          participants: participants,
          index: humanIndex,
        ),
        description: type == ConversationType.channel
            ? 'Mock channel description #$humanIndex'
            : null,
        isDeleted: false,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );

      addConversation(conversationDTO);

      final int messagesCount = _random.nextInt(16) + 5;
      _seedMessagesForConversation(
        conversationId: conversationId,
        participants: participants,
        baseCreatedAt: createdAt,
        count: messagesCount,
      );
    }
  }

  List<User> _pickParticipants({
    required List<User> users,
    required ConversationType type,
  }) {
    if (type == ConversationType.private) {
      final User first = users[_random.nextInt(users.length)];
      User second = users[_random.nextInt(users.length)];
      while (second.userId == first.userId) {
        second = users[_random.nextInt(users.length)];
      }
      return <User>[first, second];
    }

    final int minCount = type == ConversationType.group ? 3 : 2;
    final int maxCount = type == ConversationType.group ? 6 : 8;
    final int targetCount =
        minCount +
        _random.nextInt((maxCount - minCount + 1).clamp(1, maxCount));

    final List<User> shuffled = List<User>.from(users);
    shuffled.shuffle(_random);

    return shuffled.take(targetCount).toList();
  }

  String _buildConversationTitle({
    required ConversationType type,
    required List<User> participants,
    required int index,
  }) {
    switch (type) {
      case ConversationType.private:
        if (participants.length >= 2) {
          final User a = participants[0];
          final User b = participants[1];
          return '${a.firstName} & ${b.firstName}';
        }
        return 'Private chat #$index';
      case ConversationType.group:
        return 'Group chat #$index';
      case ConversationType.channel:
        return 'Channel #$index';
    }
  }

  void _seedMessagesForConversation({
    required String conversationId,
    required List<User> participants,
    required DateTime baseCreatedAt,
    required int count,
  }) {
    const List<String> sampleTexts = <String>[
      'Hello there',
      'How is it going?',
      'This is a mock message for testing.',
      'Let us test pagination.',
      'Another random message.',
      'Did you see the latest update?',
      'Looks good to me.',
      'We should refactor this later.',
      'Any thoughts on this?',
      'Mock backend storage is working.',
    ];

    DateTime currentTime = baseCreatedAt;

    for (int index = 0; index < count; index++) {
      currentTime = currentTime.add(Duration(minutes: _random.nextInt(20) + 1));

      final User sender = participants[_random.nextInt(participants.length)];

      final String messageId =
          'mock-message-${conversationId.split('-').last}-${index.toString().padLeft(3, '0')}';

      final String? text = _random.nextBool()
          ? sampleTexts[_random.nextInt(sampleTexts.length)]
          : null;

      final bool hasAttachments = !_random.nextBool();

      final MessageDTO messageDTO = MessageDTO(
        messageId: messageId,
        conversationId: conversationId,
        senderId: sender.userId,
        message: text,
        hasAttachments: hasAttachments,
        isPinned: false,
        isDeleted: false,
        createdAt: currentTime,
        updatedAt: currentTime,
      );

      addMessage(messageDTO);
    }
  }
}
