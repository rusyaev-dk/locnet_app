// ignore_for_file: sort_constructors_first

import 'package:equatable/equatable.dart';
import 'package:locnet_app/features/message/subfeatures/media/data/models/media_init_upload_response.dart';
import 'package:locnet_app/features/message/subfeatures/media/domain/models/media_metadata.dart';

class MediaInitUpload extends Equatable {
  const MediaInitUpload({
    required this.mediaId,
    required this.uploadUrl,
    required this.expiresAt,
    required this.requiredHeaders,
    required this.metadata,
  });

  final String mediaId;
  final String uploadUrl;
  final DateTime expiresAt;
  final Map<String, String> requiredHeaders;
  final MediaMetadata metadata;

  factory MediaInitUpload.fromDto(MediaInitUploadResponseDto dto) {
    return MediaInitUpload(
      mediaId: dto.mediaId,
      uploadUrl: dto.uploadUrl,
      expiresAt: dto.expiresAt,
      requiredHeaders: dto.requiredHeaders,
      metadata: MediaMetadata.fromDto(dto.metadata),
    );
  }

  MediaInitUpload copyWith({
    String? mediaId,
    String? uploadUrl,
    DateTime? expiresAt,
    Map<String, String>? requiredHeaders,
    MediaMetadata? metadata,
  }) {
    return MediaInitUpload(
      mediaId: mediaId ?? this.mediaId,
      uploadUrl: uploadUrl ?? this.uploadUrl,
      expiresAt: expiresAt ?? this.expiresAt,
      requiredHeaders: requiredHeaders ?? this.requiredHeaders,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  List<Object?> get props => <Object?>[
    mediaId,
    uploadUrl,
    expiresAt,
    requiredHeaders,
    metadata,
  ];
}
