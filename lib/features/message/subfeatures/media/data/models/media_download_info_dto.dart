// ignore_for_file: sort_constructors_first

import 'package:equatable/equatable.dart';

class MediaDownloadInfoDto extends Equatable {
  const MediaDownloadInfoDto({
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

  factory MediaDownloadInfoDto.fromJson(Map<String, Object?> json) {
    DateTime parseDate(Object? raw) {
      if (raw is DateTime) {
        return raw;
      }
      final String fallback = DateTime.now().toUtc().toIso8601String();
      return DateTime.parse((raw ?? fallback).toString());
    }

    int parseInt(Object? raw) {
      if (raw is int) {
        return raw;
      }
      if (raw is num) {
        return raw.toInt();
      }
      return int.tryParse((raw ?? '0').toString()) ?? 0;
    }

    return MediaDownloadInfoDto(
      downloadUrl: (json['downloadUrl'] ?? '') as String,
      expiresAt: parseDate(json['expiresAt']),
      mimeType: (json['mimeType'] ?? '') as String,
      sizeBytes: parseInt(json['sizeBytes']),
      status: (json['status'] ?? '') as String,
      scope: (json['scope'] ?? '') as String,
      scopeId: (json['scopeId'] ?? '').toString(),
      ownerUserId: (json['ownerUserId'] ?? '').toString(),
      createdAt: parseDate(json['createdAt']),
      updatedAt: parseDate(json['updatedAt']),
      etag: (json['etag'] as String?)?.trim().isEmpty == true
          ? null
          : json['etag'] as String?,
    );
  }

  Map<String, Object?> toJson() {
    return <String, Object?>{
      'downloadUrl': downloadUrl,
      'expiresAt': expiresAt.toIso8601String(),
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

  MediaDownloadInfoDto copyWith({
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
    return MediaDownloadInfoDto(
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
