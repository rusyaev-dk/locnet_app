import 'dart:async';

import 'package:locnet_app/features/conversation/data/data.dart';
import 'package:locnet_app/features/conversation/domain/domain.dart';
import 'package:locnet_app/mock/mock.dart';

final class MockConversationRepo implements IConversationRepo {
  MockConversationRepo({required MockInMemoryBackend backendStorage})
    : _backendStorage = backendStorage;

  final MockInMemoryBackend _backendStorage;

  @override
  Future<Conversation> getConversationById({
    required String conversationId,
  }) async {
    final dto = _backendStorage.getConversationById(conversationId);
    if (dto == null) {
      throw StateError("conversation with provided id not found");
    }
    return Conversation.fromDto(dto);
  }

  @override
  Future<bool> toggleNotifications({
    required String conversationId,
    required bool newNotificationsStatus,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    return true;
  }
}
