import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/conversation/subfeatures/private/private.dart';

part 'private_conversation_options_state.dart';

class PrivateConversationOptionsCubit
    extends Cubit<PrivateConversationOptionsState> {
  PrivateConversationOptionsCubit({
    required PrivateConversationInteractor privateConversationInteractor,
    required ILogger logger,
    required String conversationId,
  }) : _privateConversationInteractor = privateConversationInteractor,
       _logger = logger,
       _conversationId = conversationId,
       super(
         PrivateConversationOptionsInitialState(conversationId: conversationId),
       ) {
    _loadConversationData();
  }

  final PrivateConversationInteractor _privateConversationInteractor;
  final ILogger _logger;
  final String _conversationId;

  Future<void> _loadConversationData() async {
    try {
      if (state is! PrivateConversationOptionsInitialState) {
        return;
      }
      final prevState = state as PrivateConversationOptionsInitialState;
      if (!isClosed) {
        emit(const PrivateConversationOptionsLoadingState());
      }

      final User companion = await _privateConversationInteractor.getCompanion(
        conversationId: prevState.conversationId,
      );

      if (!isClosed) {
        emit(
          PrivateConversationOptionsLoadedState(
            companionId: companion.userId,
            conversationId: prevState.conversationId,
          ),
        );
      }
    } catch (e, st) {
      _logger.exception(e, st);

      final AppException appException = e is AppException
          ? e
          : AppUnknownException(
              message: e.toString(),
              error: e,
              stackTrace: st,
            );

      if (!isClosed) {
        emit(PrivateConversationOptionsFailureState(failure: appException));
      }
    }
  }

  Future<void> toggleNotifications({required bool newStatus}) async {
    try {} catch (e, st) {
      _logger.exception(e, st);

      final AppException appException = e is AppException
          ? e
          : AppUnknownException(
              message: e.toString(),
              error: e,
              stackTrace: st,
            );

      if (!isClosed) {
        emit(PrivateConversationOptionsFailureState(failure: appException));
      }
    }
  }

  Future<void> deleteConversation() async {
    try {
      await _privateConversationInteractor.deleteConversation(
        conversationId: _conversationId,
        deleteAtRecipient: false,
      );
      if (!isClosed) {
        emit(const PrivateConversationOptionsDeletedState());
      }
    } catch (e, st) {
      _logger.exception(e, st);

      final AppException appException = e is AppException
          ? e
          : AppUnknownException(
              message: e.toString(),
              error: e,
              stackTrace: st,
            );

      if (!isClosed) {
        emit(PrivateConversationOptionsFailureState(failure: appException));
      }
    }
  }

  Future<void> blockCompanion() async {
    try {} catch (e, st) {
      _logger.exception(e, st);

      final AppException appException = e is AppException
          ? e
          : AppUnknownException(
              message: e.toString(),
              error: e,
              stackTrace: st,
            );

      if (!isClosed) {
        emit(PrivateConversationOptionsFailureState(failure: appException));
      }
    }
  }

  Future<void> unblockCompanion() async {
    try {} catch (e, st) {
      _logger.exception(e, st);

      final AppException appException = e is AppException
          ? e
          : AppUnknownException(
              message: e.toString(),
              error: e,
              stackTrace: st,
            );

      if (!isClosed) {
        emit(PrivateConversationOptionsFailureState(failure: appException));
      }
    }
  }
}
