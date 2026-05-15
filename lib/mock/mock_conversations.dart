// ignore_for_file: sort_constructors_first

import 'dart:math';

import 'package:locnet_app/features/conversation/subfeatures/private/private.dart';
import 'package:locnet_app/features/conversation/subfeatures/group/group.dart';
import 'package:locnet_app/features/conversation/subfeatures/channel/channel.dart';
import 'package:uuid/uuid.dart';

final class MockConversations {
  static final Random _random = Random(42);
  static final DateTime _now = DateTime.now();

  static PrivateConversationDto createRandomPrivateConversation({
    required String initiatorId,
    required String companionId,
  }) {
    final conversationId = _generateConversationId();

    return PrivateConversationDto(
      conversationId: conversationId,
      user1Id: initiatorId,
      user2Id: companionId,
      createdAt: _now.subtract(Duration(days: _random.nextInt(20))),
      updatedAt: _now.subtract(Duration(hours: _random.nextInt(40))),
      isDeleted: false,
    );
  }

  static GroupDto createRandomGroupConversation({
    required String initiatorId,
  }) {
    final groupId = _generateConversationId();
    final title = _MockConversationsNamesRegistry.getRandomGroupTitle();

    return GroupDto(
      groupId: groupId,
      createdById: initiatorId,
      title: title,
      description: null,
      avatarFileId: null,
      isDeleted: false,
      createdAt: _now.subtract(Duration(days: _random.nextInt(20))),
      updatedAt: _now.subtract(Duration(hours: _random.nextInt(40))),
      deletedAt: null,
      isPublic: true,
    );
  }

  static ChannelDto createRandomChannel({required String initiatorId}) {
    final channelId = _generateConversationId();
    final title = _MockConversationsNamesRegistry.getRandomChannelTitle();

    return ChannelDto(
      channelId: channelId,
      ownerId: initiatorId,
      title: title,
      description: null,
      avatarFileId: null,
      isDeleted: false,
      createdAt: _now.subtract(Duration(days: _random.nextInt(20))),
      updatedAt: _now.subtract(Duration(hours: _random.nextInt(40))),
      deletedAt: null,
      isPublic: true,
    );
  }

  static String _generateConversationId() {
    return const Uuid().v4();
  }
}

abstract class _MockConversationsNamesRegistry {
  static final Random _random = Random(42);

  static String getRandomGroupTitle() {
    return _groupTitles[_random.nextInt(_groupTitles.length)];
  }

  static String getRandomChannelTitle() {
    return _channelTitles[_random.nextInt(_channelTitles.length)];
  }

  static const List<String> _groupTitles = <String>[
    'Team Chat',
    'Project Alpha',
    'Design Squad',
    'Development Group',
    'Marketing Crew',
    'Weekly Standup',
    'Support Team',

    'Группа разработки',
    'Проект Бета',
    'Отдел продаж',
    'Команда маркетинга',
    'Общий чат',
    'Рабочая группа',
  ];

  static const List<String> _channelTitles = <String>[
    'Announcements',
    'News Feed',
    'Updates',
    'Releases',
    'Tech Broadcast',
    'Public Board',

    'Объявления',
    'Новости',
    'Техподдержка',
    'Сервисные обновления',
    'Канал компании',
    'Информационный канал',
  ];
}
