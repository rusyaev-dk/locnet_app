import 'dart:math';

import 'package:locnet_app/core/data/data.dart';
import 'package:locnet_app/features/conversation/subfeatures/group/group.dart';
import 'package:locnet_app/features/conversation/subfeatures/channel/channel.dart';
import 'package:locnet_app/features/conversation/subfeatures/private/private.dart';
import 'package:locnet_app/mock/mock.dart';

final class ChatsSeeder {
  static Map<String, PrivateConversationDto> seedPrivateConversations({
    required Random random,
    required int count,
    required Map<String, UserDto> users,
  }) {
    final Map<String, PrivateConversationDto> privateConversations = {};
    final adminUser = MockUsers.adminUser;

    for (int i = 0; i < count; i++) {
      final List<String> usersKeys = users.keys
          .where((String id) => id != adminUser.userId)
          .toList();

      if (usersKeys.isEmpty) {
        break;
      }

      final String randomKey = usersKeys[random.nextInt(usersKeys.length)];
      final UserDto randomUser = users[randomKey]!;

      final PrivateConversationDto privateConversation =
          MockConversations.createRandomPrivateConversation(
            initiatorId: adminUser.userId,
            companionId: randomUser.userId,
          );

      privateConversations[privateConversation.conversationId] =
          privateConversation;
    }

    return privateConversations;
  }

  static ({
    Map<String, GroupDto> groups,
    Map<String, List<GroupParticipantDto>> groupsParticipants,
    Map<String, List<GroupAdminDto>> groupsAdmins,
  })
  seedGroups({
    required Random random,
    required int count,
    required Map<String, UserDto> users,
  }) {
    final Map<String, GroupDto> groups = <String, GroupDto>{};
    final Map<String, List<GroupParticipantDto>> groupsParticipants = {};
    final Map<String, List<GroupAdminDto>> groupsAdmins =
        <String, List<GroupAdminDto>>{};

    final adminUser = MockUsers.adminUser;

    for (int i = 0; i < count; i++) {
      final List<String> availableUserIds = users.keys
          .where((String id) => id != adminUser.userId)
          .toList();

      if (availableUserIds.length < 5) {
        throw StateError('Not enough users to form group participants');
      }

      availableUserIds.shuffle(random);

      final List<UserDto> randomUsers = availableUserIds
          .take(5)
          .map((String id) => users[id]!)
          .toList();

      final GroupDto groupConversation =
          MockConversations.createRandomGroupConversation(
            initiatorId: adminUser.userId,
          );

      groups[groupConversation.groupId] = GroupDto(
        groupId: groupConversation.groupId,
        createdById: groupConversation.createdById,
        title: groupConversation.title,
        description: null,
        createdAt: groupConversation.createdAt,
        updatedAt: groupConversation.updatedAt,
        avatarFileId: null,
        isDeleted: groupConversation.isDeleted,
        deletedAt: null,
        isPublic: true,
      );

      final List<GroupParticipantDto> participants = [];
      for (final UserDto user in randomUsers) {
        participants.add(
          GroupParticipantDto(
            id: '${groupConversation.groupId}-${user.userId}',
            groupId: groupConversation.groupId,
            userId: user.userId,
            joinedAt: DateTime.now(),
          ),
        );
      }

      participants.add(
        GroupParticipantDto(
          id: '${groupConversation.groupId}-${adminUser.userId}',
          groupId: groupConversation.groupId,
          userId: adminUser.userId,
          joinedAt: DateTime.now(),
        ),
      );

      groupsParticipants[groupConversation.groupId] = participants;

      final List<GroupAdminDto> admins = <GroupAdminDto>[
        GroupAdminDto(
          id: '${groupConversation.groupId}-${adminUser.userId}',
          groupId: groupConversation.groupId,
          userId: adminUser.userId,
          role: 'owner',
          createdAt: DateTime.now(),
        ),
      ];

      groupsAdmins[groupConversation.groupId] = admins;
    }

    return (
      groups: groups,
      groupsParticipants: groupsParticipants,
      groupsAdmins: groupsAdmins,
    );
  }

  static ({
    Map<String, ChannelDto> channels,
    Map<String, List<ChannelSubscriberDto>> channelSubscribers,
    Map<String, List<ChannelAdminDto>> channelAdmins,
  })
  seedChannels({
    required Random random,
    required int count,
    required Map<String, UserDto> users,
  }) {
    final Map<String, ChannelDto> channels = <String, ChannelDto>{};
    final Map<String, List<ChannelSubscriberDto>> channelSubscribers =
        <String, List<ChannelSubscriberDto>>{};
    final Map<String, List<ChannelAdminDto>> channelAdmins =
        <String, List<ChannelAdminDto>>{};

    final adminUser = MockUsers.adminUser;

    for (int i = 0; i < count; i++) {
      final List<String> availableUserIds = users.keys
          .where((String id) => id != adminUser.userId)
          .toList();

      if (availableUserIds.length < 5) {
        throw StateError('Not enough users to form channel subscribers');
      }

      availableUserIds.shuffle(random);

      final List<UserDto> randomUsers = availableUserIds
          .take(5)
          .map((String id) => users[id]!)
          .toList();

      final ChannelDto channel = MockConversations.createRandomChannel(
        initiatorId: adminUser.userId,
      );

      channels[channel.channelId] = ChannelDto(
        channelId: channel.channelId,
        ownerId: channel.ownerId,
        title: channel.title,
        description: channel.description,
        createdAt: channel.createdAt,
        updatedAt: channel.updatedAt,
        avatarFileId: channel.avatarFileId,
        isDeleted: channel.isDeleted,
        deletedAt: channel.deletedAt,
        isPublic: channel.isPublic,
      );

      final List<ChannelSubscriberDto> subscribers = <ChannelSubscriberDto>[];

      for (final UserDto user in randomUsers) {
        subscribers.add(
          ChannelSubscriberDto(
            id: '${channel.channelId}-${user.userId}',
            userId: user.userId,
            channelId: channel.channelId,
            joinedAt: DateTime.now(),
          ),
        );
      }

      channelSubscribers[channel.channelId] = subscribers;

      final List<ChannelAdminDto> admins = <ChannelAdminDto>[
        ChannelAdminDto(
          id: '${channel.channelId}-${adminUser.userId}',
          channelId: channel.channelId,
          userId: adminUser.userId,
          role: 'owner',
          createdAt: DateTime.now(),
        ),
      ];

      channelAdmins[channel.channelId] = admins;
    }

    return (
      channels: channels,
      channelSubscribers: channelSubscribers,
      channelAdmins: channelAdmins,
    );
  }

  static Map<String, List<PrivateMessageDto>> seedPrivateConversationScripts({
    required Iterable<PrivateConversationDto> conversations,
  }) {
    final Map<String, List<PrivateMessageDto>> result =
        <String, List<PrivateMessageDto>>{};

    for (final PrivateConversationDto conversation in conversations) {
      final List<PrivateMessageDto> messages =
          MockMessages.getRandomPrivateScript(
        conversationId: conversation.conversationId,
        firstCompanionId: conversation.user1Id,
        secondCompanionId: conversation.user2Id,
      );

      result[conversation.conversationId] = messages;
    }

    return result;
  }

  /// Генерирует скрипты сообщений для групповых диалогов.
  ///
  /// Обрабатываются только разговоры с `type == 'group'`.
  static Map<String, List<GroupMessageDto>> seedGroupConversationScripts({
    required Iterable<GroupDto> conversations,
    required Map<String, List<GroupParticipantDto>> groupsParticipants,
  }) {
    final Map<String, List<GroupMessageDto>> result =
        <String, List<GroupMessageDto>>{};

    for (final GroupDto conversation in conversations) {
      final participants = groupsParticipants[conversation.groupId] ?? [];
      if (participants.isEmpty) {
        throw StateError(
          'Invalid group conversation participants count: ${participants.length}',
        );
      }

      final List<GroupMessageDto> messages =
          MockMessages.getRandomGroupScript(
        conversationId: conversation.groupId,
        participantIds: participants
            .map((GroupParticipantDto participant) => participant.userId)
            .toList(),
      );

      result[conversation.groupId] = messages;
    }

    return result;
  }

  /// Генерирует скрипты сообщений для каналов.
  ///
  /// Обрабатываются только разговоры с `type == 'channel'`.
  static Map<String, List<ChannelPublicationDto>>
  seedChannelConversationScripts({
    required Iterable<ChannelDto> conversations,
    required Map<String, List<ChannelAdminDto>> channelAdmins,
  }) {
    final Map<String, List<ChannelPublicationDto>> result =
        <String, List<ChannelPublicationDto>>{};

    for (final ChannelDto conversation in conversations) {
      final List<String> adminIds = (channelAdmins[conversation.channelId] ??
              <ChannelAdminDto>[])
          .map((ChannelAdminDto admin) => admin.userId)
          .toList();
      if (adminIds.isEmpty) {
        throw StateError(
          'Channel ${conversation.channelId} has no admins assigned',
        );
      }

      final List<ChannelPublicationDto> messages =
          MockMessages.getRandomChannelScript(
        conversationId: conversation.channelId,
        adminIds: adminIds,
      );

      result[conversation.channelId] = messages;
    }

    return result;
  }
}
