import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/conversation/subfeatures/private/domain/domain.dart';
import 'package:locnet_app/features/message/domain/domain.dart';
import 'package:locnet_app/features/message/subfeatures/message_input/domain/domain.dart';
import 'package:uuid/uuid.dart';

part 'private_message_actions_state.dart';

class PrivateMessageActionsCubit extends Cubit<PrivateMessageActionsState> {
  PrivateMessageActionsCubit({
    required PrivateConversationInteractor privateConversationInteractor,
    required UserInteractor userInteractor,
    required ILogger logger,
  }) : _privateConversationInteractor = privateConversationInteractor,
       _userInteractor = userInteractor,
       _logger = logger,

       super(const PrivateMessageActionsState(operations: {}));

  final PrivateConversationInteractor _privateConversationInteractor;
  final UserInteractor _userInteractor;
  final ILogger _logger;

  Future<void> sendMessage({
    required String conversationId,
    List<UploadableFile>? attachedFiles,
    String? text,
  }) async {
    final String normalizedText = text?.trim() ?? '';
    if (normalizedText.isEmpty) {
      return;
    }

    final String clientMessageId = 'local-${const Uuid().v4()}';

    final DateTime now = DateTime.now();

    try {
      final User user = await _userInteractor.getCachedUser();

      int order = 0;
      final List<PrivateMessageAttachment> attachments =
          (attachedFiles ?? <UploadableFile>[])
              .map(
                (UploadableFile f) => PrivateMessageAttachment(
                  id: 'local-attach-${const Uuid().v4()}',
                  messageId: '',
                  fileId: 'pending-${const Uuid().v4()}',
                  order: order++,
                  createdAt: now,
                ),
              )
              .toList();

      final PrivateMessage localMessage = PrivateMessage(
        id: '',
        clientMessageId: clientMessageId,
        senderId: user.userId,
        conversationId: conversationId,
        attachments: attachments,
        text: normalizedText,
        createdAt: now,
        updatedAt: now,
        isDeleted: false,
        deletedById: null,
        replyToMessageId: null,
        deliveryStatus: MessageDeliveryStatus.sending,
        isPinned: false,
        editedAt: null,
      );

      _upsertOperation(
        PrivateMessageActionOperation(
          clientMessageId: clientMessageId,
          conversationId: conversationId,
          type: PrivateMessageActionType.send,
          status: PrivateMessageActionStatus.sending,
          message: localMessage,
        ),
      );

      await _privateConversationInteractor.sendMessage(message: localMessage);

      _markSuccess(clientMessageId: clientMessageId);
    } catch (e, st) {
      _logger.exception(e, st);

      final AppException appException = e is AppException
          ? e
          : AppUnknownException(
              message: e.toString(),
              error: e,
              stackTrace: st,
            );

      _markFailure(clientMessageId: clientMessageId, failure: appException);
    }
  }

  void _upsertOperation(PrivateMessageActionOperation operation) {
    final Map<String, PrivateMessageActionOperation> updatedOperations =
        Map<String, PrivateMessageActionOperation>.from(state.operations);

    updatedOperations[operation.clientMessageId] = operation;

    emit(state.copyWith(operations: updatedOperations));
  }

  void _markSuccess({required String clientMessageId}) {
    final PrivateMessageActionOperation? existingOperation =
        state.operations[clientMessageId];
    if (existingOperation == null) {
      return;
    }

    final PrivateMessage? msg = existingOperation.message;
    _upsertOperation(
      existingOperation.copyWith(
        status: PrivateMessageActionStatus.success,
        message: msg != null
            ? msg.copyWith(
                deliveryStatus: MessageDeliveryStatus.sent,
                updatedAt: DateTime.now(),
              )
            : null,
      ),
    );
  }

  void _markFailure({
    required String clientMessageId,
    required AppException failure,
  }) {
    final PrivateMessageActionOperation? existingOperation =
        state.operations[clientMessageId];
    if (existingOperation == null) {
      return;
    }

    final PrivateMessage? msg = existingOperation.message;
    _upsertOperation(
      existingOperation.copyWith(
        status: PrivateMessageActionStatus.failure,
        failure: failure,
        message: msg != null
            ? msg.copyWith(
                deliveryStatus: MessageDeliveryStatus.failed,
                updatedAt: DateTime.now(),
              )
            : null,
      ),
    );
  }
}
