// ignore_for_file: sort_constructors_first

import 'package:equatable/equatable.dart';
import 'package:locnet_app/features/message/subfeatures/media/data/models/media_metadata_dto.dart';

class MediaInitUploadResponseDto extends Equatable {
  const MediaInitUploadResponseDto({
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
  final MediaMetadataDto metadata;

  factory MediaInitUploadResponseDto.fromJson(Map<String, Object?> json) {
    final Map<String, String> headers =
        ((json['requiredHeaders'] ?? const {}) as Map<Object?, Object?>).map(
          (Object? key, Object? value) =>
              MapEntry((key ?? '').toString(), (value ?? '').toString()),
        );

    return MediaInitUploadResponseDto(
      mediaId: (json['mediaId'] ?? '') as String,
      uploadUrl: (json['uploadUrl'] ?? '') as String,
      expiresAt: DateTime.parse((json['expiresAt'] ?? '').toString()),
      requiredHeaders: headers,
      metadata: MediaMetadataDto.fromJson(
        (json['metadata'] ?? const <String, Object?>{}) as Map<String, Object?>,
      ),
    );
  }

  Map<String, Object?> toJson() {
    return <String, Object?>{
      'mediaId': mediaId,
      'uploadUrl': uploadUrl,
      'expiresAt': expiresAt.toIso8601String(),
      'requiredHeaders': requiredHeaders,
      'metadata': metadata.toJson(),
    };
  }

  MediaInitUploadResponseDto copyWith({
    String? mediaId,
    String? uploadUrl,
    DateTime? expiresAt,
    Map<String, String>? requiredHeaders,
    MediaMetadataDto? metadata,
  }) {
    return MediaInitUploadResponseDto(
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
