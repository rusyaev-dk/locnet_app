// ignore_for_file: sort_constructors_first

import 'package:equatable/equatable.dart';
import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/conversations_list/subfeatures/unified_search/data/models/unified_search_conversation.dart';

final class UnifiedSearchResultDto extends Equatable {
  const UnifiedSearchResultDto({
    required this.users,
    required this.conversations,
  });

  final List<UserDto> users;
  final List<UnifiedSearchConversationDto> conversations;

  factory UnifiedSearchResultDto.fromJson(Map<String, dynamic> json) {
    return UnifiedSearchResultDto(
      users: (json['users'] as List<dynamic>? ?? <dynamic>[])
          .map(
            (dynamic item) =>
                UserDto.fromJson(item as Map<String, dynamic>),
          )
          .toList(growable: false),
      conversations:
          (json['conversations'] as List<dynamic>? ?? <dynamic>[])
              .map(
                (dynamic item) => UnifiedSearchConversationDto.fromJson(
                  item as Map<String, dynamic>,
                ),
              )
              .toList(growable: false),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'users': users.map((UserDto user) => user.toJson()).toList(growable: false),
      'conversations': conversations
          .map(
            (UnifiedSearchConversationDto conversation) => conversation.toJson(),
          )
          .toList(growable: false),
    };
  }

  @override
  List<Object?> get props => [users, conversations];
}
