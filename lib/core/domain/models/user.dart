// ignore_for_file: sort_constructors_first

import 'package:equatable/equatable.dart';
import 'package:locnet_app/core/core.dart';

class User extends Equatable {
  const User({
    required this.userId,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.languageCode,
    required this.isDeleted,
    required this.isBanned,
    required this.createdAt,
    required this.updatedAt,
    this.description,
    this.avatarId,
  });

  final String userId;
  final String username;
  final String firstName;
  final String lastName;
  final String languageCode; // ISO language code, e.g. 'en', 'ru'
  final String? description;
  final String? avatarId;
  final bool isDeleted;
  final bool isBanned;
  final DateTime createdAt;
  final DateTime updatedAt;

  String get fullName =>
      [firstName,  lastName].join(' ');

  bool get isActive => !isDeleted && !isBanned;

  factory User.fromDTO(UserDTO dto) {
    return User(
      userId: dto.userId,
      username: dto.username,
      firstName: dto.firstName,
      languageCode: dto.languageCode,
      lastName: dto.lastName,
      description: dto.description,
      avatarId: dto.avatarId,
      isDeleted: dto.isDeleted,
      isBanned: dto.isBanned,
      createdAt: dto.createdAt,
      updatedAt: dto.updatedAt,
    );
  }

  factory User.fromJSON(Map<String, dynamic> json) {
    return User(
      userId: json['userId'] as String,
      username: json['username'] as String,
      firstName: json['firstName'] as String,
      languageCode: json['languageCode'] as String,
      lastName: json['lastName'] as String,
      description: json['description'] as String?,
      avatarId: json['avatarId'] as String?,
      isDeleted: json['isDeleted'] as bool,
      isBanned: json['isBanned'] as bool,
      createdAt: DateTimeFormatter.parse(json['createdAt']),
      updatedAt: DateTimeFormatter.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJSON() => <String, dynamic>{
        'userId': userId,
        'username': username,
        'firstName': firstName,
        'languageCode': languageCode,
        'lastName': lastName,
        'description': description,
        'avatarId': avatarId,
        'isDeleted': isDeleted,
        'isBanned': isBanned,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };

  User copyWith({
    String? userId,
    String? username,
    String? firstName,
    String? languageCode,
    String? lastName,
    String? description,
    String? avatarId,
    bool? isDeleted,
    bool? isBanned,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      userId: userId ?? this.userId,
      username: username ?? this.username,
      firstName: firstName ?? this.firstName,
      languageCode: languageCode ?? this.languageCode,
      lastName: lastName ?? this.lastName,
      description: description ?? this.description,
      avatarId: avatarId ?? this.avatarId,
      isDeleted: isDeleted ?? this.isDeleted,
      isBanned: isBanned ?? this.isBanned,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => <Object?>[
        userId,
        username,
        firstName,
        languageCode,
        lastName,
        description,
        avatarId,
        isDeleted,
        isBanned,
        createdAt,
        updatedAt,
      ];
}
