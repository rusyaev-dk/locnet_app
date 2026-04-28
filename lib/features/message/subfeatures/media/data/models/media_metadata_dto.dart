// ignore_for_file: sort_constructors_first

import 'package:equatable/equatable.dart';

class MediaMetadataDto extends Equatable {
  const MediaMetadataDto({
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

  factory MediaMetadataDto.fromJson(Map<String, Object?> json) {
    return MediaMetadataDto(
      mediaId: (json['mediaId'] ?? '') as String,
      mimeType: (json['mimeType'] ?? '') as String,
      sizeBytes: (json['sizeBytes'] ?? 0) as int,
      status: (json['status'] ?? '') as String,
      scope: (json['scope'] ?? '') as String,
      scopeId: (json['scopeId'] ?? '') as String,
      ownerUserId: (json['ownerUserId'] ?? '') as String,
      createdAt: DateTime.parse((json['createdAt'] ?? '').toString()),
      updatedAt: DateTime.parse((json['updatedAt'] ?? '').toString()),
      etag: (json['etag'] as String?)?.trim().isEmpty == true
          ? null
          : json['etag'] as String?,
    );
  }

  Map<String, Object?> toJson() {
    return <String, Object?>{
      'mediaId': mediaId,
      'mimeType': mimeType,
      'sizeBytes': sizeBytes,
      'status': status,
      'scope': scope,
      'scopeId': scopeId,
      'ownerUserId': ownerUserId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'etag': etag,
    };
  }

  MediaMetadataDto copyWith({
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
    return MediaMetadataDto(
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
