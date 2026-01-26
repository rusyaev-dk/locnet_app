import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/conversation/data/data.dart';
import 'package:locnet_app/features/conversation/domain/domain.dart';
import 'package:locnet_app/features/conversation/subfeatures/group/group.dart';
import 'package:locnet_app/features/message/domain/domain.dart';

part 'group_conversation_event.dart';
part 'group_conversation_state.dart';

class GroupConversationBloc
    extends Bloc<GroupConversationEvent, GroupConversationState> {
  GroupConversationBloc({
    required GroupConversationInteractor groupConversationInteractor,
    required IConversationRepo conversationRepo,
    required ILogger logger,
  }) : _groupConversationInteractor = groupConversationInteractor,
       _conversationRepo = conversationRepo,
       _logger = logger,
       super(const GroupConversationLoadingState()) {
    on<GroupConversationStartedEvent>(_onStarted);
  }

  final GroupConversationInteractor _groupConversationInteractor;
  final IConversationRepo _conversationRepo;
  final ILogger _logger;

  Future<void> _onStarted(
    GroupConversationStartedEvent event,
    Emitter<GroupConversationState> emit,
  ) async {
    try {
      emit(const GroupConversationLoadingState());

      final List<Message> messages = await _groupConversationInteractor
          .loadMessagesPage(conversationId: event.conversationId, page: 1);

      final Conversation conversation = await _conversationRepo
          .getConversationById(conversationId: event.conversationId);

      final List<User> participants =
          await _groupConversationInteractor.loadGroupParticipants(
        groupConversationId: event.conversationId,
      );

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
