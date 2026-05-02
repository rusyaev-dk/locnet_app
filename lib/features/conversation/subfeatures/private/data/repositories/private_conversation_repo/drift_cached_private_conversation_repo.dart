import 'dart:async';

import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/core/data/storage/db/db.dart';
import 'package:locnet_app/core/data/storage/db/mappers/private_message_mapper.dart';
import 'package:locnet_app/features/conversation/subfeatures/private/data/repositories/private_conversation_repo/i_private_conversation_repo.dart';
import 'package:locnet_app/features/conversation/subfeatures/private/domain/domain.dart';

final class DriftCachedPrivateConversationRepo
    implements IPrivateConversationRepo {
  DriftCachedPrivateConversationRepo({
    required IPrivateConversationRepo network,
    required PrivateMessagesDao messagesDao,
  })  : _network = network,
        _messagesDao = messagesDao;

  final IPrivateConversationRepo _network;
  final PrivateMessagesDao _messagesDao;

  @override
  Future<List<PrivateMessage>> loadMessagesPage({
    required String conversationId,
    int page = 1,
  }) async {
    final cachedRows = await _messagesDao.getPage(
      conversationId: conversationId,
      page: page,
    );

    if (cachedRows.isNotEmpty) {
      final messages = await _hydrateMessages(cachedRows);
      if (page == 1) {
        unawaited(_refreshMessagesFromNetwork(conversationId: conversationId));
      }
      return messages;
    }

    final fresh = await _network.loadMessagesPage(
      conversationId: conversationId,
      page: page,
    );
    await _saveMessages(fresh);
    return fresh;
  }

  @override
  Stream<PrivateConversationMessageUpdateRec> get messagesUpdates =>
      _network.messagesUpdates.asyncMap((update) async {
        await _applyUpdateToCache(update);
        return update;
      });

  @override
  Future<bool> blockCompanion({
    required String companionId,
    required String blockedByUserId,
    required String reason,
  }) =>
      _network.blockCompanion(
        companionId: companionId,
        blockedByUserId: blockedByUserId,
        reason: reason,
      );

  @override
  Future<bool> deleteConversation({
    required String conversationId,
    required bool deleteAtRecipient,
  }) async {
    final result = await _network.deleteConversation(
      conversationId: conversationId,
      deleteAtRecipient: deleteAtRecipient,
    );
    if (result) {
      await _messagesDao.deleteByConversation(conversationId);
    }
    return result;
  }

  @override
  Future<PrivateConversation> getOrCreateByCompanion({
    required String companionId,
  }) =>
      _network.getOrCreateByCompanion(companionId: companionId);

  @override
  Future<List<PrivateConversation>> listConversations({int page = 1}) =>
      _network.listConversations(page: page);

  @override
  Future<User> getCompanion({required String conversationId}) =>
      _network.getCompanion(conversationId: conversationId);

  @override
  Future<bool> toggleNotifications({
    required String conversationId,
    required bool newNotificationsStatus,
  }) =>
      _network.toggleNotifications(
        conversationId: conversationId,
        newNotificationsStatus: newNotificationsStatus,
      );

  Future<void> _refreshMessagesFromNetwork({
    required String conversationId,
  }) async {
    try {
      final fresh = await _network.loadMessagesPage(
        conversationId: conversationId,
      );
      await _saveMessages(fresh);
    } catch (_) {
      // фоновый refresh не должен ронять UI
    }
  }

  Future<void> _saveMessages(List<PrivateMessage> messages) async {
    final msgCompanions =
        messages.map(PrivateMessageMapper.toCompanion).toList();
    final attachCompanions =
        messages.expand(PrivateMessageMapper.attachmentsToCompanions).toList();
    await _messagesDao.upsertAll(msgCompanions);
    if (attachCompanions.isNotEmpty) {
      await _messagesDao.upsertAttachments(attachCompanions);
    }
  }

  Future<List<PrivateMessage>> _hydrateMessages(
    List<PrivateMessagesTableData> rows,
  ) async {
    final List<PrivateMessage> result = [];
    for (final row in rows) {
      final attachRows = await _messagesDao.getAttachments(row.id);
      result.add(PrivateMessageMapper.fromRow(row, attachRows));
    }
    return result;
  }

  Future<void> _applyUpdateToCache(
      PrivateConversationMessageUpdateRec update) async {
    switch (update.updateType) {
      case PrivateConversationMessageUpdateType.created:
      case PrivateConversationMessageUpdateType.updated:
        final companion = PrivateMessageMapper.toCompanion(update.message);
        await _messagesDao.upsertMessage(companion);
        final attachCompanions =
            PrivateMessageMapper.attachmentsToCompanions(update.message);
        if (attachCompanions.isNotEmpty) {
          await _messagesDao.upsertAttachments(attachCompanions);
        }
      case PrivateConversationMessageUpdateType.deleted:
        await _messagesDao.markDeleted(update.message.id);
    }
  }
}
