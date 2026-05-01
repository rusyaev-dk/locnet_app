import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/conversation/domain/domain.dart';
import 'package:locnet_app/features/conversation/subfeatures/private/private.dart';
import 'package:locnet_app/features/conversation/subfeatures/conversation_tools/presentation/presentation.dart'
    show ConversationSearchSheet, ConversationSharedMediaSheet;
import 'package:locnet_app/features/message/domain/domain.dart';
import 'package:provider/provider.dart';

Future<void> showConversationSearchSheet({
  required BuildContext context,
  required String conversationId,
  required ConversationType conversationType,
  ValueChanged<String>? onMessageSelected,
  PrivateConversationBloc? privateConversationBloc,
}) {
  return showGeneralDialog<void>(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Search',
    barrierColor: Colors.black54,
    transitionDuration: const Duration(milliseconds: 200),
    transitionBuilder: slideFadeDialogTransition,
    pageBuilder: (dialogContext, _, _) => AppModalCard(
      maxWidth: 440,
      verticalInset: 80,
      child: privateConversationBloc == null
          ? ConversationSearchSheet(
              conversationId: conversationId,
              conversationType: conversationType,
              onMessageSelected: onMessageSelected,
            )
          : BlocProvider<PrivateConversationBloc>.value(
              value: privateConversationBloc,
              child: ConversationSearchSheet(
                conversationId: conversationId,
                conversationType: conversationType,
                onMessageSelected: onMessageSelected,
              ),
            ),
    ),
  );
}

Future<void> showConversationSharedMediaSheet({
  required BuildContext context,
  required String conversationId,
  required ConversationType conversationType,
  String? companionName,
  PrivateConversationBloc? privateConversationBloc,
  MediaInteractor? mediaInteractor,
}) {
  MediaInteractor? resolvedMediaInteractor = mediaInteractor;
  try {
    resolvedMediaInteractor ??= Provider.of<MediaInteractor?>(
      context,
      listen: false,
    );
  } catch (_) {
    // Keep null when MediaInteractor is not available in the current scope.
  }

  return showGeneralDialog<void>(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Shared media',
    barrierColor: Colors.black54,
    transitionDuration: const Duration(milliseconds: 200),
    transitionBuilder: slideFadeDialogTransition,
    pageBuilder: (dialogContext, _, __) => AppModalCard(
      maxWidth: 520,
      verticalInset: 48,
      child: privateConversationBloc == null && resolvedMediaInteractor == null
          ? ConversationSharedMediaSheet(
              conversationId: conversationId,
              conversationType: conversationType,
              companionName: companionName,
              mediaInteractor: resolvedMediaInteractor,
            )
          : MultiProvider(
              providers: [
                if (privateConversationBloc != null)
                  BlocProvider<PrivateConversationBloc>.value(
                    value: privateConversationBloc,
                  ),
                if (resolvedMediaInteractor != null)
                  Provider<MediaInteractor>.value(
                    value: resolvedMediaInteractor,
                  ),
              ],
              child: ConversationSharedMediaSheet(
                conversationId: conversationId,
                conversationType: conversationType,
                companionName: companionName,
                mediaInteractor: resolvedMediaInteractor,
              ),
            ),
    ),
  );
}
