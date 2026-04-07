// ignore_for_file: sort_constructors_first

import 'package:equatable/equatable.dart';
import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/conversations_list/subfeatures/unified_search/data/models/unified_search_conversation.dart';

final class UnifiedSearchResultDto extends Equatable {
  const UnifiedSearchResultDto({
    required this.users,
    required this.groups,
    required this.channels,
    required this.conversations,
  });

  final List<UserDto> users;
  final List<UnifiedSearchConversationDto> groups;
  final List<UnifiedSearchConversationDto> channels;
  final List<UnifiedSearchConversationDto> conversations;

  factory UnifiedSearchResultDto.fromJson(Map<String, dynamic> json) {
    return UnifiedSearchResultDto(
      users: (json['users'] as List<dynamic>? ?? <dynamic>[])
          .map(
            (dynamic item) =>
                UserDto.fromJson(item as Map<String, dynamic>),
          )
          .toList(growable: false),
      groups: _conversationListFromJson(json['groups'] as List<dynamic>?),
      channels: _conversationListFromJson(json['channels'] as List<dynamic>?),
      conversations: _conversationListFromJson(
        json['conversations'] as List<dynamic>?,
      ),
    );
  }

  static List<UnifiedSearchConversationDto> _conversationListFromJson(
    List<dynamic>? raw,
  ) {
    return (raw ?? <dynamic>[])
        .map(
          (dynamic item) => UnifiedSearchConversationDto.fromJson(
            item as Map<String, dynamic>,
          ),
        )
        .toList(growable: false);
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'users': users.map((UserDto user) => user.toJson()).toList(growable: false),
      'groups': groups
          .map(
            (UnifiedSearchConversationDto conversation) => conversation.toJson(),
          )
          .toList(growable: false),
      'channels': channels
          .map(
            (UnifiedSearchConversationDto conversation) => conversation.toJson(),
          )
          .toList(growable: false),
      'conversations': conversations
          .map(
            (UnifiedSearchConversationDto conversation) => conversation.toJson(),
          )
          .toList(growable: false),
    };
  }

  @override
  List<Object?> get props => [users, groups, channels, conversations];
}
