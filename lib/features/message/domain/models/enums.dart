// ignore_for_file: sort_constructors_first

enum MessageDeliveryStatus {
  sending('sending'),
  sent('sent'),
  failed('failed');

  const MessageDeliveryStatus(this.value);

  final String value;

  @override
  String toString() => value;

  factory MessageDeliveryStatus.fromString(String value) {
    final String normalized = value.toLowerCase();
    return MessageDeliveryStatus.values.firstWhere(
      (MessageDeliveryStatus status) => status.value == normalized,
      orElse: () => MessageDeliveryStatus.sent,
    );
  }
}
