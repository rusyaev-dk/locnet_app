// ignore_for_file: sort_constructors_first

import 'dart:async';

import 'package:locnet_app/features/conversation/subfeatures/private/domain/domain.dart';
import 'package:locnet_app/features/message/subfeatures/private_message/data/repositories/private_message_repo/i_private_message_repo.dart';
import 'package:locnet_app/mock/mock.dart';

final class MockPrivateMessageRepo implements IPrivateMessageRepo {
  MockPrivateMessageRepo({required MockInMemoryBackend backendStorage})
    : _backendStorage = backendStorage;

  final MockInMemoryBackend _backendStorage;

  @override
  Future<PrivateMessage> sendMessage({required PrivateMessage message}) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));

    final dto = _backendStorage.addPrivateMessage(newMessage: message);
    return PrivateMessage.fromDto(dto);
  }

  @override
  Future<PrivateMessage> editMessage({
    required PrivateMessage updatedMessage,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));

    final dto = _backendStorage.updatePrivateMessage(
      updatedMessage: updatedMessage,
    );
    return PrivateMessage.fromDto(dto);
  }

  @override
  Future<bool> deleteMessage({required PrivateMessage message}) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    return _backendStorage.deletePrivateMessage(message: message);
  }

  @override
  Future<PrivateMessage> toggleMessagePin({
    required PrivateMessage message,
    required bool isPinned,
  }) async {
    final updated = message.copyWith(isPinned: isPinned);
    return editMessage(updatedMessage: updated);
  }

  @override
  Future<List<LastReadPrivateMessage>> loadMessageReads({
    required String conversationId,
    required String messageId,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    // No backing store for reads yet – return empty list.
    return <LastReadPrivateMessage>[];
  }
}

