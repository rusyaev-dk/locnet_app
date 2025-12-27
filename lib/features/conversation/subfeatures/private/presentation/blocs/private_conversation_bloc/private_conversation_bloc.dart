import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/conversation/domain/domain.dart';
import 'package:locnet_app/features/conversation/subfeatures/private/private.dart';
import 'package:locnet_app/features/message/domain/domain.dart';

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

    _messagesUpdatesSubscription = _privateConversationInteractor
        .messagesUpdates
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

      final List<Message> messages = await _privateConversationInteractor
          .loadMessagesPage(conversationId: event.conversationId);

      final Conversation conversation = await _privateConversationInteractor
          .getConversationById(conversationId: event.conversationId);

      final User companion = await _privateConversationInteractor.getCompanion(
        conversationId: event.conversationId,
      );

      emit(
        PrivateConversationLoadedState(
          messages: messages,
          conversation: conversation,
          companionId: companion.userId,
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

      final Message incomingMessage = event.update.message;

      if (incomingMessage.conversationId !=
          loadedState.conversation.conversationId) {
        return;
      }

      final List<Message> updatedMessages = List<Message>.from(
        loadedState.messages,
      );

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
    required List<Message> messages,
    required Message incomingMessage,
  }) {
    final int serverIdIndex = messages.indexWhere(
      (Message message) => message.messageId == incomingMessage.messageId,
    );

    if (serverIdIndex != -1) {
      messages[serverIdIndex] = incomingMessage;
      return;
    }

    final int clientIdIndex = messages.indexWhere(
      (Message message) =>
          message.clientMessageId == incomingMessage.clientMessageId,
    );

    if (clientIdIndex != -1) {
      messages[clientIdIndex] = incomingMessage;
      return;
    }

    messages.add(incomingMessage);
  }

  void _removeIncomingMessage({
    required List<Message> messages,
    required Message incomingMessage,
  }) {
    messages.removeWhere(
      (Message message) =>
          message.messageId == incomingMessage.messageId ||
          message.clientMessageId == incomingMessage.clientMessageId,
    );
  }

  void _sortMessagesByTime(List<Message> messages) {
    messages.sort((Message first, Message second) {
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
