import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/conversation/subfeatures/private/private.dart';

part 'private_conversation_event.dart';
part 'private_conversation_state.dart';

class PrivateConversationBloc
    extends Bloc<PrivateConversationEvent, PrivateConversationState> {
  PrivateConversationBloc({
    required PrivateConversationInteractor privateConversationInteractor,
    required ILogger logger,
  }) : _privateConversationInteractor = privateConversationInteractor,
       _logger = logger,
       super(const PrivateConversationLoadingState()) {
    on<PrivateConversationStartedEvent>(_onStarted);
    on<PrivateConversationMessageUpdateReceivedEvent>(_onMessageUpdateReceived);

    _messagesUpdatesSubscription = _privateConversationInteractor.messagesUpdates
        .listen(_onMessagesUpdatesStreamEvent);
  }

  final PrivateConversationInteractor _privateConversationInteractor;
  final ILogger _logger;

  StreamSubscription<PrivateConversationMessageUpdateRec>?
  _messagesUpdatesSubscription;

  void _onMessagesUpdatesStreamEvent(
    PrivateConversationMessageUpdateRec update,
  ) {
    add(PrivateConversationMessageUpdateReceivedEvent(update: update));
  }

  Future<void> _onStarted(
    PrivateConversationStartedEvent event,
    Emitter<PrivateConversationState> emit,
  ) async {
    try {
      emit(const PrivateConversationLoadingState());

      final List<PrivateMessage> messages = await _privateConversationInteractor
          .loadMessagesPage(conversationId: event.conversationId);

      final PrivateConversation conversation =
          await _privateConversationInteractor.getConversationById(
        conversationId: event.conversationId,
      );

      final User companion = await _privateConversationInteractor.getCompanion(
        conversationId: event.conversationId,
      );

      emit(
        PrivateConversationLoadedState(
          messages: messages,
          conversation: conversation,
          companionId: companion.userId,
          companion: companion,
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

      emit(PrivateConversationFailureState(failure: appException));
    }
  }

  Future<void> _onMessageUpdateReceived(
    PrivateConversationMessageUpdateReceivedEvent event,
    Emitter<PrivateConversationState> emit,
  ) async {
    try {
      final PrivateConversationState currentState = state;
      if (currentState is! PrivateConversationLoadedState) {
        return;
      }

      final PrivateConversationLoadedState loadedState = currentState;

      final PrivateMessage incomingMessage = event.update.message;

      if (incomingMessage.conversationId != loadedState.conversation.id) {
        return;
      }

      final List<PrivateMessage> updatedMessages =
          List<PrivateMessage>.from(loadedState.messages);

      switch (event.update.updateType) {
        case PrivateConversationMessageUpdateType.created:
          _upsertIncomingMessage(
            messages: updatedMessages,
            incomingMessage: incomingMessage,
          );
        case PrivateConversationMessageUpdateType.updated:
          _upsertIncomingMessage(
            messages: updatedMessages,
            incomingMessage: incomingMessage,
          );
        case PrivateConversationMessageUpdateType.deleted:
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
        PrivateConversationFailureState(
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
    required List<PrivateMessage> messages,
    required PrivateMessage incomingMessage,
  }) {
    final int serverIdIndex = messages.indexWhere(
      (PrivateMessage message) => message.id == incomingMessage.id,
    );

    if (serverIdIndex != -1) {
      messages[serverIdIndex] = incomingMessage;
      return;
    }

    final int clientIdIndex = messages.indexWhere(
      (PrivateMessage message) =>
          message.clientMessageId == incomingMessage.clientMessageId,
    );

    if (clientIdIndex != -1) {
      messages[clientIdIndex] = incomingMessage;
      return;
    }

    messages.add(incomingMessage);
  }

  void _removeIncomingMessage({
    required List<PrivateMessage> messages,
    required PrivateMessage incomingMessage,
  }) {
    messages.removeWhere(
      (PrivateMessage message) =>
          message.id == incomingMessage.id ||
          message.clientMessageId == incomingMessage.clientMessageId,
    );
  }

  void _sortMessagesByTime(List<PrivateMessage> messages) {
    messages.sort((PrivateMessage first, PrivateMessage second) {
      final int createdCompare = second.createdAt.compareTo(first.createdAt);
      if (createdCompare != 0) {
        return createdCompare;
      }
      return second.updatedAt.compareTo(first.updatedAt);
    });
  }

  @override
  Future<void> close() async {
    await _messagesUpdatesSubscription?.cancel();
    return super.close();
  }
}
