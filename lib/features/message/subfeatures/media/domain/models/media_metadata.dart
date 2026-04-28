// ignore_for_file: sort_constructors_first

import 'package:equatable/equatable.dart';
import 'package:locnet_app/features/message/subfeatures/media/data/models/media_metadata_dto.dart';

class MediaMetadata extends Equatable {
  const MediaMetadata({
    required this.mediaId,
    required this.mimeType,
    required this.sizeBytes,
    required this.status,
    required this.scope,
    required this.scopeId,
    required this.ownerUserId,
    required this.createdAt,
    required this.updatedAt,
    required this.etag,
  });

  final String mediaId;
  final String mimeType;
  final int sizeBytes;
  final String status;
  final String scope;
  final String scopeId;
  final String ownerUserId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? etag;

  factory MediaMetadata.fromDto(MediaMetadataDto dto) {
    return MediaMetadata(
      mediaId: dto.mediaId,
      mimeType: dto.mimeType,
      sizeBytes: dto.sizeBytes,
      status: dto.status,
      scope: dto.scope,
      scopeId: dto.scopeId,
      ownerUserId: dto.ownerUserId,
      createdAt: dto.createdAt,
      updatedAt: dto.updatedAt,
      etag: dto.etag,
    );
  }

  MediaMetadata copyWith({
    String? mediaId,
    String? mimeType,
    int? sizeBytes,
    String? status,
    String? scope,
    String? scopeId,
    String? ownerUserId,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? etag,
  }) {
    return MediaMetadata(
      mediaId: mediaId ?? this.mediaId,
      mimeType: mimeType ?? this.mimeType,
      sizeBytes: sizeBytes ?? this.sizeBytes,
      status: status ?? this.status,
      scope: scope ?? this.scope,
      scopeId: scopeId ?? this.scopeId,
      ownerUserId: ownerUserId ?? this.ownerUserId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      etag: etag ?? this.etag,
    );
  }

  @override
  List<Object?> get props => <Object?>[
    mediaId,
    mimeType,
    sizeBytes,
    status,
    scope,
    scopeId,
    ownerUserId,
    createdAt,
    updatedAt,
    etag,
  ];
}
