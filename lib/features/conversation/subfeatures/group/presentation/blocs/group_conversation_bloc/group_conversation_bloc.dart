import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/conversation/subfeatures/group/group.dart';

part 'group_conversation_event.dart';
part 'group_conversation_state.dart';

class GroupConversationBloc
    extends Bloc<GroupConversationEvent, GroupConversationState> {
  GroupConversationBloc({
    required GroupConversationInteractor groupConversationInteractor,
    required ILogger logger,
  }) : _groupConversationInteractor = groupConversationInteractor,
       _logger = logger,
       super(const GroupConversationLoadingState()) {
    on<GroupConversationStartedEvent>(_onStarted);
  }

  final GroupConversationInteractor _groupConversationInteractor;
  final ILogger _logger;

  Future<void> _onStarted(
    GroupConversationStartedEvent event,
    Emitter<GroupConversationState> emit,
  ) async {
    try {
      emit(const GroupConversationLoadingState());

      final List<GroupMessage> messages = await _groupConversationInteractor
          .loadMessagesPage(groupId: event.conversationId);

      final Group conversation = await _groupConversationInteractor.getGroup(
        groupId: event.conversationId,
      );

      final List<User> participants = await _groupConversationInteractor
          .loadGroupParticipants(groupId: event.conversationId);

      emit(
        GroupConversationLoadedState(
          messages: messages,
          conversation: conversation,
          participants: participants,
        ),
      );
    } catch (e, st) {
      _logger.exception(e, st);

      final AppException appException = e is AppException
          ? e
          : AppUnknownException(
              message: e.toString(),
              error: e,
              stackTrace: st,
            );

      emit(GroupConversationFailureState(failure: appException));
    }
  }
}
