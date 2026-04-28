// ignore_for_file: sort_constructors_first

import 'package:equatable/equatable.dart';
import 'package:locnet_app/features/message/subfeatures/media/data/models/media_metadata_dto.dart';

class MediaCompleteUploadResponseDto extends Equatable {
  const MediaCompleteUploadResponseDto({
    required this.mediaId,
    required this.status,
    required this.metadata,
  });

  final String mediaId;
  final String status;
  final MediaMetadataDto metadata;

  factory MediaCompleteUploadResponseDto.fromJson(Map<String, Object?> json) {
    return MediaCompleteUploadResponseDto(
      mediaId: (json['mediaId'] ?? '') as String,
      status: (json['status'] ?? '') as String,
      metadata: MediaMetadataDto.fromJson(
        (json['metadata'] ?? const <String, Object?>{}) as Map<String, Object?>,
      ),
    );
  }

  Map<String, Object?> toJson() {
    return <String, Object?>{
      'mediaId': mediaId,
      'status': status,
      'metadata': metadata.toJson(),
    };
  }

  MediaCompleteUploadResponseDto copyWith({
    String? mediaId,
    String? status,
    MediaMetadataDto? metadata,
  }) {
    return MediaCompleteUploadResponseDto(
      mediaId: mediaId ?? this.mediaId,
      status: status ?? this.status,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  List<Object?> get props => <Object?>[mediaId, status, metadata];
}
