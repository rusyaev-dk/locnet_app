// ignore_for_file: sort_constructors_first

import 'package:equatable/equatable.dart';
import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/conversations_list/subfeatures/unified_search/data/data.dart';

enum UnifiedSearchConversationType {
  private('private'),
  group('group'),
  channel('channel');

  const UnifiedSearchConversationType(this.value);
  final String value;

  factory UnifiedSearchConversationType.fromString(String value) {
    return UnifiedSearchConversationType.values.firstWhere(
      (UnifiedSearchConversationType type) => type.value == value,
      orElse: () => UnifiedSearchConversationType.private,
    );
  }
}

/// Domain model for a conversation item in unified search results.
final class UnifiedSearchConversation extends Equatable {
  const UnifiedSearchConversation({
    required this.id,
    required this.type,
    required this.title,
    this.description,
    this.companion,
  });

  final String id;
  final UnifiedSearchConversationType type;
  final String title;
  final String? description;
  final User? companion;

  factory UnifiedSearchConversation.fromDto(UnifiedSearchConversationDto dto) {
    return UnifiedSearchConversation(
      id: dto.id,
      type: UnifiedSearchConversationType.fromString(dto.type),
      title: dto.title,
      description: dto.description,
      companion: dto.companion != null ? User.fromDto(dto.companion!) : null,
    );
  }

  @override
  List<Object?> get props => <Object?>[id, type, title, description, companion];
}
