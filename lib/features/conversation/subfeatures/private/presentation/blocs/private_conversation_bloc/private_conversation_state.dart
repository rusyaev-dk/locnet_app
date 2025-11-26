part of 'private_conversation_bloc.dart';

sealed class PrivateConversationState extends Equatable {
  const PrivateConversationState();
  
  @override
  List<Object> get props => [];
}

final class PrivateConversationInitial extends PrivateConversationState {}
