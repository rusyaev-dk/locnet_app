part of 'conversation_creator_bloc.dart';

abstract class ConversationCreatorEvent extends Equatable {
  const ConversationCreatorEvent();

  @override
  List<Object?> get props => <Object?>[];
}

final class UpdateConversationTypeEvent extends ConversationCreatorEvent {
  const UpdateConversationTypeEvent({required this.conversationType});

  final ConversationType conversationType;

  @override
  List<Object?> get props => <Object?>[conversationType];
}

final class UpdateConversationTitleEvent extends ConversationCreatorEvent {
  const UpdateConversationTitleEvent({required this.title});

  final String? title;

  @override
  List<Object?> get props => <Object?>[title];
}

final class UpdateConversationDescriptionEvent
    extends ConversationCreatorEvent {
  const UpdateConversationDescriptionEvent({required this.description});

  final String? description;

  @override
  List<Object?> get props => <Object?>[description];
}

final class SubmitConversationEvent extends ConversationCreatorEvent {
  const SubmitConversationEvent();

  @override
  List<Object?> get props => <Object?>[];
}
