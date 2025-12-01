part of 'conversation_creator_bloc.dart';

final class ConversationCreatorState extends Equatable {
  const ConversationCreatorState({
    required this.selectedConversationType,
    this.failure,
    this.title,
    this.titleException,
    this.description,
    this.descriptionException,
    this.isPending = false,
    this.success = false,
    this.participantIds = const <String>[],
  });

  static const Object _noChange = Object();

  final Object? failure;

  final ConversationType selectedConversationType;

  final String? title;
  final Object? titleException;

  final String? description;
  final Object? descriptionException;

  final bool isPending;
  final bool success;

  final List<String> participantIds;

  ConversationCreatorState copyWith({
    Object? failure = _noChange,
    ConversationType? selectedConversationType,
    String? title,
    Object? titleException = _noChange,
    String? description,
    Object? descriptionException = _noChange,
    Object? isPending = _noChange,
    Object? success = _noChange,
    Object? participantIds = _noChange,
  }) {
    return ConversationCreatorState(
      failure: identical(failure, _noChange) ? this.failure : failure,
      selectedConversationType:
          selectedConversationType ?? this.selectedConversationType,
      title: title ?? this.title,
      titleException: identical(titleException, _noChange)
          ? this.titleException
          : titleException,
      description: description ?? this.description,
      descriptionException: identical(descriptionException, _noChange)
          ? this.descriptionException
          : descriptionException,
      isPending: identical(isPending, _noChange)
          ? this.isPending
          : isPending as bool,
      success: identical(success, _noChange)
          ? this.success
          : success as bool,
      participantIds: identical(participantIds, _noChange)
          ? this.participantIds
          : List<String>.unmodifiable(participantIds as List<String>),
    );
  }

  @override
  List<Object?> get props => <Object?>[
        failure,
        selectedConversationType,
        title,
        titleException,
        description,
        descriptionException,
        isPending,
        success,
        participantIds,
      ];
}
