import 'dart:math';

import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/conversation/subfeatures/channel/channel.dart';
import 'package:locnet_app/features/conversation/subfeatures/group/group.dart';
import 'package:locnet_app/features/conversation/subfeatures/private/private.dart';
import 'package:locnet_app/features/conversations_list/subfeatures/unified_search/data/data.dart';
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
    _seedChats(
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
  final int _groupMessagesPageSize = 20;
  final int _channelPublicationsPageSize = 20;
  final int _conversationMessagesPageSize = 20;

  // Storage

  final Map<String, UserDto> _users = {};

  final Map<String, PrivateConversationDto> _privateConversations = {};
  final Map<String, List<PrivateMessageDto>> _privateMessages = {};

  final Map<String, GroupDto> _groups = {};
  final Map<String, List<GroupMessageDto>> _groupsMessages = {};
  final Map<String, List<GroupAdminDto>> _groupsAdmins = {};
  final Map<String, List<GroupParticipantDto>> _groupsParticipants = {};

  final Map<String, ChannelDto> _channels = {};
  final Map<String, List<ChannelPublicationDto>> _channelsPublications = {};
  final Map<String, List<ChannelAdminDto>> _channelsAdmins = {};
  final Map<String, List<ChannelSubscriberDto>> _channelSubscribers = {};

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

  // --------------------- PRIVATE CONVERSATIONS

  PrivateConversationDto getPrivateConversationById(String conversationId) {
    if (!_privateConversations.containsKey(conversationId)) {
      throw StateError("Conversation $conversationId not found");
    }
    return _privateConversations[conversationId]!;
  }

  List<PrivateConversationDto> getAllPrivateConversations({int page = 1}) {
    final List<PrivateConversationDto> allPrivateConversations =
        _privateConversations.values.toList(growable: false);
    return _paginateList(
      items: allPrivateConversations,
      page: page,
      pageSize: _conversationsPageSize,
    );
  }

  PrivateConversationDto updatePrivateConversation(
    PrivateConversation updatedConversation,
  ) {
    final PrivateConversationDto? existingDto =
        _privateConversations[updatedConversation.conversationId];
    if (existingDto == null) {
      throw StateError(
        "Couldn't update conversation: conversation with id ${updatedConversation.conversationId} not  found",
      );
    }

    final PrivateConversationDto updatedDto = existingDto.copyWith(
      conversationId: updatedConversation.conversationId,
      user1Id: updatedConversation.user1Id,
      user2Id: updatedConversation.user2Id,
      createdAt: updatedConversation.createdAt,
      updatedAt: updatedConversation.updatedAt,
      isDeleted: updatedConversation.isDeleted,
    );

    _privateConversations[updatedConversation.conversationId] = updatedDto;
    return updatedDto;
  }

  void upsertPrivateConversation({
    required PrivateConversationDto conversation,
  }) {
    _privateConversations[conversation.conversationId] = conversation;
  }

  bool deletePrivateConversation({required String privateConversationId}) {
    if (_privateConversations[privateConversationId] == null) {
      return false;
    }
    _privateConversations.remove(privateConversationId);
    return true;
  }

  // --------------------- GROUPS

  GroupDto getGroupById(String groupId) {
    final group = _groups[groupId];
    if (group == null) {
      throw StateError("Group $groupId not found");
    }
    return group;
  }

  List<GroupDto> getAllGroups({int page = 1}) {
    final List<GroupDto> allGroups = _groups.values.toList(growable: false);
    return _paginateList(
      items: allGroups,
      page: page,
      pageSize: _conversationsPageSize,
    );
  }

  GroupDto updateGroup(Group updatedGroup) {
    final GroupDto? existingDto = _groups[updatedGroup.groupId];
    if (existingDto == null) {
      throw StateError(
        "Couldn't update group: group with id ${updatedGroup.groupId} not  found",
      );
    }

    final GroupDto updatedDto = existingDto.copyWith(
      groupId: updatedGroup.groupId,
      createdById: updatedGroup.createdById,
      title: updatedGroup.title,
      description: updatedGroup.description,
      createdAt: updatedGroup.createdAt,
      updatedAt: updatedGroup.updatedAt,
      avatarFileId: updatedGroup.avatarFileId,
      isDeleted: updatedGroup.isDeleted,
      deletedAt: updatedGroup.deletedAt,
      isPublic: updatedGroup.isPublic,
    );

    _groups[updatedGroup.groupId] = updatedDto;
    return updatedDto;
  }

  bool deleteGroup({required String groupId}) {
    if (_groups[groupId] == null) {
      return false;
    }
    _groups.remove(groupId);
    return true;
  }

  List<UserDto> getGroupParticipants({required String groupId}) {
    final participants = _groupsParticipants[groupId];
    if (participants == null || participants.isEmpty) {
      return <UserDto>[];
    }
    return participants
        .map((GroupParticipantDto p) => getUserById(userId: p.userId))
        .toList();
  }

  // --------------------- CHANNELS

  ChannelDto getChannelById(String channelId) {
    final channel = _channels[channelId];
    if (channel == null) {
      throw StateError("Channel $channelId not found");
    }
    return channel;
  }

  List<ChannelDto> getAllChannels({int page = 1}) {
    final List<ChannelDto> allChannels = _channels.values.toList(
      growable: false,
    );
    return _paginateList(
      items: allChannels,
      page: page,
      pageSize: _conversationsPageSize,
    );
  }

  ChannelDto updateChannel(Channel updatedChannel) {
    final ChannelDto? existingDto = _channels[updatedChannel.channelId];
    if (existingDto == null) {
      throw StateError(
        "Couldn't update channel: channel with id ${updatedChannel.channelId} not  found",
      );
    }

    final ChannelDto updatedDto = ChannelDto(
      channelId: updatedChannel.channelId,
      ownerId: updatedChannel.ownerId,
      title: updatedChannel.title,
      description: updatedChannel.description,
      createdAt: updatedChannel.createdAt,
      updatedAt: updatedChannel.updatedAt,
      avatarFileId: updatedChannel.avatarFileId,
      isDeleted: updatedChannel.isDeleted,
      deletedAt: updatedChannel.deletedAt,
      isPublic: updatedChannel.isPublic,
    );

    _channels[updatedChannel.channelId] = updatedDto;
    return updatedDto;
  }

  bool deleteChannel({required String channelId}) {
    if (_channels[channelId] == null) {
      return false;
    }
    _channels.remove(channelId);
    return true;
  }

  List<UserDto> getChannelSubscribers({required String channelId}) {
    final subscribers = _channelSubscribers[channelId];
    if (subscribers == null || subscribers.isEmpty) {
      return <UserDto>[];
    }
    return subscribers
        .map((ChannelSubscriberDto s) => getUserById(userId: s.userId))
        .toList();
  }

  // --------------------- PRIVATE MESSAGES

  PrivateMessageDto addPrivateMessage({required PrivateMessage newMessage}) {
    if (!_privateMessages.containsKey(newMessage.conversationId)) {
      _privateMessages[newMessage.conversationId] = <PrivateMessageDto>[];
    }

    final String messageId = newMessage.id.isEmpty
        ? const Uuid().v4()
        : newMessage.id;

    int attachmentOrder = 0;

    final PrivateMessageDto messageDto = PrivateMessageDto(
      id: messageId,
      conversationId: newMessage.conversationId,
      senderId: newMessage.senderId,
      text: newMessage.text,
      attachments: newMessage.attachments.map((
        PrivateMessageAttachment attachment,
      ) {
        attachmentOrder++;
        return PrivateMessageAttachmentDto(
          id: const Uuid().v4(),
          messageId: messageId,
          fileId: attachment.fileId,
          order: attachmentOrder,
          createdAt: attachment.createdAt,
          fileType: attachment.fileType,
        );
      }).toList(),
      createdAt: newMessage.createdAt,
      updatedAt: newMessage.updatedAt,
      isDeleted: newMessage.isDeleted,
      deletedById: newMessage.deletedById,
      replyToMessageId: newMessage.replyToMessageId,
      deliveryStatus: newMessage.deliveryStatus.value,
      clientMessageId: newMessage.clientMessageId,
      isPinned: newMessage.isPinned,
      editedAt: newMessage.editedAt,
      readAt: newMessage.readAt,
    );

    _privateMessages[newMessage.conversationId]!.add(messageDto);
    return messageDto;
  }

  PrivateMessageDto updatePrivateMessage({
    required PrivateMessage updatedMessage,
  }) {
    final String conversationId = updatedMessage.conversationId;

    final List<PrivateMessageDto>? list = _privateMessages[conversationId];
    if (list == null || list.isEmpty) {
      throw StateError(
        "Failed to update private message ${updatedMessage.id}: no messages for conversation $conversationId",
      );
    }

    final int index = list.indexWhere(
      (PrivateMessageDto dto) => dto.id == updatedMessage.id,
    );
    if (index == -1) {
      throw StateError(
        "Failed to update private message ${updatedMessage.id}: message not found",
      );
    }

    int attachmentOrder = 0;

    final PrivateMessageDto updatedDto = PrivateMessageDto(
      id: updatedMessage.id,
      conversationId: updatedMessage.conversationId,
      senderId: updatedMessage.senderId,
      text: updatedMessage.text,
      attachments: updatedMessage.attachments.map((
        PrivateMessageAttachment attachment,
      ) {
        attachmentOrder++;
        return PrivateMessageAttachmentDto(
          id: const Uuid().v4(),
          messageId: updatedMessage.id,
          fileId: attachment.fileId,
          fileType: attachment.fileType,
          order: attachmentOrder,
          createdAt: attachment.createdAt,
        );
      }).toList(),
      createdAt: updatedMessage.createdAt,
      updatedAt: updatedMessage.updatedAt,
      isDeleted: updatedMessage.isDeleted,
      deletedById: updatedMessage.deletedById,
      replyToMessageId: updatedMessage.replyToMessageId,
      deliveryStatus: updatedMessage.deliveryStatus.value,
      clientMessageId: updatedMessage.clientMessageId,
      isPinned: updatedMessage.isPinned,
      editedAt: updatedMessage.editedAt,
      readAt: updatedMessage.readAt,
    );

    list[index] = updatedDto;
    return updatedDto;
  }

  PrivateMessageDto? findPrivateMessage({
    required String conversationId,
    required String messageId,
  }) {
    final List<PrivateMessageDto>? list = _privateMessages[conversationId];
    if (list == null) {
      return null;
    }
    for (final PrivateMessageDto dto in list) {
      if (dto.id == messageId) {
        return dto;
      }
    }
    return null;
  }

  bool deletePrivateMessage({required PrivateMessage message}) {
    final String conversationId = message.conversationId;

    final List<PrivateMessageDto>? list = _privateMessages[conversationId];
    if (list == null || list.isEmpty) {
      return false;
    }

    final int beforeLength = list.length;
    list.removeWhere((PrivateMessageDto dto) => dto.id == message.id);
    return list.length != beforeLength;
  }

  List<PrivateMessageDto> getAllPrivateMessagesByConversationId({
    required String conversationId,
    int page = 1,
  }) {
    final List<PrivateMessageDto> messages =
        _privateMessages[conversationId]?.toList(growable: false) ??
        <PrivateMessageDto>[];

    return _paginateList(
      items: messages,
      page: page,
      pageSize: _conversationMessagesPageSize,
    );
  }

  PrivateMessageDto? getLastPrivateMessage({required String conversationId}) {
    final List<PrivateMessageDto>? messages = _privateMessages[conversationId];
    if (messages == null || messages.isEmpty) {
      return null;
    }
    for (final PrivateMessageDto dto in messages.reversed) {
      if (!dto.isDeleted) {
        return dto;
      }
    }
    return null;
  }

  // --------------------- GROUP MESSAGES

  GroupMessageDto addGroupMessage({required GroupMessage newMessage}) {
    if (!_groupsMessages.containsKey(newMessage.groupId)) {
      _groupsMessages[newMessage.groupId] = <GroupMessageDto>[];
    }

    final String messageId = newMessage.id.isEmpty
        ? const Uuid().v4()
        : newMessage.id;

    int attachmentOrder = 0;

    final GroupMessageDto messageDto = GroupMessageDto(
      id: messageId,
      senderId: newMessage.senderId,
      groupId: newMessage.groupId,
      text: newMessage.text,
      attachments: newMessage.attachments.map((
        GroupMessageAttachment attachment,
      ) {
        attachmentOrder++;
        return GroupMessageAttachmentDto(
          id: const Uuid().v4(),
          messageId: messageId,
          fileId: attachment.fileId,
          order: attachmentOrder,
          createdAt: attachment.createdAt,
        );
      }).toList(),
      createdAt: newMessage.createdAt,
      updatedAt: newMessage.updatedAt,
      isDeleted: newMessage.isDeleted,
      deletedById: newMessage.deletedById,
      replyToMessageId: newMessage.replyToMessageId,
      deliveryStatus: newMessage.deliveryStatus.value,
      clientMessageId: newMessage.clientMessageId,
      isPinned: newMessage.isPinned,
      editedAt: newMessage.editedAt,
    );

    _groupsMessages[newMessage.groupId]!.add(messageDto);
    return messageDto;
  }

  GroupMessageDto updateGroupMessage({required GroupMessage updatedMessage}) {
    final String groupId = updatedMessage.groupId;

    final List<GroupMessageDto>? list = _groupsMessages[groupId];
    if (list == null || list.isEmpty) {
      throw StateError(
        "Failed to update group message ${updatedMessage.id}: no messages for group $groupId",
      );
    }

    final int index = list.indexWhere(
      (GroupMessageDto dto) => dto.id == updatedMessage.id,
    );
    if (index == -1) {
      throw StateError(
        "Failed to update group message ${updatedMessage.id}: message not found",
      );
    }

    int attachmentOrder = 0;

    final GroupMessageDto updatedDto = GroupMessageDto(
      id: updatedMessage.id,
      senderId: updatedMessage.senderId,
      groupId: updatedMessage.groupId,
      text: updatedMessage.text,
      attachments: updatedMessage.attachments.map((
        GroupMessageAttachment attachment,
      ) {
        attachmentOrder++;
        return GroupMessageAttachmentDto(
          id: const Uuid().v4(),
          messageId: updatedMessage.id,
          fileId: attachment.fileId,
          order: attachmentOrder,
          createdAt: attachment.createdAt,
        );
      }).toList(),
      createdAt: updatedMessage.createdAt,
      updatedAt: updatedMessage.updatedAt,
      isDeleted: updatedMessage.isDeleted,
      deletedById: updatedMessage.deletedById,
      replyToMessageId: updatedMessage.replyToMessageId,
      deliveryStatus: updatedMessage.deliveryStatus.value,
      clientMessageId: updatedMessage.clientMessageId,
      isPinned: updatedMessage.isPinned,
      editedAt: updatedMessage.editedAt,
    );

    list[index] = updatedDto;
    return updatedDto;
  }

  bool deleteGroupMessage({required GroupMessage message}) {
    final String groupId = message.groupId;
    final List<GroupMessageDto>? list = _groupsMessages[groupId];
    if (list == null || list.isEmpty) {
      return false;
    }

    final int beforeLength = list.length;
    list.removeWhere((GroupMessageDto dto) => dto.id == message.id);
    return list.length != beforeLength;
  }

  List<GroupMessageDto> getAllGroupMessagesByGroupId({
    required String groupId,
    int page = 1,
  }) {
    final List<GroupMessageDto> messages =
        _groupsMessages[groupId]?.toList(growable: false) ??
        <GroupMessageDto>[];

    return _paginateList(
      items: messages,
      page: page,
      pageSize: _groupMessagesPageSize,
    );
  }

  GroupMessageDto? getLastGroupMessage({required String groupId}) {
    final List<GroupMessageDto>? messages = _groupsMessages[groupId];
    if (messages == null || messages.isEmpty) {
      return null;
    }
    for (final GroupMessageDto dto in messages.reversed) {
      if (!dto.isDeleted) {
        return dto;
      }
    }
    return null;
  }

  // --------------------- CHANNEL PUBLICATIONS

  ChannelPublicationDto addChannelPublication({
    required ChannelPublication newPublication,
  }) {
    if (!_channelsPublications.containsKey(newPublication.channelId)) {
      _channelsPublications[newPublication.channelId] =
          <ChannelPublicationDto>[];
    }

    final String publicationId = newPublication.publicationId.isEmpty
        ? const Uuid().v4()
        : newPublication.publicationId;

    int attachmentOrder = 0;

    final ChannelPublicationDto publicationDto = ChannelPublicationDto(
      publicationId: publicationId,
      channelId: newPublication.channelId,
      publishedById: newPublication.publishedById,
      text: newPublication.text,
      attachments: newPublication.attachments.map((
        ChannelPublicationAttachment attachment,
      ) {
        attachmentOrder++;
        return ChannelPublicationAttachmentDto(
          id: const Uuid().v4(),
          publicationId: publicationId,
          fileId: attachment.fileId,
          order: attachmentOrder,
          createdAt: attachment.createdAt,
        );
      }).toList(),
      avatarFileId: newPublication.avatarFileId,
      replyToPublicationId: newPublication.replyToPublicationId,
      isDeleted: newPublication.isDeleted,
      deletedById: newPublication.deletedById,
      createdAt: newPublication.createdAt,
      updatedAt: newPublication.updatedAt,
      deliveryStatus: newPublication.deliveryStatus.value,
      clientPublicationId: newPublication.clientPublicationId,
      isPinned: newPublication.isPinned,
      editedAt: newPublication.editedAt,
    );

    _channelsPublications[newPublication.channelId]!.add(publicationDto);
    return publicationDto;
  }

  ChannelPublicationDto updateChannelPublication({
    required ChannelPublication updatedPublication,
  }) {
    final String channelId = updatedPublication.channelId;

    final List<ChannelPublicationDto>? list = _channelsPublications[channelId];
    if (list == null || list.isEmpty) {
      throw StateError(
        "Failed to update channel publication ${updatedPublication.publicationId}: no publications for channel $channelId",
      );
    }

    final int index = list.indexWhere(
      (ChannelPublicationDto dto) =>
          dto.publicationId == updatedPublication.publicationId,
    );
    if (index == -1) {
      throw StateError(
        "Failed to update channel publication ${updatedPublication.publicationId}: publication not found",
      );
    }

    int attachmentOrder = 0;

    final ChannelPublicationDto updatedDto = ChannelPublicationDto(
      publicationId: updatedPublication.publicationId,
      channelId: updatedPublication.channelId,
      publishedById: updatedPublication.publishedById,
      text: updatedPublication.text,
      attachments: updatedPublication.attachments.map((
        ChannelPublicationAttachment attachment,
      ) {
        attachmentOrder++;
        return ChannelPublicationAttachmentDto(
          id: const Uuid().v4(),
          publicationId: updatedPublication.publicationId,
          fileId: attachment.fileId,
          order: attachmentOrder,
          createdAt: attachment.createdAt,
        );
      }).toList(),
      avatarFileId: updatedPublication.avatarFileId,
      replyToPublicationId: updatedPublication.replyToPublicationId,
      isDeleted: updatedPublication.isDeleted,
      deletedById: updatedPublication.deletedById,
      createdAt: updatedPublication.createdAt,
      updatedAt: updatedPublication.updatedAt,
      deliveryStatus: updatedPublication.deliveryStatus.value,
      clientPublicationId: updatedPublication.clientPublicationId,
      isPinned: updatedPublication.isPinned,
      editedAt: updatedPublication.editedAt,
    );

    list[index] = updatedDto;
    return updatedDto;
  }

  bool deleteChannelPublication({required ChannelPublication publication}) {
    final String channelId = publication.channelId;
    final List<ChannelPublicationDto>? list = _channelsPublications[channelId];
    if (list == null || list.isEmpty) {
      return false;
    }

    final int beforeLength = list.length;
    list.removeWhere(
      (ChannelPublicationDto dto) =>
          dto.publicationId == publication.publicationId,
    );
    return list.length != beforeLength;
  }

  List<ChannelPublicationDto> getAllChannelPublicationsByChannelId({
    required String channelId,
    int page = 1,
  }) {
    final List<ChannelPublicationDto> publications =
        _channelsPublications[channelId]?.toList(growable: false) ??
        <ChannelPublicationDto>[];

    return _paginateList(
      items: publications,
      page: page,
      pageSize: _channelPublicationsPageSize,
    );
  }

  ChannelPublicationDto? getLastChannelPublication({
    required String channelId,
  }) {
    final List<ChannelPublicationDto>? publications =
        _channelsPublications[channelId];
    if (publications == null || publications.isEmpty) {
      return null;
    }
    for (final ChannelPublicationDto dto in publications.reversed) {
      if (!dto.isDeleted) {
        return dto;
      }
    }
    return null;
  }

  // --------------------- UNIFIED SEARCH

  UnifiedSearchResultDto unifiedSearch({required String query, int page = 1}) {
    final String normalizedQuery = query.trim().toLowerCase();
    if (normalizedQuery.isEmpty) {
      return const UnifiedSearchResultDto(
        users: <UserDto>[],
        groups: <UnifiedSearchConversationDto>[],
        channels: <UnifiedSearchConversationDto>[],
        conversations: <UnifiedSearchConversationDto>[],
      );
    }

    final List<UserDto> matchedUsers = MockUnifiedSearchHelper.filterUsers(
      users: _users.values,
      normalizedQuery: normalizedQuery,
    );

    final Iterable<UnifiedSearchConversationDto> allConversations =
        <UnifiedSearchConversationDto>[
          // Private conversations. Title is generic as companion name
          // is not available on PrivateConversationDto.
          ..._privateConversations.values.map(
            (PrivateConversationDto dto) => UnifiedSearchConversationDto(
              id: dto.conversationId,
              type: 'private',
              title: 'Private chat',
            ),
          ),
          // Groups
          ..._groups.values.map(
            (GroupDto dto) => UnifiedSearchConversationDto(
              id: dto.groupId,
              type: 'group',
              title: dto.title,
              description: dto.description,
            ),
          ),
          // Channels
          ..._channels.values.map(
            (ChannelDto dto) => UnifiedSearchConversationDto(
              id: dto.channelId,
              type: 'channel',
              title: dto.title,
              description: dto.description,
            ),
          ),
        ];

    final List<UnifiedSearchConversationDto> matchedConversations =
        MockUnifiedSearchHelper.filterConversations(
          conversations: allConversations,
          normalizedQuery: normalizedQuery,
        );

    final List<UserDto> rankedUsers = MockUnifiedSearchHelper.rankUsers(
      items: matchedUsers,
      normalizedQuery: normalizedQuery,
    );

    final List<UnifiedSearchConversationDto> rankedConversations =
        MockUnifiedSearchHelper.rankConversations(
          items: matchedConversations,
          normalizedQuery: normalizedQuery,
        );

    final List<UserDto> pagedUsers = _paginateList(
      items: rankedUsers,
      page: page,
      pageSize: _usersPageSize,
    );

    final List<UnifiedSearchConversationDto> pagedConversations = _paginateList(
      items: rankedConversations,
      page: page,
      pageSize: _conversationsPageSize,
    );

    final List<UnifiedSearchConversationDto> pagedGroups = pagedConversations
        .where((UnifiedSearchConversationDto c) => c.type == 'group')
        .toList(growable: false);
    final List<UnifiedSearchConversationDto> pagedChannels = pagedConversations
        .where((UnifiedSearchConversationDto c) => c.type == 'channel')
        .toList(growable: false);
    final List<UnifiedSearchConversationDto> pagedPrivate = pagedConversations
        .where((UnifiedSearchConversationDto c) => c.type == 'private')
        .toList(growable: false);

    return UnifiedSearchResultDto(
      users: pagedUsers,
      groups: pagedGroups,
      channels: pagedChannels,
      conversations: pagedPrivate,
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

  void _seedChats({
    int privateCount = 20,
    int groupCount = 10,
    int channelCount = 5,
  }) {
    final Map<String, PrivateConversationDto> privateSeed =
        ChatsSeeder.seedPrivateConversations(
          random: _random,
          count: privateCount,
          users: _users,
        );
    _privateConversations.addAll(privateSeed);

    final ({
      Map<String, GroupDto> groups,
      Map<String, List<GroupParticipantDto>> groupsParticipants,
      Map<String, List<GroupAdminDto>> groupsAdmins,
    })
    groupSeed = ChatsSeeder.seedGroups(
      random: _random,
      count: groupCount,
      users: _users,
    );
    _groups.addAll(groupSeed.groups);
    _groupsParticipants.addAll(groupSeed.groupsParticipants);
    _groupsAdmins.addAll(groupSeed.groupsAdmins);

    final ({
      Map<String, ChannelDto> channels,
      Map<String, List<ChannelSubscriberDto>> channelSubscribers,
      Map<String, List<ChannelAdminDto>> channelAdmins,
    })
    channelSeed = ChatsSeeder.seedChannels(
      random: _random,
      count: channelCount,
      users: _users,
    );
    _channels.addAll(channelSeed.channels);
    _channelSubscribers.addAll(channelSeed.channelSubscribers);
    _channelsAdmins.addAll(channelSeed.channelAdmins);
  }

  void _seedConversationsScripts() {
    _privateMessages.addAll(
      ChatsSeeder.seedPrivateConversationScripts(
        conversations: _privateConversations.values,
      ),
    );

    _groupsMessages.addAll(
      ChatsSeeder.seedGroupConversationScripts(
        conversations: _groups.values,
        groupsParticipants: _groupsParticipants,
      ),
    );

    _channelsPublications.addAll(
      ChatsSeeder.seedChannelConversationScripts(
        conversations: _channels.values,
        channelAdmins: _channelsAdmins,
      ),
    );
  }
}
