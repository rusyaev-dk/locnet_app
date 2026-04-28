// ignore_for_file: sort_constructors_first

import 'package:equatable/equatable.dart';
import 'package:locnet_app/features/message/subfeatures/media/data/models/media_download_info_dto.dart';

class MediaDownloadInfo extends Equatable {
  const MediaDownloadInfo({
    required this.downloadUrl,
    required this.expiresAt,
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

  final String downloadUrl;
  final DateTime expiresAt;
  final String mimeType;
  final int sizeBytes;
  final String status;
  final String scope;
  final String scopeId;
  final String ownerUserId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? etag;

  factory MediaDownloadInfo.fromDto(MediaDownloadInfoDto dto) {
    return MediaDownloadInfo(
      downloadUrl: dto.downloadUrl,
      expiresAt: dto.expiresAt,
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

  MediaDownloadInfo copyWith({
    String? downloadUrl,
    DateTime? expiresAt,
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
    return MediaDownloadInfo(
      downloadUrl: downloadUrl ?? this.downloadUrl,
      expiresAt: expiresAt ?? this.expiresAt,
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
    downloadUrl,
    expiresAt,
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
