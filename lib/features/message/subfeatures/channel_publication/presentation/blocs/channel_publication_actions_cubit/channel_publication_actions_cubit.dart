import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/conversation/subfeatures/channel/domain/domain.dart';
import 'package:locnet_app/features/message/domain/domain.dart';
import 'package:locnet_app/features/message/subfeatures/channel_publication/domain/domain.dart';
import 'package:locnet_app/features/message/subfeatures/message_input/domain/domain.dart';
import 'package:uuid/uuid.dart';

part 'channel_publication_actions_state.dart';

class ChannelPublicationActionsCubit
    extends Cubit<ChannelPublicationActionsState> {
  ChannelPublicationActionsCubit({
    required ChannelPublicationInteractor channelPublicationInteractor,
    required UserInteractor userInteractor,
    required ILogger logger,
  }) : _channelPublicationInteractor = channelPublicationInteractor,
       _userInteractor = userInteractor,
       _logger = logger,
       super(const ChannelPublicationActionsState(operations: {}));

  final ChannelPublicationInteractor _channelPublicationInteractor;
  final UserInteractor _userInteractor;
  final ILogger _logger;

  Future<void> sendPublication({
    required String channelId,
    List<UploadableFile>? attachedFiles,
    String? text,
    String? replyToPublicationId,
  }) async {
    final String normalizedText = text?.trim() ?? '';
    if (normalizedText.isEmpty) return;

    final String clientPublicationId = 'local-${const Uuid().v4()}';
    final DateTime now = DateTime.now();

    try {
      final User user = await _userInteractor.getCachedUser();
      int order = 0;
      final List<ChannelPublicationAttachment> attachments =
          (attachedFiles ?? <UploadableFile>[])
              .map(
                (UploadableFile f) => ChannelPublicationAttachment(
                  attachmentId: 'local-attach-${const Uuid().v4()}',
                  publicationId: '',
                  fileId: 'pending-${const Uuid().v4()}',
                  order: order++,
                  createdAt: now,
                ),
              )
              .toList();

      final ChannelPublication localPublication = ChannelPublication(
        publicationId: '',
        channelId: channelId,
        publishedById: user.userId,
        text: normalizedText,
        attachments: attachments,
        avatarFileId: null,
        replyToPublicationId: replyToPublicationId,
        isDeleted: false,
        deletedById: null,
        createdAt: now,
        updatedAt: now,
        deliveryStatus: MessageDeliveryStatus.sending,
        clientPublicationId: clientPublicationId,
        isPinned: false,
        editedAt: null,
      );

      _upsertOperation(
        ChannelPublicationActionOperation(
          clientPublicationId: clientPublicationId,
          channelId: channelId,
          type: ChannelPublicationActionType.send,
          status: ChannelPublicationActionStatus.sending,
          publication: localPublication,
        ),
      );

      await _channelPublicationInteractor.sendPublication(
        publication: localPublication,
      );
      _markSuccess(clientPublicationId: clientPublicationId);
    } catch (e, st) {
      _logger.exception(e, st);
      final AppException appException = e is AppException
          ? e
          : AppUnknownException(
              message: e.toString(),
              error: e,
              stackTrace: st,
            );
      _markFailure(
        clientPublicationId: clientPublicationId,
        failure: appException,
      );
    }
  }

  Future<void> forwardPublication({
    required String channelId,
    required ChannelPublication sourcePublication,
  }) async {
    final String normalizedText = (sourcePublication.text ?? '').trim();
    final bool hasAttachments = sourcePublication.attachments.isNotEmpty;
    if (normalizedText.isEmpty && !hasAttachments) {
      return;
    }

    final String clientPublicationId = 'local-${const Uuid().v4()}';
    final DateTime now = DateTime.now();

    try {
      final User user = await _userInteractor.getCachedUser();
      final List<ChannelPublicationAttachment> attachments =
          sourcePublication.attachments
              .map(
                (ChannelPublicationAttachment attachment) => attachment.copyWith(
                  attachmentId: 'local-attach-${const Uuid().v4()}',
                  publicationId: '',
                  createdAt: now,
                ),
              )
              .toList(growable: false);

      final ChannelPublication localPublication = ChannelPublication(
        publicationId: '',
        channelId: channelId,
        publishedById: user.userId,
        text: normalizedText,
        attachments: attachments,
        avatarFileId: null,
        replyToPublicationId: null,
        isDeleted: false,
        deletedById: null,
        createdAt: now,
        updatedAt: now,
        deliveryStatus: MessageDeliveryStatus.sending,
        clientPublicationId: clientPublicationId,
        isPinned: false,
        editedAt: null,
      );

      _upsertOperation(
        ChannelPublicationActionOperation(
          clientPublicationId: clientPublicationId,
          channelId: channelId,
          type: ChannelPublicationActionType.send,
          status: ChannelPublicationActionStatus.sending,
          publication: localPublication,
        ),
      );

      await _channelPublicationInteractor.sendPublication(
        publication: localPublication,
      );
      _markSuccess(clientPublicationId: clientPublicationId);
    } catch (e, st) {
      _logger.exception(e, st);
      final AppException appException = e is AppException
          ? e
          : AppUnknownException(
              message: e.toString(),
              error: e,
              stackTrace: st,
            );
      _markFailure(
        clientPublicationId: clientPublicationId,
        failure: appException,
      );
    }
  }

  Future<void> editPublication({
    required ChannelPublication publication,
    required String newText,
  }) async {
    final String normalizedText = newText.trim();
    if (normalizedText.isEmpty) return;

    final String operationKey = publication.publicationId;
    _upsertOperation(
      ChannelPublicationActionOperation(
        clientPublicationId: operationKey,
        channelId: publication.channelId,
        type: ChannelPublicationActionType.edit,
        status: ChannelPublicationActionStatus.editing,
        publication: publication,
        publicationId: publication.publicationId,
      ),
    );

    try {
      final ChannelPublication updatedPublication = publication.copyWith(
        text: normalizedText,
        updatedAt: DateTime.now(),
        editedAt: DateTime.now(),
      );
      await _channelPublicationInteractor.editPublication(
        updatedPublication: updatedPublication,
      );
      _markSuccess(clientPublicationId: operationKey);
    } catch (e, st) {
      _logger.exception(e, st);
      final AppException appException = e is AppException
          ? e
          : AppUnknownException(
              message: e.toString(),
              error: e,
              stackTrace: st,
            );
      _markFailure(
        clientPublicationId: operationKey,
        failure: appException,
      );
    }
  }

  Future<void> deletePublication({
    required ChannelPublication publication,
  }) async {
    final String operationKey = publication.publicationId;
    _upsertOperation(
      ChannelPublicationActionOperation(
        clientPublicationId: operationKey,
        channelId: publication.channelId,
        type: ChannelPublicationActionType.delete,
        status: ChannelPublicationActionStatus.deleting,
        publication: publication,
        publicationId: publication.publicationId,
      ),
    );

    try {
      await _channelPublicationInteractor.deletePublication(
        publication: publication,
      );
      _markSuccess(clientPublicationId: operationKey);
    } catch (e, st) {
      _logger.exception(e, st);
      final AppException appException = e is AppException
          ? e
          : AppUnknownException(
              message: e.toString(),
              error: e,
              stackTrace: st,
            );
      _markFailure(
        clientPublicationId: operationKey,
        failure: appException,
      );
    }
  }

  Future<void> togglePublicationPin({
    required ChannelPublication publication,
    required bool isPinned,
  }) async {
    final String operationKey = publication.publicationId;
    _upsertOperation(
      ChannelPublicationActionOperation(
        clientPublicationId: operationKey,
        channelId: publication.channelId,
        type: ChannelPublicationActionType.pin,
        status: ChannelPublicationActionStatus.togglingPin,
        publication: publication,
        publicationId: publication.publicationId,
      ),
    );

    try {
      await _channelPublicationInteractor.togglePublicationPin(
        publication: publication,
        isPinned: isPinned,
      );
      _markSuccess(clientPublicationId: operationKey);
    } catch (e, st) {
      _logger.exception(e, st);
      final AppException appException = e is AppException
          ? e
          : AppUnknownException(
              message: e.toString(),
              error: e,
              stackTrace: st,
            );
      _markFailure(
        clientPublicationId: operationKey,
        failure: appException,
      );
    }
  }

  void _upsertOperation(ChannelPublicationActionOperation operation) {
    final Map<String, ChannelPublicationActionOperation> updatedOperations =
        Map<String, ChannelPublicationActionOperation>.from(
          state.operations,
        );
    updatedOperations[operation.clientPublicationId] = operation;
    emit(state.copyWith(operations: updatedOperations));
  }

  void _markSuccess({required String clientPublicationId}) {
    final ChannelPublicationActionOperation? existingOperation =
        state.operations[clientPublicationId];
    if (existingOperation == null) return;

    final ChannelPublication? pub = existingOperation.publication;
    _upsertOperation(
      existingOperation.copyWith(
        status: ChannelPublicationActionStatus.success,
        publication: pub?.copyWith(
          deliveryStatus: MessageDeliveryStatus.sent,
          updatedAt: DateTime.now(),
        ),
      ),
    );
  }

  void _markFailure({
    required String clientPublicationId,
    required AppException failure,
  }) {
    final ChannelPublicationActionOperation? existingOperation =
        state.operations[clientPublicationId];
    if (existingOperation == null) return;

    final ChannelPublication? pub = existingOperation.publication;
    _upsertOperation(
      existingOperation.copyWith(
        status: ChannelPublicationActionStatus.failure,
        failure: failure,
        publication: pub?.copyWith(
          deliveryStatus: MessageDeliveryStatus.failed,
          updatedAt: DateTime.now(),
        ),
      ),
    );
  }
}
