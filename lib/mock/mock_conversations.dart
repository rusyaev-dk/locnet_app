// ignore_for_file: sort_constructors_first

import 'dart:math';

import 'package:locnet_app/features/conversation/data/data.dart';
import 'package:uuid/uuid.dart';

final class MockConversations {
  static final Random _random = Random(42);
  static final DateTime _now = DateTime.now();

  static ConversationDto createRandomPrivateConversation({
    required String initiatorId,
    required String companionName,
  }) {
    final conversationId = _generateConversationId();

    return ConversationDto(
      conversationId: conversationId,
      initiatorId: initiatorId,
      type: 'private',
      title: companionName,
      isDeleted: false,
      createdAt: _now.subtract(Duration(days: _random.nextInt(20))),
      updatedAt: _now.subtract(Duration(hours: _random.nextInt(40))),
    );
  }

  static ConversationDto createRandomGroupConversation({
    required String initiatorId,
  }) {
    final conversationId = _generateConversationId();
    final title = _MockConversationsNamesRegistry.getRandomGroupTitle();

    return ConversationDto(
      conversationId: conversationId,
      initiatorId: initiatorId,
      type: 'group',
      title: title,
      isDeleted: false,
      createdAt: _now.subtract(Duration(days: _random.nextInt(20))),
      updatedAt: _now.subtract(Duration(hours: _random.nextInt(40))),
    );
  }

  static ConversationDto createRandomChannel({required String initiatorId}) {
    final conversationId = _generateConversationId();
    final title = _MockConversationsNamesRegistry.getRandomChannelTitle();

    return ConversationDto(
      conversationId: conversationId,
      initiatorId: initiatorId,
      type: 'channel',
      title: title,
      isDeleted: false,
      createdAt: _now.subtract(Duration(days: _random.nextInt(20))),
      updatedAt: _now.subtract(Duration(hours: _random.nextInt(40))),
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
