import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/conversation/domain/domain.dart';
import 'package:locnet_app/features/conversation/subfeatures/private/private.dart';
import 'package:locnet_app/features/conversation/subfeatures/conversation_tools/presentation/presentation.dart'
    show ConversationSearchSheet, ConversationSharedMediaSheet;

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
}) {
  return showGeneralDialog<void>(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Shared media',
    barrierColor: Colors.black54,
    transitionDuration: const Duration(milliseconds: 200),
    transitionBuilder: slideFadeDialogTransition,
    pageBuilder: (context, _, __) => AppModalCard(
      maxWidth: 480,
      verticalInset: 60,
      child: ConversationSharedMediaSheet(
        conversationId: conversationId,
        conversationType: conversationType,
      ),
    ),
  );
}
