import 'package:equatable/equatable.dart';
import 'package:locnet_app/core/data/data.dart';

class User extends Equatable {
  const User({
    required this.id,
    required this.username,
    required this.firstName,
    required this.isDeleted,
    required this.isBanned,
    required this.createdAt,
    required this.updatedAt,
    this.lastName,
    this.description,
    this.avatarId,
  });

  final String id;
  final String username;
  final String firstName;
  final String? lastName;
  final String? description;
  final String? avatarId;
  final bool isDeleted;
  final bool isBanned;
  final DateTime createdAt;
  final DateTime updatedAt;

  String get fullName =>
      [firstName, if ((lastName ?? '').isNotEmpty) lastName!].join(' ');

  bool get isActive => !isDeleted && !isBanned;

  // ignore: sort_constructors_first
  factory User.fromDTO(UserDTO dto) {
    return User(
      id: dto.userId,
      username: dto.username,
      firstName: dto.firstName,
      lastName: dto.lastName,
      description: dto.description,
      avatarId: dto.avatarId,
      isDeleted: dto.isDeleted,
      isBanned: dto.isBanned,
      createdAt: dto.createdAt,
      updatedAt: dto.updatedAt,
    );
  }

  UserDTO toDTO({String password = ''}) {
    return UserDTO(
      userId: id,
      username: username,
      password: password, // если нужно, передаешь хэш/пустую строку
      firstName: firstName,
      lastName: lastName,
      description: description,
      avatarId: avatarId,
      isDeleted: isDeleted,
      isBanned: isBanned,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  User copyWith({
    String? id,
    String? username,
    String? firstName,
    String? lastName,
    String? description,
    String? avatarId,
    bool? isDeleted,
    bool? isBanned,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
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
    id,
    username,
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
