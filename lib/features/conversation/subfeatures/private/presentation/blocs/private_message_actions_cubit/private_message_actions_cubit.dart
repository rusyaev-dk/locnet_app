import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/conversation/subfeatures/private/domain/domain.dart';
import 'package:locnet_app/features/message/domain/domain.dart';
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

      final Message localMessage = Message(
        clientMessageId: clientMessageId,
        senderId: user.userId,
        conversationId: conversationId,
        text: normalizedText,
        hasAttachments: false,
        createdAt: now,
        updatedAt: now,
        deliveryStatus: MessageDeliveryStatus.sending,
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

    _upsertOperation(
      existingOperation.copyWith(
        status: PrivateMessageActionStatus.success,
        message: existingOperation.message?.copyWith(
          deliveryStatus: MessageDeliveryStatus.sent,
          updatedAt: DateTime.now(),
        ),
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

    _upsertOperation(
      existingOperation.copyWith(
        status: PrivateMessageActionStatus.failure,
        failure: failure,
        message: existingOperation.message?.copyWith(
          deliveryStatus: MessageDeliveryStatus.failed,
          updatedAt: DateTime.now(),
        ),
      ),
    );
  }
}
