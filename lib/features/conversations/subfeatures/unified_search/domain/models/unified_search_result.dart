// ignore_for_file: sort_constructors_first

import 'package:equatable/equatable.dart';
import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/conversation/data/data.dart';
import 'package:locnet_app/features/conversation/domain/domain.dart';
import 'package:locnet_app/features/conversations/subfeatures/unified_search/data/data.dart';

final class UnifiedSearchResult extends Equatable {
  const UnifiedSearchResult({
    required this.users,
    required this.conversations,
  });

  final List<User> users;
  final List<Conversation> conversations;

  factory UnifiedSearchResult.fromDto(UnifiedSearchResultDto dto) {
    return UnifiedSearchResult(
      users: dto.users
          .map((UserDto userDto) => User.fromDto(userDto))
          .toList(growable: false),
      conversations: dto.conversations
          .map(
            (ConversationDto conversationDto) =>
                Conversation.fromDto(conversationDto),
          )
          .toList(growable: false),
    );
  }

  @override
  List<Object?> get props => [users, conversations];
}
