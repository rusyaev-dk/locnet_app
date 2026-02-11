// ignore_for_file: sort_constructors_first

import 'package:equatable/equatable.dart';
import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/conversations_list/subfeatures/unified_search/data/data.dart';
import 'package:locnet_app/features/conversations_list/subfeatures/unified_search/domain/models/unified_search_conversation.dart';

final class UnifiedSearchResult extends Equatable {
  const UnifiedSearchResult({
    required this.users,
    required this.conversations,
  });

  final List<User> users;
  final List<UnifiedSearchConversation> conversations;

  factory UnifiedSearchResult.fromDto(UnifiedSearchResultDto dto) {
    return UnifiedSearchResult(
      users: dto.users
          .map((UserDto userDto) => User.fromDto(userDto))
          .toList(growable: false),
      conversations: dto.conversations
          .map(
            (UnifiedSearchConversationDto conversationDto) =>
                UnifiedSearchConversation.fromDto(conversationDto),
          )
          .toList(growable: false),
    );
  }

  @override
  List<Object?> get props => [users, conversations];
}
