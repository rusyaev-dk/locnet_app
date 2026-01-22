import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/conversation/data/data.dart';

final class MockUnifiedSearchHelper {
  static List<UserDto> filterUsers({
    required Iterable<UserDto> users,
    required String normalizedQuery,
  }) {
    return users
        .where((UserDto userDto) {
          final List<String> tokens = userTokens(userDto);
          return tokens.any((String value) => value.contains(normalizedQuery));
        })
        .toList(growable: false);
  }

  static List<ConversationDto> filterConversations({
    required Iterable<ConversationDto> conversations,
    required String normalizedQuery,
  }) {
    return conversations
        .where((ConversationDto conversationDto) {
          final List<String> tokens = conversationTokens(conversationDto);
          return tokens.any((String value) => value.contains(normalizedQuery));
        })
        .toList(growable: false);
  }

  static List<String> userTokens(UserDto userDto) {
    return <String>[
      userDto.username,
      userDto.firstName,
      userDto.lastName,
      userDto.patronymic ?? '',
      userDto.description ?? '',
    ].map((String value) => value.toLowerCase()).toList(growable: false);
  }

  static List<String> conversationTokens(ConversationDto conversationDto) {
    return <String>[
      conversationDto.title,
      conversationDto.description ?? '',
    ].map((String value) => value.toLowerCase()).toList(growable: false);
  }

  static List<UserDto> rankUsers({
    required List<UserDto> items,
    required String normalizedQuery,
  }) {
    final List<UserDto> sorted = items.toList(growable: true)
      ..sort((UserDto left, UserDto right) {
        final int leftScore = scoreUser(
          userDto: left,
          normalizedQuery: normalizedQuery,
        );
        final int rightScore = scoreUser(
          userDto: right,
          normalizedQuery: normalizedQuery,
        );

        if (leftScore != rightScore) {
          return rightScore.compareTo(leftScore);
        }

        final String leftKey = userSortKey(left).toLowerCase();
        final String rightKey = userSortKey(right).toLowerCase();
        return leftKey.compareTo(rightKey);
      });

    return sorted;
  }

  static int scoreUser({
    required UserDto userDto,
    required String normalizedQuery,
  }) {
    final String username = userDto.username.toLowerCase();
    final String firstName = userDto.firstName.toLowerCase();
    final String lastName = userDto.lastName.toLowerCase();
    final String patronymic = (userDto.patronymic ?? '').toLowerCase();

    int score = 0;

    if (username.startsWith(normalizedQuery)) score += 60;
    if (firstName.startsWith(normalizedQuery)) score += 40;
    if (lastName.startsWith(normalizedQuery)) score += 40;
    if (patronymic.startsWith(normalizedQuery)) score += 20;

    if (username.contains(normalizedQuery)) score += 25;
    if (firstName.contains(normalizedQuery)) score += 15;
    if (lastName.contains(normalizedQuery)) score += 15;
    if (patronymic.contains(normalizedQuery)) score += 5;

    return score;
  }

  static String userSortKey(UserDto userDto) {
    final String patronymic = userDto.patronymic ?? '';
    final String fullName =
        '${userDto.lastName} ${userDto.firstName} $patronymic'.trim();

    if (fullName.isNotEmpty) {
      return fullName;
    }

    return userDto.username;
  }

  static List<ConversationDto> rankConversations({
    required List<ConversationDto> items,
    required String normalizedQuery,
  }) {
    final List<ConversationDto> sorted = items.toList(growable: true)
      ..sort((ConversationDto left, ConversationDto right) {
        final int leftScore = scoreConversation(
          conversationDto: left,
          normalizedQuery: normalizedQuery,
        );
        final int rightScore = scoreConversation(
          conversationDto: right,
          normalizedQuery: normalizedQuery,
        );

        if (leftScore != rightScore) {
          return rightScore.compareTo(leftScore);
        }

        final String leftKey = left.title.toLowerCase();
        final String rightKey = right.title.toLowerCase();
        return leftKey.compareTo(rightKey);
      });

    return sorted;
  }

  static int scoreConversation({
    required ConversationDto conversationDto,
    required String normalizedQuery,
  }) {
    final String title = conversationDto.title.toLowerCase();
    final String description = (conversationDto.description ?? '')
        .toLowerCase();

    int score = 0;

    if (title.startsWith(normalizedQuery)) score += 60;
    if (title.contains(normalizedQuery)) score += 30;

    if (description.startsWith(normalizedQuery)) score += 10;
    if (description.contains(normalizedQuery)) score += 5;

    return score;
  }
}
