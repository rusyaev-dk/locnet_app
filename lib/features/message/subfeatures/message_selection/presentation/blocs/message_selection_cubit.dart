import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:locnet_app/features/conversation/domain/domain.dart';
import 'package:locnet_app/features/message/subfeatures/message_selection/domain/models/message_selection_models.dart';

part 'message_selection_state.dart';

class MessageSelectionCubit extends Cubit<MessageSelectionState> {
  MessageSelectionCubit({
    required String conversationId,
    required ConversationType conversationType,
  }) : super(
          MessageSelectionState(
            conversationId: conversationId,
            conversationType: conversationType,
            selectedMessageIds: const <MessageId>{},
            isSelectionMode: false,
          ),
        );

  void enterSelectionMode(MessageId messageId) {
    emit(
      state.copyWith(
        isSelectionMode: true,
        selectedMessageIds: <MessageId>{messageId},
      ),
    );
  }

  void toggleMessage(MessageId messageId) {
    final Set<MessageId> updated = Set<MessageId>.from(state.selectedMessageIds);
    if (updated.contains(messageId)) {
      updated.remove(messageId);
    } else {
      updated.add(messageId);
    }

    emit(
      state.copyWith(
        selectedMessageIds: updated,
        isSelectionMode: updated.isNotEmpty && state.isSelectionMode,
      ),
    );
  }

  void clearSelection() {
    emit(
      state.copyWith(
        selectedMessageIds: const <MessageId>{},
        isSelectionMode: false,
      ),
    );
  }

  void selectMessages(Iterable<MessageId> messageIds) {
    final Set<MessageId> updated = Set<MessageId>.from(messageIds);
    emit(
      state.copyWith(
        selectedMessageIds: updated,
        isSelectionMode: updated.isNotEmpty,
      ),
    );
  }
}

