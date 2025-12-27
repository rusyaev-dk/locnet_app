// ignore_for_file: sort_constructors_first

import 'dart:math';

import 'package:locnet_app/features/message/data/data.dart';
import 'package:locnet_app/features/message/domain/domain.dart';
import 'package:uuid/uuid.dart';

final class MockMessages {
  static final Random _random = Random(42);
  static final DateTime _now = DateTime.now();

  static List<MessageDto> getRandomPrivateScript({
    required String conversationId,
    required String firstCompanionId,
    required String secondCompanionId,
    int messagesCount = 40,
  }) {
    final List<_MockMessageTemplate> script =
        _MockConversationsMessagesRegistry.getRandomPrivateScript();

    final List<MessageDto> messages = <MessageDto>[];

    final DateTime conversationStart = _now.subtract(
      Duration(minutes: _random.nextInt(60 * 24 * 7)),
    );

    DateTime currentTime = conversationStart;

    String? lastSenderId;
    int remainingChainMessages = 0;

    for (int index = 0; index < messagesCount; index += 1) {
      final _MockMessageTemplate template = script[index % script.length];

      String senderId;

      if (remainingChainMessages > 0 && lastSenderId != null) {
        senderId = lastSenderId;
        remainingChainMessages -= 1;
      } else {
        senderId = template.senderIndex == 0
            ? firstCompanionId
            : secondCompanionId;

        final bool canStartChain = messagesCount - index >= 3;
        final bool shouldStartChain =
            canStartChain && _random.nextDouble() < 0.3;

        if (shouldStartChain) {
          int desiredChainLength = 3 + _random.nextInt(3);
          final int maxPossibleLength = messagesCount - index;

          if (desiredChainLength > maxPossibleLength) {
            desiredChainLength = maxPossibleLength;
          }

          remainingChainMessages = desiredChainLength - 1;
        }
      }

      final DateTime createdAt = currentTime;
      final DateTime updatedAt = createdAt;

      final String messageId = _generateMessageId();

      String? replyToMessageId;
      if (messages.isNotEmpty && _shouldReplyToPrevious()) {
        final MessageDto target = _pickReplyTarget(
          messages: messages,
          currentSenderId: senderId,
        );
        replyToMessageId = target.messageId;
      }

      DateTime? editedAt;
      if (_random.nextDouble() < 0.10) {
        final int editDeltaMinutes = 1 + _random.nextInt(15);
        editedAt = createdAt.add(Duration(minutes: editDeltaMinutes));
      }

      messages.add(
        MessageDto(
          messageId: messageId,
          clientMessageId: const Uuid().v4(),
          deliveryStatus: MessageDeliveryStatus.sent.toString(),
          conversationId: conversationId,
          senderId: senderId,
          text: template.text,
          hasAttachments: false,
          replyToMessageId: replyToMessageId,
          isPinned: false,
          isDeleted: false,
          editedAt: editedAt,
          createdAt: createdAt,
          updatedAt: updatedAt,
        ),
      );

      final int stepMinutes;
      if (senderId == lastSenderId) {
        stepMinutes = 1 + _random.nextInt(60);
      } else {
        stepMinutes = 1 + _random.nextInt(10);
      }

      currentTime = currentTime.add(Duration(minutes: stepMinutes));
      lastSenderId = senderId;
    }

    return messages.reversed.toList();
  }

  static List<MessageDto> getRandomGroupScript({
    required String conversationId,
    required List<String> participantIds,
    int messagesCount = 40,
  }) {
    if (participantIds.isEmpty) {
      throw StateError('participantIds must not be empty');
    }

    final List<_MockMessageTemplate> script =
        _MockConversationsMessagesRegistry.getRandomGroupScript();

    final List<MessageDto> messages = <MessageDto>[];

    final DateTime conversationStart = _now.subtract(
      Duration(minutes: _random.nextInt(60 * 24 * 7)),
    );

    DateTime currentTime = conversationStart;

    String? lastSenderId;
    int remainingChainMessages = 0;

    for (int index = 0; index < messagesCount; index += 1) {
      final _MockMessageTemplate template = script[index % script.length];

      String senderId;

      if (remainingChainMessages > 0 && lastSenderId != null) {
        senderId = lastSenderId;
        remainingChainMessages -= 1;
      } else {
        final String templateSenderId =
            participantIds[template.senderIndex % participantIds.length];

        senderId = templateSenderId;

        final bool canStartChain = messagesCount - index >= 3;
        final bool shouldStartChain =
            canStartChain && _random.nextDouble() < 0.3;

        if (shouldStartChain) {
          int desiredChainLength = 3 + _random.nextInt(3);
          final int maxPossibleLength = messagesCount - index;

          if (desiredChainLength > maxPossibleLength) {
            desiredChainLength = maxPossibleLength;
          }

          remainingChainMessages = desiredChainLength - 1;
        }
      }

      final DateTime createdAt = currentTime;
      final DateTime updatedAt = createdAt;

      final String messageId = _generateMessageId();

      String? replyToMessageId;
      if (messages.isNotEmpty && _shouldReplyToPrevious()) {
        final MessageDto target = _pickReplyTarget(
          messages: messages,
          currentSenderId: senderId,
        );
        replyToMessageId = target.messageId;
      }

      DateTime? editedAt;
      if (_random.nextDouble() < 0.10) {
        final int editDeltaMinutes = 1 + _random.nextInt(15);
        editedAt = createdAt.add(Duration(minutes: editDeltaMinutes));
      }

      messages.add(
        MessageDto(
          messageId: messageId,
          clientMessageId: const Uuid().v4(),
          deliveryStatus: MessageDeliveryStatus.sent.toString(),
          conversationId: conversationId,
          senderId: senderId,
          text: template.text,
          hasAttachments: false,
          replyToMessageId: replyToMessageId,
          isPinned: false,
          isDeleted: false,
          editedAt: editedAt,
          createdAt: createdAt,
          updatedAt: updatedAt,
        ),
      );

      final int stepMinutes;
      if (senderId == lastSenderId) {
        stepMinutes = 1 + _random.nextInt(60);
      } else {
        stepMinutes = 1 + _random.nextInt(10);
      }

      currentTime = currentTime.add(Duration(minutes: stepMinutes));
      lastSenderId = senderId;
    }

    return messages.reversed.toList();
  }

  static List<MessageDto> getRandomChannelScript({
    required String conversationId,
    required List<String> adminIds,
    int messagesCount = 20,
  }) {
    if (adminIds.isEmpty) {
      throw StateError('adminIds must not be empty');
    }

    final List<_MockMessageTemplate> script =
        _MockConversationsMessagesRegistry.getRandomChannelScript();

    final List<MessageDto> messages = <MessageDto>[];

    final DateTime conversationStart = _now.subtract(
      Duration(minutes: _random.nextInt(60 * 24 * 30)),
    );

    DateTime currentTime = conversationStart;

    for (int index = 0; index < messagesCount; index += 1) {
      final _MockMessageTemplate template = script[index % script.length];

      final String senderId = adminIds[template.senderIndex % adminIds.length];

      final DateTime createdAt = currentTime;
      final DateTime updatedAt = createdAt;

      final String messageId = _generateMessageId();

      String? replyToMessageId;
      if (messages.isNotEmpty && _shouldReplyToPrevious()) {
        final MessageDto target = _pickReplyTarget(
          messages: messages,
          currentSenderId: senderId,
        );
        replyToMessageId = target.messageId;
      }

      messages.add(
        MessageDto(
          messageId: messageId,
          clientMessageId: const Uuid().v4(),
          deliveryStatus: MessageDeliveryStatus.sent.toString(),
          conversationId: conversationId,
          senderId: senderId,
          text: template.text,
          hasAttachments: false,
          replyToMessageId: replyToMessageId,
          isPinned: false,
          isDeleted: false,
          createdAt: createdAt,
          updatedAt: updatedAt,
        ),
      );

      final int stepMinutes = 10 + _random.nextInt(60);
      currentTime = currentTime.add(Duration(minutes: stepMinutes));
    }

    return messages;
  }

  static bool _shouldReplyToPrevious() {
    return _random.nextInt(100) < 30; // about 30% messages are replies
  }

  static MessageDto _pickReplyTarget({
    required List<MessageDto> messages,
    required String currentSenderId,
  }) {
    final List<MessageDto> otherSenderMessages = messages
        .where((MessageDto m) => m.senderId != currentSenderId)
        .toList();

    if (otherSenderMessages.isNotEmpty) {
      return otherSenderMessages[_random.nextInt(otherSenderMessages.length)];
    }

    return messages[_random.nextInt(messages.length)];
  }

  static String _generateMessageId() {
    return const Uuid().v4();
  }
}

class _MockMessageTemplate {
  const _MockMessageTemplate({required this.senderIndex, required this.text});

  final int senderIndex; // for private: 0 = first, 1 = second; for group: 0..N
  final String text;
}

abstract class _MockConversationsMessagesRegistry {
  static final Random _random = Random(42);

  static List<_MockMessageTemplate> getRandomPrivateScript() {
    return _privateScripts[_random.nextInt(_privateScripts.length)];
  }

  static List<_MockMessageTemplate> getRandomGroupScript() {
    return _groupScripts[_random.nextInt(_groupScripts.length)];
  }

  static List<_MockMessageTemplate> getRandomChannelScript() {
    return _channelScripts[_random.nextInt(_channelScripts.length)];
  }

  // ========================================================================
  // PRIVATE CONVERSATION SCRIPTS (ONE LANGUAGE PER SCRIPT)
  // ========================================================================

  static final List<List<_MockMessageTemplate>>
  _privateScripts = <List<_MockMessageTemplate>>[
    // English work chat with mixed sizes
    <_MockMessageTemplate>[
      const _MockMessageTemplate(
        senderIndex: 0,
        text: 'Hey, how are you doing today?',
      ),
      const _MockMessageTemplate(
        senderIndex: 1,
        text:
            'Hi, I am fine, just fixing some bugs in the app.\n\nI found a couple of crashes related to the new API integration.',
      ),
      const _MockMessageTemplate(
        senderIndex: 0,
        text:
            'Nice. Did you see the new design in Figma? The last version from 2024-09-18.',
      ),
      const _MockMessageTemplate(
        senderIndex: 1,
        text:
            'Yes, the mobile layout looks much cleaner now.\n\nButtons are larger and typography is more consistent.',
      ),
      const _MockMessageTemplate(
        senderIndex: 0,
        text: 'I will push an update to the dev server around 18:30.',
      ),
      const _MockMessageTemplate(
        senderIndex: 1,
        text:
            'Great, send me the link when it is ready. I want to test the onboarding flow end-to-end.',
      ),
      const _MockMessageTemplate(
        senderIndex: 0,
        text:
            'It will be available at:\nhttps://dev.example.com/app\n\nYou can log in with the test account: test_user / qwerty123.',
      ),
      const _MockMessageTemplate(
        senderIndex: 1,
        text:
            'Ok, I will test it on iOS and Android and will send you a small report with screenshots.',
      ),
      const _MockMessageTemplate(
        senderIndex: 0,
        text:
            'If you see any crash logs, just drop them here or upload to the shared folder.',
      ),
      const _MockMessageTemplate(
        senderIndex: 1,
        text:
            'Sure, I will share the logs as a .txt file if needed and mention the exact time when it happened.',
      ),
    ],

    // Russian everyday chat with paragraphs
    <_MockMessageTemplate>[
      const _MockMessageTemplate(
        senderIndex: 0,
        text: 'Привет, ты сегодня в офисе?',
      ),
      const _MockMessageTemplate(
        senderIndex: 1,
        text:
            'Привет, нет, работаю из дома.\n\nИнтернет вроде нормальный, так что созвоны должны быть без лагов.',
      ),
      const _MockMessageTemplate(
        senderIndex: 0,
        text: 'Ок, тогда созвонимся в Zoom в 11:00?',
      ),
      const _MockMessageTemplate(
        senderIndex: 1,
        text:
            'Да, кидай ссылку на созвон.\n\nЯ как раз к этому времени закончу с задачей по уведомлениям.',
      ),
      const _MockMessageTemplate(
        senderIndex: 0,
        text: 'Ссылка: https://zoom.us/j/123456789.',
      ),
      const _MockMessageTemplate(
        senderIndex: 1,
        text:
            'Спасибо, буду онлайн за 5 минут до начала.\n\nЕсли что-то поменяется по времени, просто напиши сюда.',
      ),
      const _MockMessageTemplate(
        senderIndex: 0,
        text:
            'Надо обсудить задачи на спринт, дедлайны и пару идей по редизайну.\n\nЯ набросал список в Notion, сейчас скину.',
      ),
      const _MockMessageTemplate(
        senderIndex: 1,
        text:
            'Ок, я подготовлю свои заметки по API и кейсам, которые мы еще не покрыли тестами.',
      ),
      const _MockMessageTemplate(
        senderIndex: 0,
        text: 'Отлично, тогда до созвона.',
      ),
      const _MockMessageTemplate(senderIndex: 1, text: 'Ок, до встречи.'),
    ],

    // English analytics / planning chat (no Russian mixed in)
    <_MockMessageTemplate>[
      const _MockMessageTemplate(
        senderIndex: 0,
        text:
            'Good morning. Did you check the analytics for yesterday?\n\nI am especially interested in retention for day 7.',
      ),
      const _MockMessageTemplate(
        senderIndex: 1,
        text:
            'Morning. Yes, we had 1243 active users, and retention D7 is around 37%.\n\nMost of the traffic comes from RU and KZ regions.',
      ),
      const _MockMessageTemplate(
        senderIndex: 0,
        text:
            'Nice growth. Most of them are from RU and KZ according to the chart.\n\nWe definitely need to improve localization for these regions.',
      ),
      const _MockMessageTemplate(
        senderIndex: 1,
        text:
            'I agree. I can go through the most visible screens and rewrite some texts to sound more natural.',
      ),
      const _MockMessageTemplate(
        senderIndex: 0,
        text:
            'I will update some strings in the l10n files and push them today.\n\nAfter that we can run a small A/B test.',
      ),
      const _MockMessageTemplate(
        senderIndex: 1,
        text:
            'Sounds good. Please ping me when the build is ready.\n\nI want to check the registration, password reset, and onboarding flows.',
      ),
      const _MockMessageTemplate(
        senderIndex: 0,
        text:
            'By the way, how is your internet today? Yesterday the call was laggy and audio was out of sync.',
      ),
      const _MockMessageTemplate(
        senderIndex: 1,
        text:
            'It is fine today, speed is around 100 Mbps.\n\nWe should be able to have a stable call and show the demo to the client.',
      ),
      const _MockMessageTemplate(
        senderIndex: 0,
        text:
            'Perfect, then we can plan a demo for Friday at 16:00.\n\nI will send a calendar invite with a short agenda.',
      ),
      const _MockMessageTemplate(
        senderIndex: 1,
        text:
            'Friday 16:00 works for me.\n\nPlease add questions about the roadmap and next quarter priorities to the agenda.',
      ),
    ],
  ];

  // ========================================================================
  // GROUP CONVERSATION SCRIPTS (ONE LANGUAGE PER SCRIPT)
  // senderIndex: 0..N (map to participants list in generator)
  // ========================================================================

  static final List<List<_MockMessageTemplate>>
  _groupScripts = <List<_MockMessageTemplate>>[
    // English standup-style group chat
    <_MockMessageTemplate>[
      const _MockMessageTemplate(
        senderIndex: 0,
        text: 'Good morning, team. Let us start the daily standup.',
      ),
      const _MockMessageTemplate(
        senderIndex: 1,
        text:
            'Yesterday I finished the login screen refactor.\n\nToday I will work on error handling and analytics events.',
      ),
      const _MockMessageTemplate(
        senderIndex: 2,
        text:
            'I fixed a couple of layout issues on the profile screen.\n\nNext I plan to work on the settings page navigation.',
      ),
      const _MockMessageTemplate(
        senderIndex: 3,
        text:
            'QA here. I will retest the last build and focus on regression around push notifications.',
      ),
      const _MockMessageTemplate(
        senderIndex: 0,
        text:
            'Any blockers for today?\n\nIf something is blocking you, please mention it here so we can resolve it quickly.',
      ),
      const _MockMessageTemplate(
        senderIndex: 1,
        text:
            'No blockers from my side, but I will need updated API docs later this week.',
      ),
      const _MockMessageTemplate(
        senderIndex: 4,
        text:
            'I am working on the backend changes.\n\nI will update the API documentation and share the link in this channel.',
      ),
      const _MockMessageTemplate(
        senderIndex: 0,
        text:
            'Great, thanks everyone.\n\nWe can sync again after lunch if needed.',
      ),
    ],

    // Russian рабочий групповой чат
    <_MockMessageTemplate>[
      const _MockMessageTemplate(
        senderIndex: 0,
        text: 'Всем привет, давайте коротко по задачам на сегодня.',
      ),
      const _MockMessageTemplate(
        senderIndex: 1,
        text:
            'Я вчера доделал экран профиля.\n\nСегодня займусь интеграцией с новым API для уведомлений.',
      ),
      const _MockMessageTemplate(
        senderIndex: 2,
        text:
            'Я работаю над списком чатов.\n\nНужно будет обсудить, как лучше отображать закреплённые сообщения.',
      ),
      const _MockMessageTemplate(
        senderIndex: 3,
        text:
            'Я сейчас в тестировании последнего билда.\n\nЕсли будут критичные баги, сразу напишу сюда с описанием и шагами.',
      ),
      const _MockMessageTemplate(
        senderIndex: 0,
        text:
            'Если у кого-то есть блокеры, сразу пишите.\n\nНе ждите созвона, лучше уточнить всё в чате.',
      ),
      const _MockMessageTemplate(
        senderIndex: 4,
        text:
            'У меня вопрос по дизайну экрана настроек.\n\nЯ скину пару вариантов в Figma и отмечу вас комментариями.',
      ),
      const _MockMessageTemplate(
        senderIndex: 2,
        text:
            'Ок, посмотри, пожалуйста, ещё цвета для тёмной темы.\n\nСейчас некоторые элементы выглядят слишком ярко.',
      ),
      const _MockMessageTemplate(
        senderIndex: 0,
        text: 'Хорошо, давайте всё финализируем до пятницы.\n\nСпасибо всем.',
      ),
    ],

    // English product/channel-like discussion
    <_MockMessageTemplate>[
      const _MockMessageTemplate(
        senderIndex: 0,
        text:
            'Welcome to the release planning group.\n\nHere we will discuss features for the next version.',
      ),
      const _MockMessageTemplate(
        senderIndex: 1,
        text:
            'I would like to propose improving the search experience.\n\nMany users complain that filters are not clear enough.',
      ),
      const _MockMessageTemplate(
        senderIndex: 2,
        text:
            'We also need to optimize the startup time.\n\nRight now the app feels slow on older devices.',
      ),
      const _MockMessageTemplate(
        senderIndex: 3,
        text:
            'From support side, the most frequent request is about password reset.\n\nPeople do not always see the “Forgot password” link.',
      ),
      const _MockMessageTemplate(
        senderIndex: 4,
        text:
            'Maybe we can add a short tooltip or an extra button on the login screen.\n\nThat would make the flow more visible.',
      ),
      const _MockMessageTemplate(
        senderIndex: 0,
        text:
            'Please, write your top 3 priorities for the next release here.\n\nWe will convert them into tickets later.',
      ),
      const _MockMessageTemplate(
        senderIndex: 1,
        text:
            'My list:\n1) Better search filters.\n2) Faster app startup.\n3) Improved empty state screens.',
      ),
      const _MockMessageTemplate(
        senderIndex: 2,
        text:
            'I agree with this list.\n\nI would also add more detailed logging for critical flows.',
      ),
    ],
  ];

  // ========================================================================
  // CHANNEL CONVERSATION SCRIPTS (ONE LANGUAGE PER SCRIPT)
  // senderIndex: 0..N (map to adminIds in generator)
  // ========================================================================

  static final List<List<_MockMessageTemplate>>
  _channelScripts = <List<_MockMessageTemplate>>[
    // English release announcement channel
    <_MockMessageTemplate>[
      const _MockMessageTemplate(
        senderIndex: 0,
        text:
            'Release 1.2.0 is now live.\n\nThis update includes performance improvements and several bug fixes.',
      ),
      const _MockMessageTemplate(
        senderIndex: 0,
        text:
            'Key changes:\n'
            '- Faster app startup time.\n'
            '- Improved stability on older devices.\n'
            '- Better error messages on login.',
      ),
      const _MockMessageTemplate(
        senderIndex: 1,
        text:
            'If you notice any issues after the update,\n'
            'please report them in the support chat or via email: support@example.com.',
      ),
      const _MockMessageTemplate(
        senderIndex: 0,
        text:
            'You can read the full changelog here:\n'
            'https://example.com/changelog/1.2.0',
      ),
    ],

    // Russian news/updates channel
    <_MockMessageTemplate>[
      const _MockMessageTemplate(
        senderIndex: 0,
        text:
            'Обновление версии 2.0.0 доступно для всех пользователей.\n\nМы переработали интерфейс и улучшили производительность.',
      ),
      const _MockMessageTemplate(
        senderIndex: 0,
        text:
            'Основные изменения:\n'
            '1) Новый дизайн главного экрана.\n'
            '2) Ускоренная загрузка чатов.\n'
            '3) Улучшена работа поиска по сообщениям.',
      ),
      const _MockMessageTemplate(
        senderIndex: 1,
        text:
            'Если после обновления вы заметите проблемы,\n'
            'пожалуйста, напишите нам через форму обратной связи в приложении.',
      ),
      const _MockMessageTemplate(
        senderIndex: 0,
        text:
            'Подробный список изменений доступен по ссылке:\n'
            'https://example.com/releases/2.0.0',
      ),
    ],

    // English product tips / education channel
    <_MockMessageTemplate>[
      const _MockMessageTemplate(
        senderIndex: 0,
        text:
            'Tip of the day:\n\nYou can pin important messages in any conversation to access them faster later.',
      ),
      const _MockMessageTemplate(
        senderIndex: 0,
        text:
            'How to pin a message:\n'
            '1) Long press on the message.\n'
            '2) Select "Pin message" from the menu.\n'
            '3) The message will appear in the pinned section.',
      ),
      const _MockMessageTemplate(
        senderIndex: 1,
        text:
            'We are also working on a short video guide\n'
            'that will be available on our website next week.',
      ),
      const _MockMessageTemplate(
        senderIndex: 0,
        text:
            'For more tips, check our help center:\n'
            'https://example.com/help',
      ),
    ],
  ];
}
