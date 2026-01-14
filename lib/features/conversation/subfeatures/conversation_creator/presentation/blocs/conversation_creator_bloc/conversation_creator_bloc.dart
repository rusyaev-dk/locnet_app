import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/conversation/domain/domain.dart';

part 'conversation_creator_event.dart';
part 'conversation_creator_state.dart';

class ConversationCreatorBloc
    extends Bloc<ConversationCreatorEvent, ConversationCreatorState> {
  ConversationCreatorBloc({
    required ConversationCreatorInteractor conversationCreatorInteractor,
    required ILogger logger,
  }) : _conversationCreatorInteractor = conversationCreatorInteractor,
       _logger = logger,
       super(
         const ConversationCreatorState(
           selectedConversationType: ConversationType.private,
         ),
       ) {
    on<UpdateConversationTypeEvent>(_onUpdateType);
    on<UpdateConversationTitleEvent>(_onUpdateTitle);
    on<UpdateConversationDescriptionEvent>(_onUpdateDescription);
    on<SubmitConversationEvent>(_onCreateConversation);
  }

  final ConversationCreatorInteractor _conversationCreatorInteractor;
  final ILogger _logger;

  Future<void> _onUpdateType(
    UpdateConversationTypeEvent event,
    Emitter<ConversationCreatorState> emit,
  ) async {
    try {
      emit(state.copyWith(selectedConversationType: event.conversationType));
    } catch (e, st) {
      _logger.exception(e, st);
      emit(
        state.copyWith(
          failure: e is AppException
              ? e
              : AppUnknownException(message: e.toString(), stackTrace: st),
        ),
      );
    }
  }

  Future<void> _onUpdateTitle(
    UpdateConversationTitleEvent event,
    Emitter<ConversationCreatorState> emit,
  ) async {
    try {
      if (event.title == null || event.title!.isEmpty) {
        return emit(
          state.copyWith(
            titleException: RequiredValueNotProvidedException(
              message: 'Title cannot be empty',
            ),
          ),
        );
      }

      try {
        ConversationDataFormatter.validateTitle(event.title!);
      } catch (e) {
        return emit(state.copyWith(titleException: e));
      }

      emit(state.copyWith(title: event.title, titleException: null));
    } catch (e, st) {
      _logger.exception(e, st);
      emit(
        state.copyWith(
          failure: e is AppException
              ? e
              : AppUnknownException(message: e.toString(), stackTrace: st),
        ),
      );
    }
  }

  Future<void> _onUpdateDescription(
    UpdateConversationDescriptionEvent event,
    Emitter<ConversationCreatorState> emit,
  ) async {
    try {
      if (event.description == null || event.description!.isEmpty) {
        return emit(state.copyWith());
      }

      try {
        ConversationDataFormatter.validateDescription(event.description!);
      } catch (e) {
        return emit(state.copyWith(descriptionException: e));
      }

      emit(
        state.copyWith(title: event.description, descriptionException: null),
      );
    } catch (e, st) {
      _logger.exception(e, st);
      emit(
        state.copyWith(
          failure: e is AppException
              ? e
              : AppUnknownException(message: e.toString(), stackTrace: st),
        ),
      );
    }
  }

  bool canCreateConversation() {
    if (state.title == null || state.title!.isEmpty) {
      return false;
    }
    return true;
  }

  Future<void> _onCreateConversation(
    SubmitConversationEvent event,
    Emitter<ConversationCreatorState> emit,
  ) async {
    try {
      if (state.isPending) {
        return;
      }

      if (!canCreateConversation()) {
        return;
      }

      final success = await _conversationCreatorInteractor.createConversation(
        type: state.selectedConversationType,
        title: state.title!,
        description: state.description,
        participantIds: state.participantIds,
      );

      if (!success) {
        return emit(
          state.copyWith(
            failure: AppUnknownException(
              message: "Unknown exception during conversation creating",
            ),
          ),
        );
      }
      emit(state.copyWith(success: true));
    } catch (e, st) {
      _logger.exception(e, st);
      emit(
        state.copyWith(
          failure: e is AppException
              ? e
              : AppUnknownException(message: e.toString(), stackTrace: st),
        ),
      );
    }
  }
}
