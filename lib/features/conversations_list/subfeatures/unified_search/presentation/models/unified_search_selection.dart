import 'package:locnet_app/core/core.dart';

/// Result returned from [UnifiedSearchModalCard] when the user picks an item.
sealed class UnifiedSearchSelection {
  const UnifiedSearchSelection();
}

/// Open a private draft for this companion (no conversation id yet).
final class UnifiedSearchDraftSelection extends UnifiedSearchSelection {
  const UnifiedSearchDraftSelection({required this.companion});

  final User companion;
}

/// Open an existing conversation.
final class UnifiedSearchConversationSelection extends UnifiedSearchSelection {
  const UnifiedSearchConversationSelection({required this.conversationId});

  final String conversationId;
}
