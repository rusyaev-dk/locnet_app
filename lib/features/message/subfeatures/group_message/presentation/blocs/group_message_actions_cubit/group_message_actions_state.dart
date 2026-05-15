// ignore_for_file: sort_constructors_first

part of 'group_message_actions_cubit.dart';

enum GroupMessageActionType {
  send('send'),
  edit('edit'),
  delete('delete'),
  pin('pin');

  const GroupMessageActionType(this.value);

  final String value;

  @override
  String toString() => value;

  factory GroupMessageActionType.fromString(String value) =>
      GroupMessageActionType.values.firstWhere(
        (GroupMessageActionType type) => type.value == value,
        orElse: () =>
            throw ArgumentError('Unknown GroupMessageActionType: $value'),
      );
}

enum GroupMessageActionStatus {
  sending('sending'),
  editing('editing'),
  deleting('deleting'),
  togglingPin('toggling_pin'),
  success('success'),
  failure('failure');

  const GroupMessageActionStatus(this.value);

  final String value;

  @override
  String toString() => value;

  factory GroupMessageActionStatus.fromString(String value) =>
      GroupMessageActionStatus.values.firstWhere(
        (GroupMessageActionStatus status) => status.value == value,
        orElse: () =>
            throw ArgumentError('Unknown GroupMessageActionStatus: $value'),
      );
}

final class GroupMessageActionOperation extends Equatable {
  const GroupMessageActionOperation({
    required this.clientMessageId,
    required this.groupId,
    required this.type,
    required this.status,
    this.message,
    this.messageId,
    this.failure,
  });

  final String clientMessageId;
  final String groupId;
  final GroupMessageActionType type;
  final GroupMessageActionStatus status;

  final GroupMessage? message;
  final String? messageId;
  final Object? failure;

  GroupMessageActionOperation copyWith({
    String? clientMessageId,
    String? groupId,
    GroupMessageActionType? type,
    GroupMessageActionStatus? status,
    GroupMessage? message,
    String? messageId,
    Object? failure,
  }) {
    return GroupMessageActionOperation(
      clientMessageId: clientMessageId ?? this.clientMessageId,
      groupId: groupId ?? this.groupId,
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
    groupId,
    type,
    status,
    message,
    messageId,
    failure,
  ];
}

final class GroupMessageActionsState extends Equatable {
  const GroupMessageActionsState({required this.operations});

  const GroupMessageActionsState.initial()
    : operations = const <String, GroupMessageActionOperation>{};

  final Map<String, GroupMessageActionOperation> operations;

  GroupMessageActionsState copyWith({
    Map<String, GroupMessageActionOperation>? operations,
  }) {
    return GroupMessageActionsState(
      operations: operations ?? this.operations,
    );
  }

  @override
  List<Object?> get props => <Object?>[operations];
}
