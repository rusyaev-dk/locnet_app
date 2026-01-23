import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/conversation/domain/domain.dart';

enum UnifiedSearchListItemType { user, conversation }

final class UnifiedSearchListItem {
  const UnifiedSearchListItem._({
    required this.type,
    this.user,
    this.conversation,
  });

  factory UnifiedSearchListItem.user(User user) {
    return UnifiedSearchListItem._(
      type: UnifiedSearchListItemType.user,
      user: user,
    );
  }

  factory UnifiedSearchListItem.conversation(Conversation conversation) {
    return UnifiedSearchListItem._(
      type: UnifiedSearchListItemType.conversation,
      conversation: conversation,
    );
  }

  final UnifiedSearchListItemType type;
  final User? user;
  final Conversation? conversation;
}
