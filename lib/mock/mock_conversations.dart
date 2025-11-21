// ignore_for_file: sort_constructors_first

import 'dart:math';

import 'package:locnet_app/features/conversation/domain/domain.dart';

final class MockConversations {
  MockConversations._();

  static final Random _random = Random(42);
  static final DateTime _now = DateTime.now();

  static Conversation getRandomPrivateConversation({
    required String createdById,
    required String companionId,
  }) {
    final DateTime createdAt = _generateCreatedAt();
    final DateTime updatedAt = _generateUpdatedAt(createdAt);

    final String conversationId = _buildConversationId(
      prefix: 'private',
      participantIds: <String>[createdById, companionId],
    );

    final String title = 'Private chat: $createdById & $companionId';

    return Conversation(
      id: conversationId,
      createdByUserId: createdById,
      type: ConversationType.private,
      title: title,
      isDeleted: false,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  static Conversation getRandomGroupConversation({
    required String createdById,
    required List<String> participantsIds,
  }) {
    final DateTime createdAt = _generateCreatedAt();
    final DateTime updatedAt = _generateUpdatedAt(createdAt);

    final String conversationId = _buildConversationId(
      prefix: 'group',
      participantIds: <String>[createdById, ...participantsIds],
    );

    final String title = _buildGroupTitle(
      createdById: createdById,
      participantsIds: participantsIds,
    );

    final String? description = _random.nextBool()
        ? 'Mock group conversation created by $createdById'
        : null;

    return Conversation(
      id: conversationId,
      createdByUserId: createdById,
      type: ConversationType.group,
      title: title,
      description: description,
      isDeleted: false,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  static Conversation getRandomChannel({
    required String createdById,
    required List<String> subscribers,
    required List<String> admins,
  }) {
    final DateTime createdAt = _generateCreatedAt();
    final DateTime updatedAt = _generateUpdatedAt(createdAt);

    final String conversationId = _buildConversationId(
      prefix: 'channel',
      participantIds: <String>[createdById, ...admins],
    );

    final String title = _buildChannelTitle(
      admins: admins,
      subscribers: subscribers,
    );

    final String description =
        'Mock channel managed by $createdById with ${subscribers.length} subscribers';

    return Conversation(
      id: conversationId,
      createdByUserId: createdById,
      type: ConversationType.channel,
      title: title,
      description: description,
      isDeleted: false,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  static DateTime _generateCreatedAt() {
    final int daysAgo = _random.nextInt(60);
    final int hoursAgo = _random.nextInt(24);
    final int minutesAgo = _random.nextInt(60);

    return _now.subtract(
      Duration(days: daysAgo, hours: hoursAgo, minutes: minutesAgo),
    );
  }

  static DateTime _generateUpdatedAt(DateTime createdAt) {
    final int minutesDelta = _random.nextInt(60 * 12);
    return createdAt.add(Duration(minutes: minutesDelta));
  }

  static String _buildConversationId({
    required String prefix,
    required List<String> participantIds,
  }) {
    final int randomSuffix = _random.nextInt(1 << 31);
    final String participantsSuffix = participantIds
        .join('-')
        .replaceAll(RegExp(r'[^a-zA-Z0-9\-]'), '-');
    return 'conv-$prefix-$participantsSuffix-$randomSuffix';
  }

  static String _buildGroupTitle({
    required String createdById,
    required List<String> participantsIds,
  }) {
    if (participantsIds.isEmpty) {
      return 'Group created by $createdById';
    }

    final List<String> visibleParticipants = participantsIds
        .take(3)
        .toList(growable: false);
    final int remainingCount = participantsIds.length > 3
        ? participantsIds.length - 3
        : 0;

    if (remainingCount > 0) {
      return 'Group: ${visibleParticipants.join(', ')} + $remainingCount';
    }

    return 'Group: ${visibleParticipants.join(', ')}';
  }

  static String _buildChannelTitle({
    required List<String> admins,
    required List<String> subscribers,
  }) {
    final String adminsPart = admins.isEmpty
        ? 'Channel'
        : 'Channel by ${admins.first}';
    if (subscribers.isEmpty) {
      return adminsPart;
    }

    return '$adminsPart (${subscribers.length} subs)';
  }
}
