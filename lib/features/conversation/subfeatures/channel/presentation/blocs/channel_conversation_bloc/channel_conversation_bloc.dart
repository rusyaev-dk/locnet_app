import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/conversation/data/data.dart';
import 'package:locnet_app/features/conversation/domain/domain.dart';
import 'package:locnet_app/features/conversation/subfeatures/channel/channel.dart';
import 'package:locnet_app/features/message/domain/domain.dart';

part 'channel_conversation_event.dart';
part 'channel_conversation_state.dart';

class ChannelConversationBloc
    extends Bloc<ChannelConversationEvent, ChannelConversationState> {
  ChannelConversationBloc({
    required ChannelInteractor channelInteractor,
    required IConversationRepo conversationRepo,
    required ILogger logger,
  }) : _channelInteractor = channelInteractor,
       _conversationRepo = conversationRepo,
       _logger = logger,
       super(const ChannelConversationLoadingState()) {
    on<ChannelConversationStartedEvent>(_onStarted);
  }

  final ChannelInteractor _channelInteractor;
  final IConversationRepo _conversationRepo;
  final ILogger _logger;

  Future<void> _onStarted(
    ChannelConversationStartedEvent event,
    Emitter<ChannelConversationState> emit,
  ) async {
    try {
      emit(const ChannelConversationLoadingState());

      final List<Message> messages = await _channelInteractor
          .loadMessagesPage(channelId: event.conversationId, page: 1);

      final Conversation conversation = await _conversationRepo
          .getConversationById(conversationId: event.conversationId);

      final List<User> subscribers =
          await _channelInteractor.loadChannelSubscribers(
        channelId: event.conversationId,
      );

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
}
