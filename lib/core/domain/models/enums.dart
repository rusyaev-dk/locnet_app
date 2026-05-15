// ignore_for_file: sort_constructors_first

enum BanScope {
  global('global'),
  conversation('conversation');

  const BanScope(this.value);
  final String value;

  @override
  String toString() => value;

  factory BanScope.fromString(String value) => BanScope.values.firstWhere(
    (e) => e.value == value,
    orElse: () => throw ArgumentError('Unknown BanScope: $value'),
  );
}
