import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/conversation/subfeatures/group/domain/domain.dart';
import 'package:locnet_app/features/message/domain/domain.dart';
import 'package:locnet_app/features/message/subfeatures/group_message/domain/domain.dart';
import 'package:locnet_app/features/message/subfeatures/message_input/domain/domain.dart';
import 'package:uuid/uuid.dart';

part 'group_message_actions_state.dart';

class GroupMessageActionsCubit extends Cubit<GroupMessageActionsState> {
  GroupMessageActionsCubit({
    required GroupMessageInteractor groupMessageInteractor,
    required UserInteractor userInteractor,
    required ILogger logger,
  }) : _groupMessageInteractor = groupMessageInteractor,
       _userInteractor = userInteractor,
       _logger = logger,
       super(const GroupMessageActionsState(operations: {}));

  final GroupMessageInteractor _groupMessageInteractor;
  final UserInteractor _userInteractor;
  final ILogger _logger;

  Future<void> sendMessage({
    required String groupId,
    List<UploadableFile>? attachedFiles,
    String? text,
    String? replyToMessageId,
  }) async {
    final String normalizedText = text?.trim() ?? '';
    if (normalizedText.isEmpty) return;

    final String clientMessageId = 'local-${const Uuid().v4()}';
    final DateTime now = DateTime.now();

    try {
      final User user = await _userInteractor.getCachedUser();
      int order = 0;
      final List<GroupMessageAttachment> attachments =
          (attachedFiles ?? <UploadableFile>[])
              .map(
                (UploadableFile f) => GroupMessageAttachment(
                  id: 'local-attach-${const Uuid().v4()}',
                  messageId: '',
                  fileId: 'pending-${const Uuid().v4()}',
                  order: order++,
                  createdAt: now,
                ),
              )
              .toList();

      final GroupMessage localMessage = GroupMessage(
        id: '',
        clientMessageId: clientMessageId,
        senderId: user.userId,
        groupId: groupId,
        attachments: attachments,
        text: normalizedText,
        createdAt: now,
        updatedAt: now,
        isDeleted: false,
        deletedById: null,
        replyToMessageId: replyToMessageId,
        deliveryStatus: MessageDeliveryStatus.sending,
        isPinned: false,
        editedAt: null,
      );

      _upsertOperation(
        GroupMessageActionOperation(
          clientMessageId: clientMessageId,
          groupId: groupId,
          type: GroupMessageActionType.send,
          status: GroupMessageActionStatus.sending,
          message: localMessage,
        ),
      );

      await _groupMessageInteractor.sendMessage(message: localMessage);
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

  Future<void> forwardMessage({
    required String groupId,
    required GroupMessage sourceMessage,
  }) async {
    final String normalizedText = sourceMessage.text.trim();
    final bool hasAttachments = sourceMessage.attachments.isNotEmpty;
    if (normalizedText.isEmpty && !hasAttachments) {
      return;
    }

    final String clientMessageId = 'local-${const Uuid().v4()}';
    final DateTime now = DateTime.now();

    try {
      final User user = await _userInteractor.getCachedUser();
      final List<GroupMessageAttachment> attachments = sourceMessage.attachments
          .map(
            (GroupMessageAttachment attachment) => attachment.copyWith(
              id: 'local-attach-${const Uuid().v4()}',
              messageId: '',
              createdAt: now,
            ),
          )
          .toList(growable: false);

      final GroupMessage localMessage = GroupMessage(
        id: '',
        clientMessageId: clientMessageId,
        senderId: user.userId,
        groupId: groupId,
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
        GroupMessageActionOperation(
          clientMessageId: clientMessageId,
          groupId: groupId,
          type: GroupMessageActionType.send,
          status: GroupMessageActionStatus.sending,
          message: localMessage,
        ),
      );

      await _groupMessageInteractor.sendMessage(message: localMessage);
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

  Future<void> editMessage({
    required GroupMessage message,
    required String newText,
  }) async {
    final String normalizedText = newText.trim();
    if (normalizedText.isEmpty) return;

    final String operationKey = message.id;
    _upsertOperation(
      GroupMessageActionOperation(
        clientMessageId: operationKey,
        groupId: message.groupId,
        type: GroupMessageActionType.edit,
        status: GroupMessageActionStatus.editing,
        message: message,
        messageId: message.id,
      ),
    );

    try {
      final GroupMessage updatedMessage = message.copyWith(
        text: normalizedText,
        updatedAt: DateTime.now(),
        editedAt: DateTime.now(),
      );
      await _groupMessageInteractor.editMessage(
        updatedMessage: updatedMessage,
      );
      _markSuccess(clientMessageId: operationKey);
    } catch (e, st) {
      _logger.exception(e, st);
      final AppException appException = e is AppException
          ? e
          : AppUnknownException(
              message: e.toString(),
              error: e,
              stackTrace: st,
            );
      _markFailure(clientMessageId: operationKey, failure: appException);
    }
  }

  Future<void> deleteMessage({required GroupMessage message}) async {
    final String operationKey = message.id;
    _upsertOperation(
      GroupMessageActionOperation(
        clientMessageId: operationKey,
        groupId: message.groupId,
        type: GroupMessageActionType.delete,
        status: GroupMessageActionStatus.deleting,
        message: message,
        messageId: message.id,
      ),
    );

    try {
      await _groupMessageInteractor.deleteMessage(message: message);
      _markSuccess(clientMessageId: operationKey);
    } catch (e, st) {
      _logger.exception(e, st);
      final AppException appException = e is AppException
          ? e
          : AppUnknownException(
              message: e.toString(),
              error: e,
              stackTrace: st,
            );
      _markFailure(clientMessageId: operationKey, failure: appException);
    }
  }

  Future<void> toggleMessagePin({
    required GroupMessage message,
    required bool isPinned,
  }) async {
    final String operationKey = message.id;
    _upsertOperation(
      GroupMessageActionOperation(
        clientMessageId: operationKey,
        groupId: message.groupId,
        type: GroupMessageActionType.pin,
        status: GroupMessageActionStatus.togglingPin,
        message: message,
        messageId: message.id,
      ),
    );

    try {
      await _groupMessageInteractor.toggleMessagePin(
        message: message,
        isPinned: isPinned,
      );
      _markSuccess(clientMessageId: operationKey);
    } catch (e, st) {
      _logger.exception(e, st);
      final AppException appException = e is AppException
          ? e
          : AppUnknownException(
              message: e.toString(),
              error: e,
              stackTrace: st,
            );
      _markFailure(clientMessageId: operationKey, failure: appException);
    }
  }

  void _upsertOperation(GroupMessageActionOperation operation) {
    final Map<String, GroupMessageActionOperation> updatedOperations =
        Map<String, GroupMessageActionOperation>.from(state.operations);
    updatedOperations[operation.clientMessageId] = operation;
    emit(state.copyWith(operations: updatedOperations));
  }

  void _markSuccess({required String clientMessageId}) {
    final GroupMessageActionOperation? existingOperation =
        state.operations[clientMessageId];
    if (existingOperation == null) return;

    final GroupMessage? msg = existingOperation.message;
    _upsertOperation(
      existingOperation.copyWith(
        status: GroupMessageActionStatus.success,
        message: msg?.copyWith(
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
    final GroupMessageActionOperation? existingOperation =
        state.operations[clientMessageId];
    if (existingOperation == null) return;

    final GroupMessage? msg = existingOperation.message;
    _upsertOperation(
      existingOperation.copyWith(
        status: GroupMessageActionStatus.failure,
        failure: failure,
        message: msg?.copyWith(
          deliveryStatus: MessageDeliveryStatus.failed,
          updatedAt: DateTime.now(),
        ),
      ),
    );
  }
}
