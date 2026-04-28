import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/conversation/subfeatures/private/private.dart';
import 'package:locnet_app/features/message/domain/domain.dart';
import 'package:locnet_app/features/message/subfeatures/private_message/domain/domain.dart';
import 'package:uuid/uuid.dart';

part 'private_conversation_event.dart';
part 'private_conversation_state.dart';

class PrivateConversationBloc
    extends Bloc<PrivateConversationEvent, PrivateConversationState> {
  PrivateConversationBloc({
    required PrivateConversationInteractor privateConversationInteractor,
    required PrivateMessageInteractor privateMessageInteractor,
    required UserInteractor userInteractor,
    required ILogger logger,
  }) : _privateConversationInteractor = privateConversationInteractor,
       _privateMessageInteractor = privateMessageInteractor,
       _userInteractor = userInteractor,
       _logger = logger,
       super(const PrivateConversationLoadingState()) {
    on<PrivateConversationStartedEvent>(_onStarted);
    on<PrivateConversationDraftStartedEvent>(_onDraftStarted);
    on<PrivateConversationSendMessageEvent>(_onSendMessage);
    on<PrivateConversationMessageUpdateReceivedEvent>(_onMessageUpdateReceived);

    _messagesUpdatesSubscription = _privateConversationInteractor
        .messagesUpdates
        .listen(_onMessagesUpdatesStreamEvent);
  }

  final PrivateConversationInteractor _privateConversationInteractor;
  final PrivateMessageInteractor _privateMessageInteractor;
  final UserInteractor _userInteractor;
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

      final User cachedUser = await _userInteractor.getCachedUser();
      final User companion =
          event.initialCompanion ??
          await _privateConversationInteractor.getCompanion(
            conversationId: event.conversationId,
          );
      final DateTime now = DateTime.now();
      final PrivateConversation conversation = PrivateConversation(
        conversationId: event.conversationId,
        user1Id: cachedUser.userId,
        user2Id: companion.userId,
        createdAt: now,
        updatedAt: now,
        isDeleted: false,
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

  Future<void> _onDraftStarted(
    PrivateConversationDraftStartedEvent event,
    Emitter<PrivateConversationState> emit,
  ) async {
    try {
      emit(const PrivateConversationLoadingState());
      final User companion = await _userInteractor.getUserById(
        userId: event.companionId,
      );

      final User currentUser = await _userInteractor.getCachedUser();
      final List<PrivateConversation> conversations =
          await _privateConversationInteractor.listConversations();
      final PrivateConversation? existingConversation = conversations
          .where(
            (PrivateConversation conversation) =>
                !conversation.isDeleted &&
                ((conversation.user1Id == currentUser.userId &&
                        conversation.user2Id == companion.userId) ||
                    (conversation.user2Id == currentUser.userId &&
                        conversation.user1Id == companion.userId)),
          )
          .firstOrNull;

      if (existingConversation != null) {
        final List<PrivateMessage> messages =
            await _privateConversationInteractor.loadMessagesPage(
              conversationId: existingConversation.conversationId,
            );

        emit(
          PrivateConversationLoadedState(
            messages: messages,
            conversation: existingConversation,
            companionId: companion.userId,
            companion: companion,
            pendingNavigationConversationId: existingConversation.conversationId,
          ),
        );
        return;
      }

      emit(PrivateConversationDraftState(companion: companion));
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

  Future<void> _onSendMessage(
    PrivateConversationSendMessageEvent event,
    Emitter<PrivateConversationState> emit,
  ) async {
    final String normalizedText = event.text.trim();
    final String? replyToMessageId = _normalizeReplyToMessageId(
      event.replyToMessageId,
    );
    if (normalizedText.isEmpty) {
      return;
    }

    try {
      final PrivateConversationState currentState = state;
      if (currentState is PrivateConversationDraftState) {
        if (currentState.isCreatingConversation) {
          return;
        }

        emit(currentState.copyWith(isCreatingConversation: true));

        final User currentUser = await _userInteractor.getCachedUser();
        final String clientMessageId = const Uuid().v4();
        final DateTime now = DateTime.now();
        final PrivateConversation conversation =
            await _privateConversationInteractor.getOrCreateByCompanion(
              companionId: currentState.companion.userId,
            );

        final PrivateMessage pendingMessage = PrivateMessage(
          id: '',
          conversationId: conversation.conversationId,
          senderId: currentUser.userId,
          text: normalizedText,
          attachments: const <PrivateMessageAttachment>[],
          createdAt: now,
          updatedAt: now,
          isDeleted: false,
          deletedById: null,
          replyToMessageId: replyToMessageId,
          deliveryStatus: MessageDeliveryStatus.sending,
          clientMessageId: clientMessageId,
          isPinned: false,
          editedAt: null,
        );

        emit(
          PrivateConversationLoadedState(
            messages: <PrivateMessage>[pendingMessage],
            conversation: conversation,
            companion: currentState.companion,
            companionId: currentState.companion.userId,
            pendingNavigationConversationId: conversation.conversationId,
          ),
        );

        await _privateMessageInteractor.sendMessage(message: pendingMessage);
        return;
      }

      if (currentState is! PrivateConversationLoadedState) {
        return;
      }

      final User currentUser = await _userInteractor.getCachedUser();
      final String clientMessageId = const Uuid().v4();
      final DateTime now = DateTime.now();
      final PrivateMessage pendingMessage = PrivateMessage(
        id: '',
        conversationId: currentState.conversation.conversationId,
        senderId: currentUser.userId,
        text: normalizedText,
        attachments: const <PrivateMessageAttachment>[],
        createdAt: now,
        updatedAt: now,
        isDeleted: false,
        deletedById: null,
        replyToMessageId: replyToMessageId,
        deliveryStatus: MessageDeliveryStatus.sending,
        clientMessageId: clientMessageId,
        isPinned: false,
        editedAt: null,
      );

      final List<PrivateMessage> updatedMessages = List<PrivateMessage>.from(
        currentState.messages,
      )..insert(0, pendingMessage);
      _sortMessagesByTime(updatedMessages);

      emit(currentState.copyWith(messages: updatedMessages));
      await _privateMessageInteractor.sendMessage(message: pendingMessage);
    } catch (e, st) {
      _logger.exception(e, st);

      final AppException appException = e is AppException
          ? e
          : AppUnknownException(
              message: e.toString(),
              error: e,
              stackTrace: st,
            );

      final PrivateConversationState currentState = state;
      if (currentState is PrivateConversationLoadedState) {
        final List<PrivateMessage> failedMessages = currentState.messages
            .map((PrivateMessage message) {
              if (message.deliveryStatus == MessageDeliveryStatus.sending) {
                return message.copyWith(
                  deliveryStatus: MessageDeliveryStatus.failed,
                  updatedAt: DateTime.now(),
                );
              }
              return message;
            })
            .toList(growable: false);
        emit(
          currentState.copyWith(
            messages: failedMessages,
            failure: appException,
          ),
        );
        return;
      }

      if (currentState is PrivateConversationDraftState) {
        emit(
          currentState.copyWith(
            isCreatingConversation: false,
            failure: appException,
          ),
        );
        return;
      }

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

      if (incomingMessage.conversationId !=
          loadedState.conversation.conversationId) {
        return;
      }

      final List<PrivateMessage> updatedMessages = List<PrivateMessage>.from(
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

  String? _normalizeReplyToMessageId(String? value) {
    if (value == null) {
      return null;
    }
    final String normalized = value.trim();
    if (normalized.isEmpty) {
      return null;
    }
    return normalized;
  }

  @override
  Future<void> close() async {
    await _messagesUpdatesSubscription?.cancel();
    return super.close();
  }
}
