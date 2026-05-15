// ignore_for_file: sort_constructors_first

part of 'private_message_actions_cubit.dart';

enum PrivateMessageActionType {
  send('send'),
  edit('edit'),
  delete('delete'),
  pin('pin');

  const PrivateMessageActionType(this.value);

  final String value;

  @override
  String toString() => value;

  factory PrivateMessageActionType.fromString(String value) =>
      PrivateMessageActionType.values.firstWhere(
        (PrivateMessageActionType type) => type.value == value,
        orElse: () =>
            throw ArgumentError('Unknown PrivateMessageActionType: $value'),
      );
}

enum PrivateMessageActionStatus {
  sending('sending'),
  editing('editing'),
  deleting('deleting'),
  togglingPin('toggling_pin'),
  success('success'),
  failure('failure');

  const PrivateMessageActionStatus(this.value);

  final String value;

  @override
  String toString() => value;

  factory PrivateMessageActionStatus.fromString(String value) =>
      PrivateMessageActionStatus.values.firstWhere(
        (PrivateMessageActionStatus status) => status.value == value,
        orElse: () =>
            throw ArgumentError('Unknown PrivateMessageActionStatus: $value'),
      );
}

final class PrivateMessageActionOperation extends Equatable {
  const PrivateMessageActionOperation({
    required this.clientMessageId,
    required this.conversationId,
    required this.type,
    required this.status,
    this.message,
    this.messageId,
    this.failure,
  });

  final String clientMessageId;
  final String conversationId;
  final PrivateMessageActionType type;
  final PrivateMessageActionStatus status;

  /// For send: pending message that was created locally.
  /// For edit/delete: optional.
  final PrivateMessage? message;

  /// For edit/delete: server message id.
  final String? messageId;

  final Object? failure;

  PrivateMessageActionOperation copyWith({
    String? clientMessageId,
    String? conversationId,
    PrivateMessageActionType? type,
    PrivateMessageActionStatus? status,
    PrivateMessage? message,
    String? messageId,
    Object? failure,
  }) {
    return PrivateMessageActionOperation(
      clientMessageId: clientMessageId ?? this.clientMessageId,
      conversationId: conversationId ?? this.conversationId,
      type: type ?? this.type,
      status: status ?? this.status,
      message: message ?? this.message,
      messageId: messageId ?? this.messageId,
      failure: failure,
    );
  }

  @override
  List<Object?> get props => <Object?>[
    clientMessageId,
    conversationId,
    type,
    status,
    message,
    messageId,
    failure,
  ];
}

final class PrivateMessageActionsState extends Equatable {
  const PrivateMessageActionsState({required this.operations});

  const PrivateMessageActionsState.initial()
    : operations = const <String, PrivateMessageActionOperation>{};

  final Map<String, PrivateMessageActionOperation> operations;

  PrivateMessageActionsState copyWith({
    Map<String, PrivateMessageActionOperation>? operations,
  }) {
    return PrivateMessageActionsState(
      operations: operations ?? this.operations,
    );
  }

  @override
  List<Object?> get props => <Object?>[operations];
}
