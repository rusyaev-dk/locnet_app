// ignore_for_file: sort_constructors_first

import 'package:equatable/equatable.dart';
import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/auth/data/data.dart';

class Session extends Equatable {
  const Session({
    required this.sessionId,
    required this.userId,
    required this.refreshToken,
    required this.accessToken,
    required this.expiresAt,
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
  final DateTime expiresAt;
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

  factory Session.fromDto(SessionDto dto) {
    return Session(
      sessionId: dto.sessionId,
      userId: dto.userId,
      refreshToken: dto.refreshToken,
      accessToken: dto.accessToken,
      expiresAt: dto.expiresAt,
      isExpired: dto.isExpired,
      isTerminated: dto.isTerminated,
      terminatedAt: dto.terminatedAt,
      ipAddress: dto.ipAddress,
      macAddress: dto.macAddress,
      deviceName: dto.deviceName,
      deviceType: dto.deviceType,
      os: dto.os,
      createdAt: dto.createdAt,
      updatedAt: dto.updatedAt,
    );
  }

  factory Session.fromJson(Map<String, dynamic> json) {
    return Session(
      sessionId: json['sessionId'] as String,
      userId: json['userId'] as String,
      refreshToken: json['refreshToken'] as String,
      accessToken: json['accessToken'] as String,
      expiresAt: DateTimeFormatter.parse(json['expiresAt']),
      isExpired: json['isExpired'] as bool,
      isTerminated: json['isTerminated'] as bool?,
      terminatedAt: json['terminatedAt'] != null
          ? DateTimeFormatter.parse(json['terminatedAt'])
          : null,
      ipAddress: json['ipAddress'] as String?,
      macAddress: json['macAddress'] as String?,
      deviceName: json['deviceName'] as String?,
      deviceType: json['deviceType'] as String?,
      os: json['os'] as String?,
      createdAt: DateTimeFormatter.parse(json['createdAt']),
      updatedAt: DateTimeFormatter.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'sessionId': sessionId,
    'userId': userId,
    'refreshToken': refreshToken,
    'accessToken': accessToken,
    'expiresAt': expiresAt.toIso8601String(),
    'isExpired': isExpired,
    'isTerminated': isTerminated,
    'terminatedAt': terminatedAt?.toIso8601String(),
    'ipAddress': ipAddress,
    'macAddress': macAddress,
    'deviceName': deviceName,
    'deviceType': deviceType,
    'os': os,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };

  @override
  List<Object?> get props => <Object?>[
    sessionId,
    userId,
    refreshToken,
    accessToken,
    expiresAt,
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
