import 'dart:async';

import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/conversation/data/data.dart';
import 'package:locnet_app/features/conversation/domain/domain.dart';
import 'package:locnet_app/mock/mock_backend_storage.dart';

final class MockWebSocketConversationRepo implements IConversationRepo {
  MockWebSocketConversationRepo({
    required ILogger logger,
    required MockBackendStorage backendStorage,
    Duration? artificialDelay,
    int? mockConversationsCount,
    List<Conversation>? initialConversations,
  }) : _logger = logger,
       _backendStorage = backendStorage,
       _artificialDelay = artificialDelay ?? const Duration(milliseconds: 200),
       _updatesController =
           StreamController<ConversationsUpdateRec>.broadcast() {
    _seedInitialConversations(initialConversations: initialConversations);
  }

  final ILogger _logger;
  final MockBackendStorage _backendStorage;
  final Duration _artificialDelay;
  final StreamController<ConversationsUpdateRec> _updatesController;

  static const int _defaultLimit = 20;

  @override
  Stream<ConversationsUpdateRec> get conversationsUpdates =>
      _updatesController.stream;

  @override
  Future<List<Conversation>> loadConversationsList({int page = 1}) async {
    try {
      await Future<void>.delayed(_artificialDelay);

      final int safePage = page <= 0 ? 1 : page;

      final List<ConversationDTO> dtos = _backendStorage.getConversationsPage(
        page: safePage,
        limit: _defaultLimit,
      );

      return dtos
          .where((ConversationDTO dto) => !dto.isDeleted)
          .map(Conversation.fromDTO)
          .toList(growable: false);
    } catch (e, st) {
      _logger.exception(e, st);
      rethrow;
    }
  }

  @override
  Future<Conversation> getConversationById({
    required String conversationId,
  }) async {
    final dto = _backendStorage.getConversationById(conversationId);
    return Conversation.fromDTO(dto!);
  }

  @override
  Future<bool> toggleNotifications({
    required String conversationId,
    required bool newNotificationsStatus,
  }) async {
    await Future<void>.delayed(_artificialDelay);
    return true;
  }

  void pushCreated(Conversation conversation) {
    final ConversationDTO dto = _mapDomainToDto(conversation);
    _backendStorage.upsertConversation(dto);

    _updatesController.add((
      kind: ConversationUpdateType.created,
      conversation: conversation,
    ));
  }

  void pushUpdated(Conversation conversation) {
    final ConversationDTO dto = _mapDomainToDto(conversation);
    _backendStorage.upsertConversation(dto);

    _updatesController.add((
      kind: ConversationUpdateType.updated,
      conversation: conversation,
    ));
  }

  void pushDeleted(String conversationId) {
    final ConversationDTO? removedDto = _backendStorage.removeConversationById(
      conversationId,
    );

    if (removedDto == null) {
      return;
    }

    final Conversation removedConversation = Conversation.fromDTO(removedDto);

    _updatesController.add((
      kind: ConversationUpdateType.deleted,
      conversation: removedConversation,
    ));
  }

  Future<void> dispose() async {
    await _updatesController.close();
  }

  void _seedInitialConversations({
    required List<Conversation>? initialConversations,
  }) {
    if (initialConversations == null || initialConversations.isEmpty) {
      return;
    }

    for (final Conversation conversation in initialConversations) {
      final ConversationDTO dto = _mapDomainToDto(conversation);
      _backendStorage.upsertConversation(dto);
    }
  }

  ConversationDTO _mapDomainToDto(Conversation conversation) {
    return ConversationDTO(
      conversationId: conversation.id,
      createdBy: conversation.createdByUserId,
      type: conversation.type.value,
      title: conversation.title,
      description: conversation.description,
      avatarFileId: conversation.avatarFileId,
      isDeleted: conversation.isDeleted,
      deletedAt: conversation.deletedAt,
      deletedBy: conversation.deletedByUserId,
      createdAt: conversation.createdAt,
      updatedAt: conversation.updatedAt,
    );
  }
}
