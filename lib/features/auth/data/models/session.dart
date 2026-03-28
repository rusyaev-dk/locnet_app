// ignore_for_file: sort_constructors_first

import 'package:equatable/equatable.dart';
import 'package:locnet_app/core/core.dart';

final class SessionDto extends Equatable {
  const SessionDto({
    required this.sessionId,
    required this.userId,
    required this.refreshToken,
    required this.accessToken,
    required this.accessExpiresAt,
    required this.refreshExpiresAt,
    required this.isExpired,
    required this.createdAt,
    required this.updatedAt,
    this.isTerminated,
    this.terminatedAt,
    this.ipAddress,
    this.macAddress,
    this.deviceName,
    this.deviceType,
    this.os,
  });

  final String sessionId;
  final String userId;
  final String refreshToken;
  final String accessToken;
  final DateTime accessExpiresAt;
  final DateTime refreshExpiresAt;
  final bool isExpired;
  final bool? isTerminated;
  final DateTime? terminatedAt;
  final String? ipAddress;
  final String? macAddress;
  final String? deviceName;
  final String? deviceType;
  final String? os;
  final DateTime createdAt;
  final DateTime updatedAt;

  factory SessionDto.fromJson(Map<String, dynamic> json) {
    return SessionDto(
      sessionId: json['sessionId'] as String,
      userId: json['userId'] as String,
      refreshToken: json['refreshToken'] as String,
      accessToken: json['accessToken'] as String,
      accessExpiresAt: DateTimeFormatter.parse(
        json['accessExpiresAt'] as String,
      ),
      refreshExpiresAt: DateTimeFormatter.parse(
        json['refreshExpiresAt'] as String,
      ),
      isExpired: json['isExpired'] as bool,
      isTerminated: json['isTerminated'] as bool?,
      terminatedAt: json['terminatedAt'] != null
          ? DateTimeFormatter.parse(json['terminatedAt'])
          : null,
      ipAddress: json['IPAddress'] as String? ?? json['ipAddress'] as String?,
      macAddress: json['macAddress'] as String?,
      deviceName: json['deviceName'] as String?,
      deviceType: json['deviceType'] as String?,
      os: json['OS'] as String? ?? json['os'] as String?,
      createdAt: DateTimeFormatter.parse(json['createdAt']),
      updatedAt: DateTimeFormatter.parse(json['updatedAt']),
    );
  }

  /// Converts this DTO to a JSON-compatible map.
  Map<String, dynamic> toJson() => <String, dynamic>{
    'sessionId': sessionId,
    'userId': userId,
    'refreshToken': refreshToken,
    'accessToken': accessToken,
    'accessExpiresAt': accessExpiresAt.toIso8601String(),
    'refreshExpiresAt': refreshExpiresAt.toIso8601String(),
    'isExpired': isExpired,
    'isTerminated': isTerminated,
    'terminatedAt': terminatedAt?.toIso8601String(),
    'IPAddress': ipAddress,
    'macAddress': macAddress,
    'deviceName': deviceName,
    'deviceType': deviceType,
    'OS': os,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };

  SessionDto copyWith({
    String? sessionId,
    String? userId,
    String? refreshToken,
    String? accessToken,
    DateTime? accessExpiresAt,
    DateTime? refreshExpiresAt,
    bool? isExpired,
    bool? isTerminated,
    DateTime? terminatedAt,
    String? ipAddress,
    String? macAddress,
    String? deviceName,
    String? deviceType,
    String? os,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return SessionDto(
      sessionId: sessionId ?? this.sessionId,
      userId: userId ?? this.userId,
      refreshToken: refreshToken ?? this.refreshToken,
      accessToken: accessToken ?? this.accessToken,
      accessExpiresAt: accessExpiresAt ?? this.accessExpiresAt,
      refreshExpiresAt: refreshExpiresAt ?? this.refreshExpiresAt,
      isExpired: isExpired ?? this.isExpired,
      isTerminated: isTerminated ?? this.isTerminated,
      terminatedAt: terminatedAt ?? this.terminatedAt,
      ipAddress: ipAddress ?? this.ipAddress,
      macAddress: macAddress ?? this.macAddress,
      deviceName: deviceName ?? this.deviceName,
      deviceType: deviceType ?? this.deviceType,
      os: os ?? this.os,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => <Object?>[
    sessionId,
    userId,
    refreshToken,
    accessToken,
    accessExpiresAt,
    refreshExpiresAt,
    isExpired,
    isTerminated,
    terminatedAt,
    ipAddress,
    macAddress,
    deviceName,
    deviceType,
    os,
    createdAt,
    updatedAt,
  ];
}
