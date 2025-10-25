import 'package:equatable/equatable.dart';

class UserDTO extends Equatable {
  const UserDTO({
    required this.userId,
    required this.username,
    required this.password,
    required this.firstName,
    required this.isDeleted,
    required this.isBanned,
    required this.createdAt,
    required this.updatedAt,
    this.lastName,
    this.description,
    this.avatarId,
  });

  final String userId; // uuid
  final String username; // varchar
  final String password; // text (hash)
  final String firstName; // varchar
  final String? lastName; // varchar?
  final String? description; // varchar?
  final String? avatarId; // uuid?
  final bool isDeleted; // boolean
  final bool isBanned; // boolean
  final DateTime createdAt; // timestamp
  final DateTime updatedAt; // timestamp

  // ignore: sort_constructors_first
  factory UserDTO.fromJson(Map<String, dynamic> json) {
    DateTime parseDate(dynamic v) => v is DateTime
        ? v
        : v is int
        ? DateTime.fromMillisecondsSinceEpoch(v)
        : DateTime.parse(v as String);

    return UserDTO(
      userId: json['userId'] as String,
      username: json['username'] as String,
      password: json['password'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String?,
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
    'password': password,
    'firstName': firstName,
    'lastName': lastName,
    'description': description,
    'avatarId': avatarId,
    'isDeleted': isDeleted,
    'isBanned': isBanned,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };

  UserDTO copyWith({
    String? userId,
    String? username,
    String? password,
    String? firstName,
    String? lastName,
    String? description,
    String? avatarId,
    bool? isDeleted,
    bool? isBanned,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserDTO(
      userId: userId ?? this.userId,
      username: username ?? this.username,
      password: password ?? this.password,
      firstName: firstName ?? this.firstName,
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
    password,
    firstName,
    lastName,
    description,
    avatarId,
    isDeleted,
    isBanned,
    createdAt,
    updatedAt,
  ];
}
