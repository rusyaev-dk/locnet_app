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
    this.patronymic,
    this.description,
    this.avatarId,
  });

  final String userId;
  final String username;
  final String firstName;
  final String lastName;
  final String? patronymic;
  final String languageCode;
  final String? description;
  final String? avatarId;
  final bool isDeleted;
  final bool isBanned;
  final DateTime createdAt;
  final DateTime updatedAt;

  String get fullName =>
      [firstName, patronymic, lastName].whereType<String>().join(' ');

  bool get isActive => !isDeleted && !isBanned;

  factory User.fromDto(UserDto dto) {
    return User(
      userId: dto.userId,
      username: dto.username,
      firstName: dto.firstName,
      lastName: dto.lastName,
      patronymic: dto.patronymic,
      languageCode: dto.languageCode,
      description: dto.description,
      avatarId: dto.avatarId,
      isDeleted: dto.isDeleted,
      isBanned: dto.isBanned,
      createdAt: dto.createdAt,
      updatedAt: dto.updatedAt,
    );
  }

  UserDto toDto() {
    return UserDto(
      userId: userId,
      username: username,
      firstName: firstName,
      lastName: lastName,
      patronymic: patronymic,
      languageCode: languageCode,
      description: description,
      avatarId: avatarId,
      isDeleted: isDeleted,
      isBanned: isBanned,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['userId'] as String,
      username: json['username'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      patronymic: json['patronymic'] as String?,
      languageCode: normalizeLanguageCode(json['languageCode'] as String?),
      description: json['description'] as String?,
      avatarId: json['avatarId'] as String?,
      isDeleted: json['isDeleted'] as bool,
      isBanned: json['isBanned'] as bool,
      createdAt: DateTimeFormatter.parse(json['createdAt']),
      updatedAt: DateTimeFormatter.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'userId': userId,
    'username': username,
    'firstName': firstName,
    'lastName': lastName,
    'patronymic': patronymic,
    'languageCode': languageCode,
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
    String? lastName,
    String? patronymic,
    String? languageCode,
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
      lastName: lastName ?? this.lastName,
      patronymic: patronymic ?? this.patronymic,
      languageCode: languageCode ?? this.languageCode,
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
    lastName,
    patronymic,
    languageCode,
    description,
    avatarId,
    isDeleted,
    isBanned,
    createdAt,
    updatedAt,
  ];
}
