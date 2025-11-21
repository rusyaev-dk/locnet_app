// ignore_for_file: sort_constructors_first

import 'dart:math';

import 'package:locnet_app/features/message/domain/domain.dart';

final class MockMessages {
  MockMessages._();

  static final Random _random = Random(42);
  static final DateTime _now = DateTime.now();

  static const List<String> _sampleTexts = <String>[
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

  static Message getRandomMessage({
    required String conversationId,
    required String senderId,
    DateTime? baseTime,
    bool allowEmptyText = true,
  }) {
    final DateTime createdAt = _generateCreatedAt(baseTime: baseTime);
    final DateTime updatedAt = createdAt;

    final String messageId = _buildMessageId(conversationId: conversationId);

    final String? text = _pickText(allowEmptyText: allowEmptyText);
    final bool hasAttachments = _random.nextInt(100) < 20;

    return Message(
      id: messageId,
      conversationId: conversationId,
      senderId: senderId,
      text: text,
      hasAttachments: hasAttachments,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  static DateTime _generateCreatedAt({DateTime? baseTime}) {
    final DateTime referenceTime = baseTime ?? _now;
    final int minutesOffset = _random.nextInt(60 * 24);
    return referenceTime.add(Duration(minutes: minutesOffset));
  }

  static String _buildMessageId({required String conversationId}) {
    final int randomSuffix = _random.nextInt(1 << 31);
    final String sanitizedConversationId = conversationId.replaceAll(
      RegExp(r'[^a-zA-Z0-9\-]'),
      '-',
    );
    return 'msg-$sanitizedConversationId-$randomSuffix';
  }

  static String? _pickText({required bool allowEmptyText}) {
    if (allowEmptyText && _random.nextBool()) {
      return null;
    }
    return _sampleTexts[_random.nextInt(_sampleTexts.length)];
  }
}
