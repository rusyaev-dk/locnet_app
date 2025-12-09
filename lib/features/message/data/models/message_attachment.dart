// ignore_for_file: sort_constructors_first

import 'package:equatable/equatable.dart';

class MessageAttachmentDto extends Equatable {
  const MessageAttachmentDto({
    required this.attachmentId,
    required this.messageId,
    required this.createdAt,
    required this.updatedAt,
    this.fileId,
    this.position,
  });

  final String attachmentId; // uuid
  final String messageId; // uuid
  final String? fileId; // uuid?
  final int? position; // bigint? -> Dart int is arbitrary precision
  final DateTime createdAt; // timestamp
  final DateTime updatedAt; // timestamp

  factory MessageAttachmentDto.fromJson(Map<String, dynamic> json) {
    DateTime parseNonNull(dynamic v) {
      if (v is DateTime) return v;
      if (v is int) return DateTime.fromMillisecondsSinceEpoch(v);
      return DateTime.parse(v as String);
    }

    return MessageAttachmentDto(
      attachmentId: json['attachmentId'] as String,
      messageId: json['messageId'] as String,
      fileId: json['fileId'] as String?,
      position: (json['position'] is String)
          ? int.tryParse(json['position'] as String)
          : (json['position'] as int?),
      createdAt: parseNonNull(json['createdAt']),
      updatedAt: parseNonNull(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'attachmentId': attachmentId,
    'messageId': messageId,
    'fileId': fileId,
    'position': position,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };

  MessageAttachmentDto copyWith({
    String? attachmentId,
    String? messageId,
    String? fileId,
    int? position,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return MessageAttachmentDto(
      attachmentId: attachmentId ?? this.attachmentId,
      messageId: messageId ?? this.messageId,
      fileId: fileId ?? this.fileId,
      position: position ?? this.position,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => <Object?>[
    attachmentId,
    messageId,
    fileId,
    position,
    createdAt,
    updatedAt,
  ];
}
