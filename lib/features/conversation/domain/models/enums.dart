// ignore_for_file: sort_constructors_first

enum ConversationType {
  private('private'),
  group('group'),
  channel('channel');

  const ConversationType(this.value);
  final String value;

  @override
  String toString() => value;

  factory ConversationType.fromString(String value) =>
      ConversationType.values.firstWhere(
        (e) => e.value == value,
        orElse: () => throw ArgumentError('Unknown ConversationType: $value'),
      );
}
