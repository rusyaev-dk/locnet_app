import 'package:flutter/material.dart';
import 'package:locnet_app/features/conversation/domain/domain.dart';
import 'package:locnet_app/features/conversation/subfeatures/conversation_tools/presentation/presentation.dart'
    show ConversationSearchSheet, ConversationSharedMediaSheet;

Future<void> showConversationSearchSheet({
  required BuildContext context,
  required String conversationId,
  required ConversationType conversationType,
}) {
  return showModalBottomSheet<void>(
    context: context,
    useSafeArea: true,
    isScrollControlled: true,
    backgroundColor: Theme.of(context).colorScheme.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) => SizedBox(
      height: MediaQuery.of(context).size.height * 0.6,
      child: ConversationSearchSheet(
        conversationId: conversationId,
        conversationType: conversationType,
      ),
    ),
  );
}

Future<void> showConversationSharedMediaSheet({
  required BuildContext context,
  required String conversationId,
  required ConversationType conversationType,
}) {
  return showModalBottomSheet<void>(
    context: context,
    useSafeArea: true,
    isScrollControlled: true,
    backgroundColor: Theme.of(context).colorScheme.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) => SizedBox(
      height: MediaQuery.of(context).size.height * 0.7,
      child: ConversationSharedMediaSheet(
        conversationId: conversationId,
        conversationType: conversationType,
      ),
    ),
  );
}

