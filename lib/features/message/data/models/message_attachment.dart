// ignore_for_file: sort_constructors_first

import 'package:equatable/equatable.dart';

class MessageAttachmentDto extends Equatable {
  const MessageAttachmentDto({
    required this.clientAttachmentId,
    required this.createdAt,
    required this.updatedAt,
    this.attachmentId,
    this.messageId,
    this.fileId,
    this.position,
  });

  final String clientAttachmentId;
  final String? attachmentId;
  final String? messageId;
  final String? fileId;
  final int? position;
  final DateTime createdAt;
  final DateTime updatedAt;

  factory MessageAttachmentDto.fromJson(Map<String, dynamic> json) {
    DateTime parseNonNull(dynamic v) {
      if (v is DateTime) return v;
      if (v is int) return DateTime.fromMillisecondsSinceEpoch(v);
      return DateTime.parse(v as String);
    }

    return MessageAttachmentDto(
      clientAttachmentId: json['clientAttachmentId'] as String,
      attachmentId: json['attachmentId'] as String?,
      messageId: json['messageId'] as String?,
      fileId: json['fileId'] as String?,
      position: (json['position'] is String)
          ? int.tryParse(json['position'] as String)
          : (json['position'] as int?),
      createdAt: parseNonNull(json['createdAt']),
      updatedAt: parseNonNull(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'clientAttachmentId': clientAttachmentId,
    'attachmentId': attachmentId,
    'messageId': messageId,
    'fileId': fileId,
    'position': position,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };

  MessageAttachmentDto copyWith({
    String? clientAttachmentId,
    String? attachmentId,
    String? messageId,
    String? fileId,
    int? position,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return MessageAttachmentDto(
      clientAttachmentId: clientAttachmentId ?? this.clientAttachmentId,
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
    clientAttachmentId,
    attachmentId,
    messageId,
    fileId,
    position,
    createdAt,
    updatedAt,
  ];
}
