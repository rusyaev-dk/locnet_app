import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/conversation/subfeatures/channel/channel.dart';

part 'channel_conversation_event.dart';
part 'channel_conversation_state.dart';

class ChannelConversationBloc
    extends Bloc<ChannelConversationEvent, ChannelConversationState> {
  ChannelConversationBloc({
    required ChannelInteractor channelInteractor,
    required ILogger logger,
  }) : _channelInteractor = channelInteractor,
       _logger = logger,
       super(const ChannelConversationLoadingState()) {
    on<ChannelConversationStartedEvent>(_onStarted);
    on<ChannelConversationPublicationUpdateReceivedEvent>(
      _onPublicationUpdateReceived,
    );

    _publicationsUpdatesSubscription =
        _channelInteractor.publicationsUpdates.listen(
      _onPublicationsUpdatesStreamEvent,
    );
  }

  final ChannelInteractor _channelInteractor;
  final ILogger _logger;

  StreamSubscription<ChannelPublicationUpdateRec>?
      _publicationsUpdatesSubscription;

  void _onPublicationsUpdatesStreamEvent(
    ChannelPublicationUpdateRec update,
  ) {
    add(ChannelConversationPublicationUpdateReceivedEvent(update: update));
  }

  Future<void> _onStarted(
    ChannelConversationStartedEvent event,
    Emitter<ChannelConversationState> emit,
  ) async {
    try {
      emit(const ChannelConversationLoadingState());

      final List<ChannelPublication> messages = await _channelInteractor
          .loadPublications(channelId: event.conversationId);

      final Channel conversation = await _channelInteractor.getChannel(
        channelId: event.conversationId,
      );

      final List<User> subscribers = await _channelInteractor
          .loadChannelSubscribers(channelId: event.conversationId);

      emit(
        ChannelConversationLoadedState(
          messages: messages,
          conversation: conversation,
          subscribers: subscribers,
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

      emit(ChannelConversationFailureState(failure: appException));
    }
  }

  Future<void> _onPublicationUpdateReceived(
    ChannelConversationPublicationUpdateReceivedEvent event,
    Emitter<ChannelConversationState> emit,
  ) async {
    try {
      final ChannelConversationState currentState = state;
      if (currentState is! ChannelConversationLoadedState) {
        return;
      }

      final ChannelConversationLoadedState loadedState = currentState;
      final ChannelPublication incomingPublication = event.update.publication;

      if (incomingPublication.channelId != loadedState.conversation.channelId) {
        return;
      }

      final List<ChannelPublication> updatedMessages =
          List<ChannelPublication>.from(loadedState.messages);

      switch (event.update.updateType) {
        case ChannelPublicationUpdateType.created:
          _upsertIncomingPublication(
            messages: updatedMessages,
            incomingPublication: incomingPublication,
          );
        case ChannelPublicationUpdateType.updated:
          _upsertIncomingPublication(
            messages: updatedMessages,
            incomingPublication: incomingPublication,
          );
        case ChannelPublicationUpdateType.deleted:
          _removeIncomingPublication(
            messages: updatedMessages,
            incomingPublication: incomingPublication,
          );
      }

      _sortPublicationsByTime(updatedMessages);
      emit(loadedState.copyWith(messages: updatedMessages));
    } catch (e, st) {
      _logger.exception(e, st);
      emit(
        ChannelConversationFailureState(
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

  void _upsertIncomingPublication({
    required List<ChannelPublication> messages,
    required ChannelPublication incomingPublication,
  }) {
    final int serverIdIndex = messages.indexWhere(
      (ChannelPublication p) =>
          p.publicationId == incomingPublication.publicationId,
    );
    if (serverIdIndex != -1) {
      messages[serverIdIndex] = incomingPublication;
      return;
    }
    final int clientIdIndex = messages.indexWhere(
      (ChannelPublication p) =>
          p.clientPublicationId == incomingPublication.clientPublicationId,
    );
    if (clientIdIndex != -1) {
      messages[clientIdIndex] = incomingPublication;
      return;
    }
    messages.add(incomingPublication);
  }

  void _removeIncomingPublication({
    required List<ChannelPublication> messages,
    required ChannelPublication incomingPublication,
  }) {
    messages.removeWhere(
      (ChannelPublication p) =>
          p.publicationId == incomingPublication.publicationId ||
          p.clientPublicationId == incomingPublication.clientPublicationId,
    );
  }

  void _sortPublicationsByTime(List<ChannelPublication> messages) {
    messages.sort((ChannelPublication first, ChannelPublication second) {
      final int createdCompare =
          second.createdAt.compareTo(first.createdAt);
      if (createdCompare != 0) return createdCompare;
      return second.updatedAt.compareTo(first.updatedAt);
    });
  }

  @override
  Future<void> close() async {
    await _publicationsUpdatesSubscription?.cancel();
    return super.close();
  }
}
