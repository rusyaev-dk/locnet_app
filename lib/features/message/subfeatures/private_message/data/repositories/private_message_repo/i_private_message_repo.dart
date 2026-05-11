import 'package:locnet_app/features/conversation/subfeatures/private/domain/domain.dart';

/// Repository for private dialog messages.
abstract interface class IPrivateMessageRepo {
  Future<PrivateMessage> sendMessage({required PrivateMessage message});

  Future<PrivateMessage> editMessage({required PrivateMessage updatedMessage});

  Future<bool> deleteMessage({required PrivateMessage message});

  Future<PrivateMessage> toggleMessagePin({
    required PrivateMessage message,
    required bool isPinned,
  });

  /// For now mock backend doesn't store reads; implementation may return empty.
  Future<List<LastReadPrivateMessage>> loadMessageReads({
    required String conversationId,
    required String messageId,
  });

  /// Marks the message as read by the current user.
  /// Returns an updated message with [MessageDeliveryStatus.read] and [readAt].
  Future<PrivateMessage> markMessageAsRead({
    required String conversationId,
    required String messageId,
  });
}

