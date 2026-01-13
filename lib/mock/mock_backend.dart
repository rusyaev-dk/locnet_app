import 'dart:math';

import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/conversation/data/data.dart';
import 'package:locnet_app/features/conversation/domain/domain.dart';
import 'package:locnet_app/features/message/data/data.dart';
import 'package:locnet_app/features/message/domain/domain.dart';
import 'package:locnet_app/mock/mock.dart';
import 'package:uuid/uuid.dart';

final class MockInMemoryBackend {
  MockInMemoryBackend({
    int usersCount = 100,
    int privatesCount = 20,
    int groupsCount = 10,
    int channelsCount = 5,
  }) {
    _seedUsers(usersCount);
    _seedConversations(
      privateCount: privatesCount,
      groupCount: groupsCount,
      channelCount: channelsCount,
    );
    _seedConversationsScripts();

    final adminUser = MockUsers.adminUser;
    _users[adminUser.userId] = adminUser;
  }

  final Random _random = Random(42);

  final int _usersPageSize = 20;
  final int _conversationsPageSize = 20;
  final int _conversationParticipantsPageSize = 20;
  final int _conversationMessagesPageSize = 20;
  
  // Storage

  final Map<String, UserDto> _users = {};
  final Map<String, ConversationDto> _conversations = {};
  final Map<String, List<ConversationParticipantDto>>
  _conversationParticipants = {};
  final Map<String, List<MessageDto>> _conversationsMessages =
      {}; // conversationId: List<MessageDto>[]

  // --------------------- USERS

  UserDto getUserById({required String userId}) {
    if (!_users.containsKey(userId)) {
      throw StateError("User $userId not found");
    }
    return _users[userId]!;
  }

  List<UserDto> getAllUsers({int page = 1}) {
    final List<UserDto> allUsers = _users.values.toList(growable: false);
    return _paginateList(items: allUsers, page: page, pageSize: _usersPageSize);
  }

  UserDto updateUser(User updatedUser) {
    final UserDto? existingDto = _users[updatedUser.userId];
    if (existingDto == null) {
      throw StateError(
        "Couldn't update user: user with id ${updatedUser.userId} not  found",
      );
    }

    final UserDto updatedDto = existingDto.copyWith(
      userId: updatedUser.userId,
      username: updatedUser.username,
      firstName: updatedUser.firstName,
      patronymic: updatedUser.patronymic,
      lastName: updatedUser.lastName,
      languageCode: updatedUser.languageCode,
      description: updatedUser.description,
      avatarId: updatedUser.avatarId,
      isDeleted: updatedUser.isDeleted,
      isBanned: updatedUser.isBanned,
      createdAt: updatedUser.createdAt,
      updatedAt: updatedUser.updatedAt,
    );

    _users[updatedUser.userId] = updatedDto;
    return updatedDto;
  }

  // --------------------- CONVERSATIONS

  ConversationDto getConversationById(String conversationId) {
    if (!_conversations.containsKey(conversationId)) {
      throw StateError("Conversation $conversationId not found");
    }
    return _conversations[conversationId]!;
  }

  List<ConversationDto> getAllConversations({int page = 1}) {
    final List<ConversationDto> allConversations = _conversations.values.toList(
      growable: false,
    );
    return _paginateList(
      items: allConversations,
      page: page,
      pageSize: _conversationsPageSize,
    );
  }

  ConversationDto updateConversation(Conversation updatedConversation) {
    final ConversationDto? existingDto =
        _conversations[updatedConversation.conversationId];
    if (existingDto == null) {
      throw StateError(
        "Couldn't update conversation: conversation with id ${updatedConversation.conversationId} not  found",
      );
    }

    final ConversationDto updatedDto = existingDto.copyWith(
      conversationId: updatedConversation.conversationId,
      initiatorId: updatedConversation.initiatorId,
      type: updatedConversation.type.value,
      title: updatedConversation.title,
      description: updatedConversation.description,
      avatarFileId: updatedConversation.avatarFileId,
      isDeleted: updatedConversation.isDeleted,
      deletedAt: updatedConversation.deletedAt,
      deletedBy: updatedConversation.deletedByUserId,
      createdAt: updatedConversation.createdAt,
      updatedAt: updatedConversation.updatedAt,
    );

    _conversations[updatedConversation.conversationId] = updatedDto;
    return updatedDto;
  }

  bool deleteConversation({required String conversationId}) {
    if (_conversations[conversationId] == null) {
      return false;
    }
    _conversations.remove(conversationId);
    return true;
  }

  // --------------------- MESSAGES

  MessageDto addMessage({required Message newMessage}) {
    if (!_conversationsMessages.containsKey(newMessage.conversationId)) {
      throw StateError(
        "Failed to add message: no conversation with id = ${newMessage.conversationId}",
      );
    }

    final messageDto = MessageDto(
      messageId: const Uuid().v4(),
      clientMessageId: const Uuid().v4(),
      deliveryStatus: MessageDeliveryStatus.sent.toString(),
      conversationId: newMessage.conversationId,
      senderId: newMessage.senderId,
      hasAttachments: newMessage.hasAttachments,
      createdAt: newMessage.createdAt,
      updatedAt: newMessage.updatedAt,
    );
    _conversationsMessages[newMessage.conversationId]!.add(messageDto);
    return messageDto;
  }

  MessageDto updateMessage({required Message updatedMessage}) {
    final conversationId = updatedMessage.conversationId;

    if (!_conversationsMessages.containsKey(conversationId) ||
        !_conversationsMessages[conversationId]!.contains(updatedMessage)) {
      throw StateError("Failed to update message ${updatedMessage.messageId}");
    }

    final index = _conversationsMessages[conversationId]!.indexWhere(
      (convMessage) => convMessage.messageId == updatedMessage.messageId,
    );
    final MessageDto existingDto =
        _conversationsMessages[conversationId]![index];

    final MessageDto updatedDto = existingDto.copyWith(
      messageId: updatedMessage.messageId,
      conversationId: updatedMessage.conversationId,
      senderId: updatedMessage.senderId,
      text: updatedMessage.text,
      hasAttachments: updatedMessage.hasAttachments,
      replyToMessageId: updatedMessage.replyToMessageId,
      isPinned: updatedMessage.isPinned,
      editedAt: updatedMessage.editedAt,
      isDeleted: updatedMessage.isDeleted,
      deletedAt: updatedMessage.deletedAt,
      createdAt: updatedMessage.createdAt,
      updatedAt: updatedMessage.updatedAt,
    );

    _conversationsMessages[conversationId]!.replaceRange(index, index, [
      updatedDto,
    ]);

    return updatedDto;
  }

  bool deleteMessage({required Message message}) {
    final conversationId = message.conversationId;

    if (!_conversationsMessages.containsKey(conversationId) ||
        !_conversationsMessages[conversationId]!.contains(message)) {
      return false;
    }
    _conversationsMessages[conversationId]!.removeWhere(
      (convMessage) => convMessage.messageId == message.messageId,
    );
    return true;
  }

  List<MessageDto> getAllMessagesByConversationId({
    required String conversationId,
    int page = 1,
  }) {
    final List<MessageDto> messages =
        _conversationsMessages[conversationId]?.toList(growable: false) ??
        <MessageDto>[];

    return _paginateList(
      items: messages,
      page: page,
      pageSize: _conversationMessagesPageSize,
    );
  }

  // --------------------- Conversation participants

  List<ConversationParticipantDto> getAllParticipants({
    required String conversationId,
    int page = 1,
  }) {
    final List<ConversationParticipantDto> participants =
        _conversationParticipants[conversationId]?.toList(growable: false) ??
        <ConversationParticipantDto>[];

    return _paginateList(
      items: participants,
      page: page,
      pageSize: _conversationParticipantsPageSize,
    );
  }

  List<T> _paginateList<T>({
    required List<T> items,
    required int page,
    required int pageSize,
  }) {
    if (page <= 0 || pageSize <= 0 || items.isEmpty) {
      return <T>[];
    }

    final int startIndex = (page - 1) * pageSize;
    if (startIndex >= items.length) {
      return <T>[];
    }

    final int endIndex = startIndex + pageSize;
    return items.sublist(
      startIndex,
      endIndex > items.length ? items.length : endIndex,
    );
  }

  void _seedUsers(int count) {
    for (int i = 0; i < count; i++) {
      final newUser = MockUsers.createRandomUser();
      _users[newUser.userId] = newUser;
    }
  }

  void _seedConversations({
    int privateCount = 20,
    int groupCount = 10,
    int channelCount = 5,
  }) {
    final adminUser = MockUsers.adminUser;
    for (int i = 0; i < privateCount; i++) {
      final List<String> usersKeys = _users.keys
          .where((String id) => id != adminUser.userId)
          .toList();

      final String randomKey = usersKeys[_random.nextInt(usersKeys.length)];
      final randomUser = _users[randomKey]!;

      final privateConversation =
          MockConversations.createRandomPrivateConversation(
            initiatorId: adminUser.userId,
          );
      _conversations[privateConversation.conversationId] = privateConversation;

      _conversationParticipants[privateConversation.conversationId] = [
        ConversationParticipantDto(
          id: '${privateConversation.conversationId}-${adminUser.userId}',
          conversationId: privateConversation.conversationId,
          userId: adminUser.userId,
          role: 'companion',
          joinedAt: DateTime.now(),
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        ConversationParticipantDto(
          id: '${privateConversation.conversationId}-${randomUser.userId}',
          conversationId: privateConversation.conversationId,
          userId: randomUser.userId,
          role: 'companion',
          joinedAt: DateTime.now(),
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      ];
    }

    for (int i = 0; i < groupCount; i++) {
      final List<String> availableUserIds = _users.keys
          .where((String id) => id != adminUser.userId)
          .toList();

      if (availableUserIds.length < 5) {
        throw StateError('Not enough users to form group participants');
      }

      availableUserIds.shuffle(_random);

      final List<UserDto> randomUsers = availableUserIds
          .take(5)
          .map((String id) => _users[id]!)
          .toList();

      final groupConversation = MockConversations.createRandomGroupConversation(
        initiatorId: adminUser.userId,
      );

      _conversations[groupConversation.conversationId] = groupConversation;

      final List<ConversationParticipantDto> participants =
          <ConversationParticipantDto>[
            ConversationParticipantDto(
              id: '${groupConversation.conversationId}-${adminUser.userId}',
              conversationId: groupConversation.conversationId,
              userId: adminUser.userId,
              role: 'owner',
              joinedAt: DateTime.now(),
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
            ),
          ];

      for (final UserDto user in randomUsers) {
        participants.add(
          ConversationParticipantDto(
            id: '${groupConversation.conversationId}-${user.userId}',
            conversationId: groupConversation.conversationId,
            userId: user.userId,
            role: 'companion',
            joinedAt: DateTime.now(),
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
        );
      }

      _conversationParticipants[groupConversation.conversationId] =
          participants;
    }

    for (int i = 0; i < channelCount; i++) {
      final List<String> availableUserIds = _users.keys
          .where((String id) => id != adminUser.userId)
          .toList();

      if (availableUserIds.length < 5) {
        throw StateError('Not enough users to form channel subscribers');
      }

      availableUserIds.shuffle(_random);

      final List<UserDto> randomUsers = availableUserIds
          .take(5)
          .map((String id) => _users[id]!)
          .toList();

      final channelConversation = MockConversations.createRandomChannel(
        initiatorId: adminUser.userId,
      );

      _conversations[channelConversation.conversationId] = channelConversation;

      final List<ConversationParticipantDto> participants =
          <ConversationParticipantDto>[
            ConversationParticipantDto(
              id: '${channelConversation.conversationId}-${adminUser.userId}',
              conversationId: channelConversation.conversationId,
              userId: adminUser.userId,
              role: 'owner',
              joinedAt: DateTime.now(),
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
            ),
          ];

      for (final UserDto user in randomUsers) {
        participants.add(
          ConversationParticipantDto(
            id: '${channelConversation.conversationId}-${user.userId}',
            conversationId: channelConversation.conversationId,
            userId: user.userId,
            role: 'companion',
            joinedAt: DateTime.now(),
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
        );
      }

      _conversationParticipants[channelConversation.conversationId] =
          participants;
    }
  }

  void _seedConversationsScripts() {
    for (final ConversationDto conversationDto in _conversations.values) {
      switch (conversationDto.type) {
        case 'private':
          final participants =
              _conversationParticipants[conversationDto.conversationId] ?? [];
          if (participants.length != 2) {
            throw StateError(
              "Invalid private conversation participants count: ${participants.length}",
            );
          }
          final List<MessageDto> messages = MockMessages.getRandomPrivateScript(
            conversationId: conversationDto.conversationId,
            firstCompanionId: participants[0].userId,
            secondCompanionId: participants[1].userId,
          );
          _conversationsMessages[conversationDto.conversationId] = messages;

        case 'group':
          final participants =
              _conversationParticipants[conversationDto.conversationId] ?? [];
          if (participants.isEmpty) {
            throw StateError(
              "Invalid group conversation participants count: ${participants.length}",
            );
          }
          final List<MessageDto> messages = MockMessages.getRandomGroupScript(
            conversationId: conversationDto.conversationId,
            participantIds: participants
                .map(
                  (ConversationParticipantDto participantDto) =>
                      participantDto.userId,
                )
                .toList(),
          );
          _conversationsMessages[conversationDto.conversationId] = messages;
        case 'channel':
          final participants =
              _conversationParticipants[conversationDto.conversationId] ?? [];
          if (participants.isEmpty) {
            throw StateError(
              "Invalid group conversation participants count: ${participants.length}",
            );
          }
          final List<MessageDto> messages = MockMessages.getRandomChannelScript(
            conversationId: conversationDto.conversationId,
            adminIds: participants
                .where(
                  (ConversationParticipantDto participantDto) =>
                      participantDto.role == 'admin',
                )
                .map(
                  (ConversationParticipantDto participantDto) =>
                      participantDto.userId,
                )
                .toList(),
          );
          _conversationsMessages[conversationDto.conversationId] = messages;
        default:
          throw StateError(
            "Unknown conversation type: ${conversationDto.type}",
          );
      }
    }
  }
}
