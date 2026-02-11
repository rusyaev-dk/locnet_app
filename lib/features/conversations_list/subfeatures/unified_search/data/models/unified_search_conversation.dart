// ignore_for_file: sort_constructors_first

import 'package:equatable/equatable.dart';

/// Lightweight conversation representation for unified search results.
///
/// Covers private chats, groups and channels in a unified way.
final class UnifiedSearchConversationDto extends Equatable {
  const UnifiedSearchConversationDto({
    required this.id,
    required this.type,
    required this.title,
    this.description,
  });

  /// Conversation identifier (private / group / channel id).
  final String id;

  /// Conversation type: 'private' | 'group' | 'channel'.
  final String type;

  final String title;
  final String? description;

  factory UnifiedSearchConversationDto.fromJson(Map<String, dynamic> json) {
    return UnifiedSearchConversationDto(
      id: json['id'] as String,
      type: json['type'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'type': type,
        'title': title,
        'description': description,
      };

  @override
  List<Object?> get props => <Object?>[id, type, title, description];
}

