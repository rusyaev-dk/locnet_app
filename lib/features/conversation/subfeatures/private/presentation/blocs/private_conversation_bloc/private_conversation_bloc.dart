import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/conversation/subfeatures/private/private.dart';
import 'package:locnet_app/features/message/domain/domain.dart';
import 'package:locnet_app/features/message/subfeatures/message_input/domain/domain.dart';
import 'package:locnet_app/features/message/subfeatures/private_message/domain/domain.dart';
import 'package:uuid/uuid.dart';

part 'private_conversation_event.dart';
part 'private_conversation_state.dart';

class PrivateConversationBloc
    extends Bloc<PrivateConversationEvent, PrivateConversationState> {
  PrivateConversationBloc({
    required PrivateConversationInteractor privateConversationInteractor,
    required PrivateMessageInteractor privateMessageInteractor,
    required MediaInteractor mediaInteractor,
    required UserInteractor userInteractor,
    required ILogger logger,
  }) : _privateConversationInteractor = privateConversationInteractor,
       _privateMessageInteractor = privateMessageInteractor,
       _mediaInteractor = mediaInteractor,
       _userInteractor = userInteractor,
       _logger = logger,
       super(const PrivateConversationLoadingState()) {
    on<PrivateConversationStartedEvent>(_onStarted);
    on<PrivateConversationDraftStartedEvent>(_onDraftStarted);
    on<PrivateConversationSendMessageEvent>(_onSendMessage);
    on<PrivateConversationMessageUpdateReceivedEvent>(_onMessageUpdateReceived);
    on<PrivateConversationMessageDeletedLocallyEvent>(_onMessageDeletedLocally);
    on<PrivateConversationMarkMessageReadEvent>(_onMarkMessageRead);

    _messagesUpdatesSubscription = _privateConversationInteractor
        .messagesUpdates
        .listen(_onMessagesUpdatesStreamEvent);
  }

  final PrivateConversationInteractor _privateConversationInteractor;
  final PrivateMessageInteractor _privateMessageInteractor;
  final MediaInteractor _mediaInteractor;
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
      final DateTime now = DateTime.now().toUtc();
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
      final User companion;
      if (event.initialCompanion != null &&
          event.initialCompanion!.userId == event.companionId) {
        companion = event.initialCompanion!;
      } else {
        companion = await _userInteractor.getUserById(userId: event.companionId);
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
    final List<UploadableFile> attachedFiles = event.attachedFiles;
    final String? replyToMessageId = _normalizeReplyToMessageId(
      event.replyToMessageId,
    );
    if (normalizedText.isEmpty && attachedFiles.isEmpty) {
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
        final DateTime now = DateTime.now().toUtc();
        final PrivateConversation conversation =
            await _privateConversationInteractor.getOrCreateByCompanion(
              companionId: currentState.companion.userId,
            );
        final List<PrivateMessageAttachment> readyAttachments =
            await _uploadReadyAttachments(
              conversationId: conversation.conversationId,
              attachedFiles: attachedFiles,
            );

        final PrivateMessage pendingMessage = PrivateMessage(
          id: '',
          conversationId: conversation.conversationId,
          senderId: currentUser.userId,
          text: normalizedText,
          attachments: readyAttachments,
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
          ),
        );

        final PrivateMessage sentMessage = await _privateMessageInteractor
            .sendMessage(message: pendingMessage);
        final PrivateConversationState stateAfterSend = state;
        if (stateAfterSend is! PrivateConversationLoadedState) {
          return;
        }

        final List<PrivateMessage> syncedMessages = List<PrivateMessage>.from(
          stateAfterSend.messages,
        );
        _upsertIncomingMessage(
          messages: syncedMessages,
          incomingMessage: sentMessage,
        );
        _sortMessagesByTime(syncedMessages);
        emit(stateAfterSend.copyWith(messages: syncedMessages));
        return;
      }

      if (currentState is! PrivateConversationLoadedState) {
        return;
      }

      final User currentUser = await _userInteractor.getCachedUser();
      final String clientMessageId = const Uuid().v4();
      final DateTime now = DateTime.now().toUtc();
      final List<PrivateMessageAttachment> readyAttachments =
          await _uploadReadyAttachments(
            conversationId: currentState.conversation.conversationId,
            attachedFiles: attachedFiles,
          );
      final PrivateMessage pendingMessage = PrivateMessage(
        id: '',
        conversationId: currentState.conversation.conversationId,
        senderId: currentUser.userId,
        text: normalizedText,
        attachments: readyAttachments,
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

      final PrivateMessage sentMessage = await _privateMessageInteractor
          .sendMessage(message: pendingMessage);
      final PrivateConversationState stateAfterSend = state;
      if (stateAfterSend is! PrivateConversationLoadedState) {
        return;
      }

      final List<PrivateMessage> syncedMessages = List<PrivateMessage>.from(
        stateAfterSend.messages,
      );
      _upsertIncomingMessage(
        messages: syncedMessages,
        incomingMessage: sentMessage,
      );
      _sortMessagesByTime(syncedMessages);
      emit(stateAfterSend.copyWith(messages: syncedMessages));
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
                  updatedAt: DateTime.now().toUtc(),
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

  Future<void> _onMarkMessageRead(
    PrivateConversationMarkMessageReadEvent event,
    Emitter<PrivateConversationState> emit,
  ) async {
    try {
      await _privateMessageInteractor.markMessageAsRead(
        conversationId: event.conversationId,
        messageId: event.messageId,
      );
    } catch (e, st) {
      _logger.exception(e, st);
    }
  }

  void _onMessageDeletedLocally(
    PrivateConversationMessageDeletedLocallyEvent event,
    Emitter<PrivateConversationState> emit,
  ) {
    final PrivateConversationState currentState = state;
    if (currentState is! PrivateConversationLoadedState) {
      return;
    }

    final List<PrivateMessage> updatedMessages = currentState.messages
        .where((PrivateMessage message) => message.id != event.messageId)
        .toList(growable: false);

    if (updatedMessages.length == currentState.messages.length) {
      return;
    }

    emit(currentState.copyWith(messages: updatedMessages));
  }

  void _upsertIncomingMessage({
    required List<PrivateMessage> messages,
    required PrivateMessage incomingMessage,
  }) {
    final int serverIdIndex = messages.indexWhere(
      (PrivateMessage message) => message.id == incomingMessage.id,
    );

    if (serverIdIndex != -1) {
      final PrivateMessage existing = messages[serverIdIndex];
      if (_shouldMergeReadReceiptPatch(
        existing: existing,
        incoming: incomingMessage,
      )) {
        messages[serverIdIndex] = existing.copyWith(
          deliveryStatus: MessageDeliveryStatus.read,
          readAt: incomingMessage.readAt,
          updatedAt: incomingMessage.updatedAt,
        );
        return;
      }
      messages[serverIdIndex] = incomingMessage.copyWith(
        attachments: _mergeAttachments(
          existing: existing,
          incoming: incomingMessage,
        ),
      );
      return;
    }

    final int clientIdIndex = messages.indexWhere(
      (PrivateMessage message) =>
          message.clientMessageId != null &&
          message.clientMessageId == incomingMessage.clientMessageId,
    );

    if (clientIdIndex != -1) {
      final PrivateMessage existing = messages[clientIdIndex];
      messages[clientIdIndex] = incomingMessage.copyWith(
        attachments: _mergeAttachments(
          existing: existing,
          incoming: incomingMessage,
        ),
      );
      return;
    }

    messages.add(incomingMessage);
  }

  bool _shouldMergeReadReceiptPatch({
    required PrivateMessage existing,
    required PrivateMessage incoming,
  }) {
    return incoming.id == existing.id &&
        incoming.conversationId == existing.conversationId &&
        incoming.deliveryStatus == MessageDeliveryStatus.read &&
        incoming.readAt != null &&
        incoming.text.isEmpty &&
        incoming.attachments.isEmpty;
  }

  /// Returns the authoritative attachment list for a message being upserted.
  ///
  /// If [incoming] already carries attachments (e.g. a fresh WS event with
  /// fully-parsed payloads), those are used as-is — the server is the source
  /// of truth and we must not append [existing] attachments on top, which
  /// would create duplicates.
  ///
  /// If [incoming] carries no attachments (e.g. `private_message_edited`
  /// which never ships an `attachments` field, or a WS event whose attachment
  /// array failed to parse), we fall back to [existing] attachments so they
  /// are not silently lost from the UI.
  List<PrivateMessageAttachment> _mergeAttachments({
    required PrivateMessage existing,
    required PrivateMessage incoming,
  }) {
    if (incoming.attachments.isNotEmpty) {
      return incoming.attachments;
    }
    return existing.attachments;
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

  Future<List<PrivateMessageAttachment>> _uploadReadyAttachments({
    required String conversationId,
    required List<UploadableFile> attachedFiles,
  }) async {
    final DateTime now = DateTime.now().toUtc();
    final List<PrivateMessageAttachment> attachments =
        <PrivateMessageAttachment>[];

    for (int index = 0; index < attachedFiles.length; index++) {
      final UploadableFile file = attachedFiles[index];
      final String mimeType = _resolveMimeType(file);

      final MediaInitUpload initUpload = await _mediaInteractor.initUpload(
        scope: 'private_conversation',
        scopeId: conversationId,
        fileName: file.fileName,
        mimeType: mimeType,
        sizeBytes: file.bytes.length,
      );

      final String? etag = await _mediaInteractor.uploadBytes(
        uploadUrl: initUpload.uploadUrl,
        bytes: file.bytes,
        requiredHeaders: initUpload.requiredHeaders,
      );

      final MediaCompleteUpload completeUpload = await _mediaInteractor
          .completeUpload(
            mediaId: initUpload.mediaId,
            etag: etag,
            contentLength: file.bytes.length,
          );

      attachments.add(
        PrivateMessageAttachment(
          id: 'local-attach-${const Uuid().v4()}',
          messageId: '',
          fileId: completeUpload.mediaId,
          fileType: file.fileType.value,
          order: index,
          createdAt: now,
        ),
      );
    }

    return attachments;
  }

  String _resolveMimeType(UploadableFile file) {
    switch (file.fileType) {
      case UploadableFileType.image:
        return 'image/*';
      case UploadableFileType.video:
        return 'video/*';
      case UploadableFileType.audio:
        return 'audio/*';
      case UploadableFileType.doc:
        return 'application/octet-stream';
      case UploadableFileType.file:
        return 'application/octet-stream';
    }
  }

  @override
  Future<void> close() async {
    await _messagesUpdatesSubscription?.cancel();
    return super.close();
  }
}
