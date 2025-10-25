// ignore_for_file: sort_constructors_first

import 'package:equatable/equatable.dart';
import 'package:locnet_app/features/auth/data/data.dart';

class Session extends Equatable {
  const Session({
    required this.id,
    required this.userId,
    required this.expiresAt,
    required this.isExpired,
    required this.createdAt,
    required this.updatedAt,
    this.isTerminated = false,
    this.terminatedAt,
    this.ipAddress,
    this.macAddress,
    this.deviceName,
    this.deviceType,
    this.os,
  });

  final String id;
  final String userId;
  final DateTime expiresAt;
  final bool isExpired;
  final bool isTerminated;
  final DateTime? terminatedAt;
  final String? ipAddress;
  final String? macAddress;
  final String? deviceName;
  final String? deviceType;
  final String? os;
  final DateTime createdAt;
  final DateTime updatedAt;

  bool get isActive => !isExpired && !isTerminated;

  factory Session.fromDTO(SessionDTO dto) {
    return Session(
      id: dto.sessionId,
      userId: dto.userId,
      expiresAt: dto.expiresAt,
      isExpired: dto.isExpired,
      isTerminated: dto.isTerminated ?? false,
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

  /// Intentionally does not include tokens. Provide them via `AuthSession.toDTO()`.
  SessionDTO toDTO({
    required String refreshToken,
    required String accessToken,
  }) {
    return SessionDTO(
      sessionId: id,
      userId: userId,
      refreshToken: refreshToken,
      accessToken: accessToken,
      expiresAt: expiresAt,
      isExpired: isExpired,
      isTerminated: isTerminated,
      terminatedAt: terminatedAt,
      ipAddress: ipAddress,
      macAddress: macAddress,
      deviceName: deviceName,
      deviceType: deviceType,
      os: os,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  Session copyWith({
    String? id,
    String? userId,
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
    return Session(
      id: id ?? this.id,
      userId: userId ?? this.userId,
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
    id,
    userId,
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

/// Auth-only value object to carry tokens safely.
class TokenPair extends Equatable {
  const TokenPair({required this.accessToken, required this.refreshToken});

  final String accessToken;
  final String refreshToken;

  @override
  List<Object?> get props => <Object?>[accessToken, refreshToken];
}

/// Domain model for auth feature only. Wraps Session + tokens.
class AuthSession extends Equatable {
  const AuthSession({required this.session, required this.tokens});

  final Session session;
  final TokenPair tokens;

  factory AuthSession.fromDTO(SessionDTO dto) {
    return AuthSession(
      session: Session.fromDTO(dto),
      tokens: TokenPair(
        accessToken: dto.accessToken,
        refreshToken: dto.refreshToken,
      ),
    );
  }

  SessionDTO toDTO() {
    return session.toDTO(
      refreshToken: tokens.refreshToken,
      accessToken: tokens.accessToken,
    );
  }

  AuthSession copyWith({Session? session, TokenPair? tokens}) {
    return AuthSession(
      session: session ?? this.session,
      tokens: tokens ?? this.tokens,
    );
  }

  @override
  List<Object?> get props => <Object?>[session, tokens];
}
