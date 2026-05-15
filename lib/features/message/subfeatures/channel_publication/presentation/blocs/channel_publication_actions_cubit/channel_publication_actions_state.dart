// ignore_for_file: sort_constructors_first

part of 'channel_publication_actions_cubit.dart';

enum ChannelPublicationActionType {
  send('send'),
  edit('edit'),
  delete('delete'),
  pin('pin');

  const ChannelPublicationActionType(this.value);

  final String value;

  @override
  String toString() => value;

  factory ChannelPublicationActionType.fromString(String value) =>
      ChannelPublicationActionType.values.firstWhere(
        (ChannelPublicationActionType type) => type.value == value,
        orElse: () =>
            throw ArgumentError('Unknown ChannelPublicationActionType: $value'),
      );
}

enum ChannelPublicationActionStatus {
  sending('sending'),
  editing('editing'),
  deleting('deleting'),
  togglingPin('toggling_pin'),
  success('success'),
  failure('failure');

  const ChannelPublicationActionStatus(this.value);

  final String value;

  @override
  String toString() => value;

  factory ChannelPublicationActionStatus.fromString(String value) =>
      ChannelPublicationActionStatus.values.firstWhere(
        (ChannelPublicationActionStatus status) => status.value == value,
        orElse: () => throw ArgumentError(
          'Unknown ChannelPublicationActionStatus: $value',
        ),
      );
}

final class ChannelPublicationActionOperation extends Equatable {
  const ChannelPublicationActionOperation({
    required this.clientPublicationId,
    required this.channelId,
    required this.type,
    required this.status,
    this.publication,
    this.publicationId,
    this.failure,
  });

  final String clientPublicationId;
  final String channelId;
  final ChannelPublicationActionType type;
  final ChannelPublicationActionStatus status;

  final ChannelPublication? publication;
  final String? publicationId;
  final Object? failure;

  ChannelPublicationActionOperation copyWith({
    String? clientPublicationId,
    String? channelId,
    ChannelPublicationActionType? type,
    ChannelPublicationActionStatus? status,
    ChannelPublication? publication,
    String? publicationId,
    Object? failure,
  }) {
    return ChannelPublicationActionOperation(
      clientPublicationId:
          clientPublicationId ?? this.clientPublicationId,
      channelId: channelId ?? this.channelId,
      type: type ?? this.type,
      status: status ?? this.status,
      publication: publication ?? this.publication,
      publicationId: publicationId ?? this.publicationId,
      failure: failure,
    );
  }

  @override
  List<Object?> get props => <Object?>[
    clientPublicationId,
    channelId,
    type,
    status,
    publication,
    publicationId,
    failure,
  ];
}

final class ChannelPublicationActionsState extends Equatable {
  const ChannelPublicationActionsState({required this.operations});

  const ChannelPublicationActionsState.initial()
    : operations = const <String, ChannelPublicationActionOperation>{};

  final Map<String, ChannelPublicationActionOperation> operations;

  ChannelPublicationActionsState copyWith({
    Map<String, ChannelPublicationActionOperation>? operations,
  }) {
    return ChannelPublicationActionsState(
      operations: operations ?? this.operations,
    );
  }

  @override
  List<Object?> get props => <Object?>[operations];
}
