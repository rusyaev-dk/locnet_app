// ignore_for_file: sort_constructors_first

import 'package:equatable/equatable.dart';

class SessionDTO extends Equatable {
  const SessionDTO({
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

  final String sessionId; // uuid
  final String userId; // uuid
  final String refreshToken; // text
  final String accessToken; // text
  final DateTime expiresAt; // timestamp
  final bool isExpired; // boolean
  final bool? isTerminated; // boolean?
  final DateTime? terminatedAt; // timestamp?
  final String? ipAddress; // varchar?
  final String? macAddress; // varchar?
  final String? deviceName; // varchar?
  final String? deviceType; // varchar?
  final String? os; // varchar?
  final DateTime createdAt; // timestamp
  final DateTime updatedAt; // timestamp

  factory SessionDTO.fromJson(Map<String, dynamic> json) {
    DateTime nn(dynamic v) {
      if (v is DateTime) return v;
      if (v is int) return DateTime.fromMillisecondsSinceEpoch(v);
      return DateTime.parse(v as String);
    }

    DateTime? opt(dynamic v) {
      if (v == null) return null;
      if (v is DateTime) return v;
      if (v is int) return DateTime.fromMillisecondsSinceEpoch(v);
      return DateTime.parse(v as String);
    }

    return SessionDTO(
      sessionId: json['sessionId'] as String,
      userId: json['userId'] as String,
      refreshToken: json['refreshToken'] as String,
      accessToken: json['accessToken'] as String,
      expiresAt: nn(json['expiresAt']),
      isExpired: json['isExpired'] as bool,
      isTerminated: json['isTerminated'] as bool?,
      terminatedAt: opt(json['terminatedAt']),
      ipAddress: json['IPAddress'] as String? ?? json['ipAddress'] as String?,
      macAddress: json['macAddress'] as String?,
      deviceName: json['deviceName'] as String?,
      deviceType: json['deviceType'] as String?,
      os: json['OS'] as String? ?? json['os'] as String?,
      createdAt: nn(json['createdAt']),
      updatedAt: nn(json['updatedAt']),
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
    'IPAddress': ipAddress,
    'macAddress': macAddress,
    'deviceName': deviceName,
    'deviceType': deviceType,
    'OS': os,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };

  SessionDTO copyWith({
    String? sessionId,
    String? userId,
    String? refreshToken,
    String? accessToken,
    DateTime? expiresAt,
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
    return SessionDTO(
      sessionId: sessionId ?? this.sessionId,
      userId: userId ?? this.userId,
      refreshToken: refreshToken ?? this.refreshToken,
      accessToken: accessToken ?? this.accessToken,
      expiresAt: expiresAt ?? this.expiresAt,
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
