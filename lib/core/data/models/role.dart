// ignore_for_file: sort_constructors_first

enum Role {
  superAdmin('super_admin'),
  admin('admin'),
  user('user');

  const Role(this.value);
  final String value;

  @override
  String toString() => value;

  factory Role.fromString(String value) => Role.values.firstWhere(
    (e) => e.value == value,
    orElse: () => throw ArgumentError('Unknown Role: $value'),
  );
}
