// ignore_for_file: sort_constructors_first

import 'package:locnet_app/core/core.dart';

enum SessionMessageType implements IMessageKey {
  loadFail('load_fail'),
  expired('expired'),
  invalid('invalid'),
  unauthorized('unauthorized');

  const SessionMessageType(this.value);
  final String value;

  @override
  String toString() => value;

  factory SessionMessageType.fromString(String value) =>
      SessionMessageType.values.firstWhere(
        (e) => e.value == value,
        orElse: () => throw ArgumentError('Unknown SessionErrorType: $value'),
      );
}
