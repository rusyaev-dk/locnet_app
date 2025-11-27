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
  }

  final PrivateConversationInteractor _privateConversationInteractor;
  final ILogger _logger;

  StreamSubscription<PrivateConversationMessageUpdateRec>?
  _messagesUpdatesSubscription;

  Future<void> _onStarted(
    PrivateConversationStartedEvent event,
    Emitter<PrivateConversationState> emit,
  ) async {
    try {
      await _messagesUpdatesSubscription?.cancel();

      emit(const PrivateConversationLoadingState());

      final List<Message> messages = await _privateConversationInteractor
          .loadMessagesPage(conversationId: event.conversationId);

      final conversation = await _privateConversationInteractor
          .getConversationById(conversationId: event.conversationId);

      final companion = await _privateConversationInteractor.getCompanion(
        conversationId: event.conversationId,
      );

      emit(
        PrivateConversationLoadedState(
          messages: messages,
          conversation: conversation,
          companionId: companion.userId,
        ),
      );

      _messagesUpdatesSubscription = _privateConversationInteractor
          .messagesUpdates
          .listen((PrivateConversationMessageUpdateRec update) {
            add(PrivateConversationMessageUpdateReceivedEvent(update: update));
          });
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

      final Message updatedMessage = event.update.message;

      if (updatedMessage.conversationId != loadedState.conversation.id) {
        return;
      }

      final List<Message> updatedMessages = List<Message>.from(
        loadedState.messages,
      );

      switch (event.update.kind) {
        case PrivateConversationMessageUpdateType.created:
          updatedMessages.removeWhere(
            (Message message) => message.id == updatedMessage.id,
          );
          updatedMessages.add(updatedMessage);
        case PrivateConversationMessageUpdateType.updated:
          final int index = updatedMessages.indexWhere(
            (Message message) => message.id == updatedMessage.id,
          );
          if (index != -1) {
            updatedMessages[index] = updatedMessage;
          }
        case PrivateConversationMessageUpdateType.deleted:
          updatedMessages.removeWhere(
            (Message message) => message.id == updatedMessage.id,
          );
      }

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

  @override
  Future<void> close() async {
    await _messagesUpdatesSubscription?.cancel();
    return super.close();
  }
}
