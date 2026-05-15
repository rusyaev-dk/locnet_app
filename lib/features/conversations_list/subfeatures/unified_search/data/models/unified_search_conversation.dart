// ignore_for_file: sort_constructors_first

import 'package:equatable/equatable.dart';
import 'package:locnet_app/core/core.dart';

/// Lightweight conversation representation for unified search results.
///
/// Covers private chats, groups and channels in a unified way.
final class UnifiedSearchConversationDto extends Equatable {
  const UnifiedSearchConversationDto({
    required this.id,
    required this.type,
    required this.title,
    this.description,
    this.companion,
  });

  /// Conversation identifier (private / group / channel id).
  final String id;

  /// Conversation type: 'private' | 'group' | 'channel'.
  final String type;

  final String title;
  final String? description;
  final UserDto? companion;

  factory UnifiedSearchConversationDto.fromJson(Map<String, dynamic> json) {
    return UnifiedSearchConversationDto(
      id: (json['id'] ?? json['conversation']?['conversationId']) as String,
      type: json['type'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      companion: json['companion'] is Map<String, dynamic>
          ? UserDto.fromJson(json['companion'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'type': type,
    'title': title,
    'description': description,
    'companion': companion?.toJson(),
  };

  @override
  List<Object?> get props => <Object?>[id, type, title, description, companion];
}
