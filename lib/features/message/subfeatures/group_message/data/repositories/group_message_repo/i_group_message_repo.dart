import 'package:locnet_app/features/conversation/subfeatures/group/domain/domain.dart';

/// Repository for group chat messages.
abstract interface class IGroupMessageRepo {
  Future<GroupMessage> sendMessage({required GroupMessage message});

  Future<GroupMessage> editMessage({required GroupMessage updatedMessage});

  Future<bool> deleteMessage({required GroupMessage message});

  Future<GroupMessage> toggleMessagePin({
    required GroupMessage message,
    required bool isPinned,
  });

  /// For now mock backend doesn't store reads; implementation may return empty.
  Future<List<GroupMessageRead>> loadMessageReads({
    required String groupId,
    required String messageId,
  });
}

