import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'private_conversation_event.dart';
part 'private_conversation_state.dart';

class PrivateConversationBloc extends Bloc<PrivateConversationEvent, PrivateConversationState> {
  PrivateConversationBloc() : super(PrivateConversationInitial()) {
    on<PrivateConversationEvent>((event, emit) {
      // TODO: implement event handler
    });
  }

  

}
