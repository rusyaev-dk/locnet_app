// ignore_for_file: sort_constructors_first

import 'package:equatable/equatable.dart';
import 'package:locnet_app/core/core.dart';

/// DTO for unified conversation tiles coming from backend.
///
/// This is intentionally detached from concrete conversation/message models
/// (private/group/channel) and carries just the data needed for the list.
class ConversationTileDto extends Equatable {
  const ConversationTileDto({
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

  /// 'private' | 'group' | 'channel'.
  final String type;

  final String title;
  final String? description;

  /// Optional companion user (for private chats).
  final UserDto? companion;

  final String? lastMessageText;
  final String? lastMessageSenderId;
  final DateTime? lastMessageAt;

  final DateTime updatedAt;

  factory ConversationTileDto.fromJson(Map<String, dynamic> json) {
    return ConversationTileDto(
      id: json['id'] as String,
      type: json['type'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      lastMessageText: json['lastMessageText'] as String?,
      lastMessageSenderId: json['lastMessageSenderId'] as String?,
      lastMessageAt: json['lastMessageAt'] != null
          ? DateTimeFormatter.parse(json['lastMessageAt'] as String)
          : null,
      updatedAt: DateTimeFormatter.parse(json['updatedAt'] as String),
      companion: json['companion'] != null
          ? UserDto.fromJson(json['companion'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'type': type,
        'title': title,
        'description': description,
        'lastMessageText': lastMessageText,
        'lastMessageSenderId': lastMessageSenderId,
        'lastMessageAt': lastMessageAt?.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
        'companion': companion?.toJson(),
      };

  ConversationTileDto copyWith({
    String? id,
    String? type,
    String? title,
    String? description,
    UserDto? companion,
    String? lastMessageText,
    String? lastMessageSenderId,
    DateTime? lastMessageAt,
    DateTime? updatedAt,
  }) {
    return ConversationTileDto(
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

