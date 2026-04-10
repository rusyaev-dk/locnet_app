import 'dart:async';

import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/conversation/subfeatures/private/data/data.dart';
import 'package:locnet_app/features/conversation/subfeatures/private/domain/domain.dart';
import 'package:locnet_app/features/message/domain/domain.dart';
import 'package:locnet_app/features/message/subfeatures/private_message/data/repositories/private_message_repo/i_private_message_repo.dart';

/// HTTP-backed implementation of [IPrivateMessageRepo] talking to the
/// `/private-chats/messages` and `/private-chats/conversations/{cid}/messages/{mid}`
/// endpoints described by the gateway OpenAPI spec.
class HttpPrivateMessageRepo implements IPrivateMessageRepo {
  HttpPrivateMessageRepo({required IHttpClient httpClient})
    : _httpClient = httpClient;

  final IHttpClient _httpClient;

  // Local stream of message updates so optimistic UI / multi-screen
  // consumers can react. Until a real WebSocket layer is wired up,
  // we publish updates here on every successful mutation.
  static final StreamController<PrivateConversationMessageUpdateRec>
  _messagesUpdatesController =
      StreamController<PrivateConversationMessageUpdateRec>.broadcast();

  static Stream<PrivateConversationMessageUpdateRec> get messagesUpdates =>
      _messagesUpdatesController.stream;

  @override
  Future<PrivateMessage> sendMessage({required PrivateMessage message}) async {
    try {
      final Map<String, dynamic> body = <String, dynamic>{
        'conversationId': message.conversationId,
        'text': message.text,
        if (message.clientMessageId != null)
          'clientMessageId': message.clientMessageId,
        if (message.replyToMessageId != null)
          'replyToMessageId': message.replyToMessageId,
      };

      final httpResponse = await _httpClient.post(
        path: ApiEndpoints.privateMessages,
        data: body,
      );

      final dynamic data = httpResponse.data;
      if (data is! Map<String, dynamic>) {
        throw AppUnknownException(
          message: 'Invalid API response format',
          error: data,
          stackTrace: StackTrace.current,
        );
      }

      final Map<String, dynamic> normalized = <String, dynamic>{
        ...data,
        'id': data['id'] ?? data['messageId'],
        'conversationId': data['conversationId'] ?? message.conversationId,
        'clientMessageId': data['clientMessageId'] ?? message.clientMessageId,
        'createdAt':
            _normalizeDateValue(data['createdAt']) ??
            DateTime.now().toIso8601String(),
        'updatedAt':
            _normalizeDateValue(data['updatedAt']) ??
            _normalizeDateValue(data['createdAt']) ??
            DateTime.now().toIso8601String(),
      };

      final PrivateMessageDto dto = PrivateMessageDto.fromJson(normalized);
      final PrivateMessage saved = PrivateMessage.fromDto(
        dto,
      ).copyWith(deliveryStatus: MessageDeliveryStatus.sent);

      _messagesUpdatesController.add((
        updateType: PrivateConversationMessageUpdateType.created,
        message: saved,
      ));

      return saved;
    } on AppException {
      rethrow;
    } catch (e, st) {
      throw AppUnknownException(
        message: 'Failed to send private message',
        error: e,
        stackTrace: st,
      );
    }
  }

  @override
  Future<PrivateMessage> editMessage({
    required PrivateMessage updatedMessage,
  }) async {
    try {
      final httpResponse = await _httpClient.patch(
        path: ApiEndpoints.privateConversationMessage(
          updatedMessage.conversationId,
          updatedMessage.id,
        ),
        data: <String, dynamic>{'text': updatedMessage.text},
      );

      final dynamic data = httpResponse.data;
      if (data is! Map<String, dynamic>) {
        throw AppUnknownException(
          message: 'Invalid API response format',
          error: data,
          stackTrace: StackTrace.current,
        );
      }

      // The edit response is a smaller projection — merge with the
      // local state we already have so the bubble keeps its attachments,
      // reply chain etc.
      final PrivateMessage merged = updatedMessage.copyWith(
        id: (data['messageId'] ?? updatedMessage.id) as String,
        text: (data['text'] ?? updatedMessage.text) as String,
        editedAt: _normalizeDateValue(data['editedAt']) != null
            ? DateTime.tryParse(_normalizeDateValue(data['editedAt'])!)
            : DateTime.now(),
        updatedAt: _normalizeDateValue(data['updatedAt']) != null
            ? DateTime.tryParse(_normalizeDateValue(data['updatedAt'])!) ??
                  DateTime.now()
            : DateTime.now(),
      );

      _messagesUpdatesController.add((
        updateType: PrivateConversationMessageUpdateType.updated,
        message: merged,
      ));

      return merged;
    } on AppException {
      rethrow;
    } catch (e, st) {
      throw AppUnknownException(
        message: 'Failed to edit private message',
        error: e,
        stackTrace: st,
      );
    }
  }

  @override
  Future<bool> deleteMessage({required PrivateMessage message}) async {
    try {
      await _httpClient.delete(
        path: ApiEndpoints.privateConversationMessage(
          message.conversationId,
          message.id,
        ),
      );

      _messagesUpdatesController.add((
        updateType: PrivateConversationMessageUpdateType.deleted,
        message: message.copyWith(isDeleted: true),
      ));

      return true;
    } on AppException {
      rethrow;
    } catch (e, st) {
      throw AppUnknownException(
        message: 'Failed to delete private message',
        error: e,
        stackTrace: st,
      );
    }
  }

  @override
  Future<PrivateMessage> toggleMessagePin({
    required PrivateMessage message,
    required bool isPinned,
  }) async {
    // Backend does not yet expose a pin endpoint — return the message
    // unchanged so the UI can degrade gracefully.
    return message.copyWith(isPinned: isPinned);
  }

  @override
  Future<List<LastReadPrivateMessage>> loadMessageReads({
    required String conversationId,
    required String messageId,
  }) async {
    // Reads endpoint is not yet implemented on the backend.
    return <LastReadPrivateMessage>[];
  }

  String? _normalizeDateValue(Object? raw) {
    if (raw == null) {
      return null;
    }

    if (raw is DateTime) {
      return raw.toIso8601String();
    }

    if (raw is! String || raw.trim().isEmpty) {
      return null;
    }

    final String candidate = raw.trim();
    try {
      return DateTimeFormatter.parse(candidate).toIso8601String();
    } catch (_) {}

    final RegExp goPattern = RegExp(
      r'^(\d{4}-\d{2}-\d{2}) (\d{2}:\d{2}:\d{2}(?:\.\d+)?) ([+-]\d{4}) UTC$',
    );
    final RegExpMatch? match = goPattern.firstMatch(candidate);
    if (match == null) {
      return null;
    }

    final String datePart = match.group(1)!;
    final String timePart = match.group(2)!;
    final String offset = match.group(3)!;
    final String normalizedOffset =
        '${offset.substring(0, 3)}:${offset.substring(3, 5)}';
    final String isoLike = '${datePart}T$timePart$normalizedOffset';

    try {
      return DateTime.parse(isoLike).toIso8601String();
    } catch (_) {
      return null;
    }
  }
}
