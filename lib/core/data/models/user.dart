// ignore_for_file: sort_constructors_first

import 'package:equatable/equatable.dart';

class UserDto extends Equatable {
  const UserDto({
    required this.userId,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.patronymic,
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
  final String patronymic;
  final String languageCode;
  final String? description;
  final String? avatarId;
  final bool isDeleted;
  final bool isBanned;
  final DateTime createdAt;
  final DateTime updatedAt;

  factory UserDto.fromJson(Map<String, dynamic> json) {
    DateTime parseDate(dynamic value) => value is DateTime
        ? value
        : value is int
        ? DateTime.fromMillisecondsSinceEpoch(value)
        : DateTime.parse(value as String);

    return UserDto(
      userId: json['userId'] as String,
      username: json['username'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      patronymic: json['patronymic'] as String,
      languageCode: json['languageCode'] as String,
      description: json['description'] as String?,
      avatarId: json['avatarId'] as String?,
      isDeleted: json['isDeleted'] as bool,
      isBanned: json['isBanned'] as bool,
      createdAt: parseDate(json['createdAt']),
      updatedAt: parseDate(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'userId': userId,
    'username': username,
    'firstName': firstName,
    'lastName': lastName,
    'patronym': patronymic,
    'languageCode': languageCode,
    'description': description,
    'avatarId': avatarId,
    'isDeleted': isDeleted,
    'isBanned': isBanned,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };

  UserDto copyWith({
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
    return UserDto(
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
