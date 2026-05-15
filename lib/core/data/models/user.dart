// ignore_for_file: sort_constructors_first

import 'package:equatable/equatable.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/core/presentation/utils/utils.dart';
import 'package:locnet_app/core/utils/language_code_normalizer.dart';

class UserDto extends Equatable {
  const UserDto({
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

  factory UserDto.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> source = switch (json['user']) {
      final Map<String, dynamic> nested => nested,
      _ => json,
    };

    DateTime parseDate(dynamic value) => value is DateTime
        ? value.toUtc()
        : value is int
        ? DateTimeFormatter.parse(value)
        : DateTimeFormatter.parse(value as String);

    return UserDto(
      userId: (source['id'] ?? source['userId']) as String,
      username: source['username'] as String,
      firstName: source['firstName'] as String,
      lastName: source['lastName'] as String,
      patronymic: source['patronymic'] as String?,
      languageCode: normalizeLanguageCode(
        source['languageCode'] as String?,
        fallback: AppConfig.defaultLanguageCode,
      ),
      description: source['description'] as String?,
      avatarId: source['avatarId'] as String?,
      isDeleted: source['isDeleted'] as bool,
      isBanned: source['isBanned'] as bool,
      createdAt: parseDate(source['createdAt']),
      updatedAt: parseDate(source['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': userId,
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
