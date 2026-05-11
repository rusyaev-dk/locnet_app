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
    on<GroupConversationMessageUpdateReceivedEvent>(_onMessageUpdateReceived);

    _messagesUpdatesSubscription = _groupConversationInteractor.messagesUpdates
        .listen(_onMessagesUpdatesStreamEvent);
  }

  final GroupConversationInteractor _groupConversationInteractor;
  final ILogger _logger;

  StreamSubscription<GroupConversationMessageUpdateRec>?
      _messagesUpdatesSubscription;

  void _onMessagesUpdatesStreamEvent(
    GroupConversationMessageUpdateRec update,
  ) {
    add(GroupConversationMessageUpdateReceivedEvent(update: update));
  }

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

  Future<void> _onMessageUpdateReceived(
    GroupConversationMessageUpdateReceivedEvent event,
    Emitter<GroupConversationState> emit,
  ) async {
    try {
      final GroupConversationState currentState = state;
      if (currentState is! GroupConversationLoadedState) {
        return;
      }

      final GroupConversationLoadedState loadedState = currentState;
      final GroupMessage incomingMessage = event.update.message;

      if (incomingMessage.groupId != loadedState.conversation.groupId) {
        return;
      }

      final List<GroupMessage> updatedMessages =
          List<GroupMessage>.from(loadedState.messages);

      switch (event.update.updateType) {
        case GroupConversationMessageUpdateType.created:
          _upsertIncomingMessage(
            messages: updatedMessages,
            incomingMessage: incomingMessage,
          );
        case GroupConversationMessageUpdateType.updated:
          _upsertIncomingMessage(
            messages: updatedMessages,
            incomingMessage: incomingMessage,
          );
        case GroupConversationMessageUpdateType.deleted:
          _removeIncomingMessage(
            messages: updatedMessages,
            incomingMessage: incomingMessage,
          );
      }

      _sortMessagesByTime(updatedMessages);
      emit(loadedState.copyWith(messages: updatedMessages));
    } catch (e, st) {
      _logger.exception(e, st);
      emit(
        GroupConversationFailureState(
          failure: e is AppException
              ? e
              : AppUnknownException(
                  message: e.toString(),
                  error: e,
                  stackTrace: st,
                ),
        ),
      );
    }
  }

  void _upsertIncomingMessage({
    required List<GroupMessage> messages,
    required GroupMessage incomingMessage,
  }) {
    final int serverIdIndex = messages.indexWhere(
      (GroupMessage message) => message.id == incomingMessage.id,
    );
    if (serverIdIndex != -1) {
      final GroupMessage existing = messages[serverIdIndex];
      messages[serverIdIndex] = incomingMessage.copyWith(
        attachments: incomingMessage.attachments.isNotEmpty
            ? incomingMessage.attachments
            : existing.attachments,
      );
      return;
    }
    final int clientIdIndex = messages.indexWhere(
      (GroupMessage message) =>
          message.clientMessageId != null &&
          message.clientMessageId == incomingMessage.clientMessageId,
    );
    if (clientIdIndex != -1) {
      final GroupMessage existing = messages[clientIdIndex];
      messages[clientIdIndex] = incomingMessage.copyWith(
        attachments: incomingMessage.attachments.isNotEmpty
            ? incomingMessage.attachments
            : existing.attachments,
      );
      return;
    }
    messages.add(incomingMessage);
  }

  void _removeIncomingMessage({
    required List<GroupMessage> messages,
    required GroupMessage incomingMessage,
  }) {
    messages.removeWhere(
      (GroupMessage message) =>
          message.id == incomingMessage.id ||
          message.clientMessageId == incomingMessage.clientMessageId,
    );
  }

  void _sortMessagesByTime(List<GroupMessage> messages) {
    messages.sort((GroupMessage first, GroupMessage second) {
      final int createdCompare = second.createdAt.compareTo(first.createdAt);
      if (createdCompare != 0) return createdCompare;
      return second.updatedAt.compareTo(first.updatedAt);
    });
  }

  @override
  Future<void> close() async {
    await _messagesUpdatesSubscription?.cancel();
    return super.close();
  }
}
