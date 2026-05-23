import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/conversation/subfeatures/private/domain/domain.dart';

abstract interface class IPrivateConversationRepo {
  Future<bool> blockCompanion({
    required String companionId,
    required String blockedByUserId,
    required String reason,
  });

  Future<bool> deleteConversation({
    required String conversationId,
    required bool deleteAtRecipient,
  });

  /// Calls `POST /private-chats/conversations` with `{companionId}`.
  ///
  /// The backend either creates a new private conversation between the
  /// current user and [companionId], or returns the existing one.
  Future<PrivateConversation> getOrCreateByCompanion({
    required String companionId,
  });

  Future<List<PrivateConversation>> listConversations({int page = 1});

  Future<User> getCompanion({required String conversationId});

  Future<bool> toggleNotifications({
    required String conversationId,
    required bool newNotificationsStatus,
  });

  Future<List<PrivateMessage>> loadMessagesPage({
    required String conversationId,
    int page = 1,
  });

  Stream<PrivateConversationMessageUpdateRec> get messagesUpdates;

  /// Trims locally cached messages for [conversationId] (no-op without DB cache).
  Future<void> trimCachedMessages({required String conversationId});
}
