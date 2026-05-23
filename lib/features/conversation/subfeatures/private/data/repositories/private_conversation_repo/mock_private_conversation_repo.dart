// ignore_for_file: sort_constructors_first

import 'dart:async';

import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/conversation/subfeatures/private/data/data.dart';
import 'package:locnet_app/features/conversation/subfeatures/private/domain/domain.dart';
import 'package:locnet_app/features/message/subfeatures/private_message/data/repositories/private_message_repo/mock_private_message_repo.dart';
import 'package:locnet_app/mock/mock.dart';

final class MockPrivateConversationRepo implements IPrivateConversationRepo {
  MockPrivateConversationRepo({required MockInMemoryBackend backendStorage})
    : _backendStorage = backendStorage;

  final MockInMemoryBackend _backendStorage;

  @override
  Stream<PrivateConversationMessageUpdateRec> get messagesUpdates =>
      MockPrivateMessageRepo.messagesUpdates;

  @override
  Future<bool> blockCompanion({
    required String companionId,
    required String blockedByUserId,
    required String reason,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    return true;
  }

  @override
  Future<PrivateConversation> getOrCreateByCompanion({
    required String companionId,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));

    // Try to find an existing private conversation between the current
    // (admin) user and the companion. If none — create a stub on the fly.
    final String currentUserId = MockUsers.adminUser.userId;

    final List<PrivateConversationDto> all = _backendStorage
        .getAllPrivateConversations();

    final PrivateConversationDto? existing = all
        .where(
          (c) =>
              (c.user1Id == currentUserId && c.user2Id == companionId) ||
              (c.user2Id == currentUserId && c.user1Id == companionId),
        )
        .firstOrNull;

    if (existing != null) {
      return PrivateConversation.fromDto(existing);
    }

    final DateTime now = DateTime.now();
    final PrivateConversationDto created = PrivateConversationDto(
      conversationId: 'mock-conv-${now.microsecondsSinceEpoch}',
      user1Id: currentUserId,
      user2Id: companionId,
      createdAt: now,
      updatedAt: now,
      isDeleted: false,
    );
    _backendStorage.upsertPrivateConversation(conversation: created);
    return PrivateConversation.fromDto(created);
  }

  @override
  Future<List<PrivateConversation>> listConversations({int page = 1}) async {
    await Future<void>.delayed(const Duration(milliseconds: 100));
    final int safePage = page <= 0 ? 1 : page;
    final List<PrivateConversationDto> dtos = _backendStorage
        .getAllPrivateConversations(page: safePage);
    return dtos.map(PrivateConversation.fromDto).toList(growable: false);
  }

  @override
  Future<bool> toggleNotifications({
    required String conversationId,
    required bool newNotificationsStatus,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    return true;
  }

  @override
  Future<User> getCompanion({required String conversationId}) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    final conv = _backendStorage.getPrivateConversationById(conversationId);
    final companionId = conv.user1Id == MockUsers.adminUser.userId
        ? conv.user2Id
        : conv.user1Id;
    final companionDto = _backendStorage.getUserById(userId: companionId);
    return User.fromDto(companionDto);
  }

  @override
  Future<bool> deleteConversation({
    required String conversationId,
    required bool deleteAtRecipient,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    return _backendStorage.deletePrivateConversation(
      privateConversationId: conversationId,
    );
  }

  @override
  Future<List<PrivateMessage>> loadMessagesPage({
    required String conversationId,
    int page = 1,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    final int safePage = page <= 0 ? 1 : page;
    final List<PrivateMessageDto> dtos = _backendStorage
        .getAllPrivateMessagesByConversationId(
          conversationId: conversationId,
          page: safePage,
        );
    final List<PrivateMessage> result = <PrivateMessage>[];
    for (final PrivateMessageDto dto in dtos) {
      if (dto.isDeleted) continue;
      result.add(PrivateMessage.fromDto(dto));
    }
    return result;
  }

  @override
  Future<void> trimCachedMessages({required String conversationId}) async {}
}
