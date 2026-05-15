// ignore_for_file: sort_constructors_first

import 'package:equatable/equatable.dart';
import 'package:locnet_app/features/message/subfeatures/media/data/models/media_complete_upload_response.dart';
import 'package:locnet_app/features/message/subfeatures/media/domain/models/media_metadata.dart';

class MediaCompleteUpload extends Equatable {
  const MediaCompleteUpload({
    required this.mediaId,
    required this.status,
    required this.metadata,
  });

  final String mediaId;
  final String status;
  final MediaMetadata metadata;

  factory MediaCompleteUpload.fromDto(MediaCompleteUploadResponseDto dto) {
    return MediaCompleteUpload(
      mediaId: dto.mediaId,
      status: dto.status,
      metadata: MediaMetadata.fromDto(dto.metadata),
    );
  }

  MediaCompleteUpload copyWith({
    String? mediaId,
    String? status,
    MediaMetadata? metadata,
  }) {
    return MediaCompleteUpload(
      mediaId: mediaId ?? this.mediaId,
      status: status ?? this.status,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  List<Object?> get props => <Object?>[mediaId, status, metadata];
}
