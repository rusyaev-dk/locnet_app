// ignore_for_file: sort_constructors_first

import 'package:equatable/equatable.dart';
import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/conversations_list/data/data.dart';

/// Unified tile type for conversations list.
///
/// Represents private chats, groups, and channels in a single model.
enum ConversationTileType { private, group, channel }

class ConversationTile extends Equatable {
  const ConversationTile({
    required this.id,
    required this.type,
    required this.title,
    required this.updatedAt,
    this.description,
    this.companion,
    this.lastMessageText,
    this.lastMessageSenderId,
    this.lastMessageAt,
  });

  /// Conversation / group / channel id.
  final String id;

  /// Type of conversation (private / group / channel).
  final ConversationTileType type;

  /// Display title (for private it can be a generic label or companion name).
  final String title;

  final String? description;

  /// For private chats – resolved companion user (optional for others).
  final User? companion;

  /// Text of the last message/publication, if any.
  final String? lastMessageText;

  /// Sender id of the last message/publication, if any.
  final String? lastMessageSenderId;

  /// Timestamp of the last message/publication, if any.
  final DateTime? lastMessageAt;

  /// Last updated timestamp of the underlying conversation entity.
  final DateTime updatedAt;

  factory ConversationTile.fromDto(ConversationTileDto dto) {
    return ConversationTile(
      id: dto.id,
      type: switch (dto.type) {
        'private' => ConversationTileType.private,
        'group' => ConversationTileType.group,
        'channel' => ConversationTileType.channel,
        _ => ConversationTileType.private,
      },
      title: dto.title,
      description: dto.description,
      companion: dto.companion != null ? User.fromDto(dto.companion!) : null,
      lastMessageText: dto.lastMessageText,
      lastMessageSenderId: dto.lastMessageSenderId,
      lastMessageAt: dto.lastMessageAt,
      updatedAt: dto.updatedAt,
    );
  }

  ConversationTile copyWith({
    String? id,
    ConversationTileType? type,
    String? title,
    String? description,
    User? companion,
    String? lastMessageText,
    String? lastMessageSenderId,
    DateTime? lastMessageAt,
    DateTime? updatedAt,
  }) {
    return ConversationTile(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      description: description ?? this.description,
      companion: companion ?? this.companion,
      lastMessageText: lastMessageText ?? this.lastMessageText,
      lastMessageSenderId: lastMessageSenderId ?? this.lastMessageSenderId,
      lastMessageAt: lastMessageAt ?? this.lastMessageAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => <Object?>[
    id,
    type,
    title,
    description,
    companion,
    lastMessageText,
    lastMessageSenderId,
    lastMessageAt,
    updatedAt,
  ];
}
