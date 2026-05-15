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
      final String normalizedText = message.text.trim();
      final String? replyToMessageId = _normalizeReplyToMessageId(
        message.replyToMessageId,
      );
      final Map<String, dynamic> body = <String, dynamic>{
        if (normalizedText.isNotEmpty) 'text': normalizedText,
        if (message.clientMessageId != null)
          'clientMessageId': message.clientMessageId,
        if (replyToMessageId != null) 'replyToMessageId': replyToMessageId,
        if (message.attachments.isNotEmpty)
          'attachments': message.attachments
              .map(
                (PrivateMessageAttachment attachment) => <String, dynamic>{
                  'mediaId': attachment.fileId,
                  'fileType': attachment.fileType ?? 'file',
                },
              )
              .toList(growable: false),
      };

      final httpResponse = await _httpClient.post(
        path: ApiEndpoints.privateConversationMessages(message.conversationId),
        data: body,
      );

      final DateTime now = DateTime.now();
      final String fallbackTimestamp = now.toIso8601String();
      final dynamic rawResponse = httpResponse.data;
      final Map<String, dynamic> payload = _extractMessagePayload(rawResponse);
      final String normalizedCreatedAt =
          _normalizeDateValue(payload['createdAt']) ?? fallbackTimestamp;
      final String messageId =
          (payload['id'] ?? payload['messageId'] ?? '').toString();
      final String normalizedTextFromResponse =
          (payload['text'] as String?) ?? normalizedText;
      final List<Map<String, dynamic>> normalizedAttachments =
          _normalizeAttachments(
            raw: payload['attachments'],
            messageId: messageId,
            fallbackTimestamp: normalizedCreatedAt,
          );

      final Map<String, dynamic> normalized = <String, dynamic>{
        ...payload,
        'id': messageId,
        'conversationId': payload['conversationId'] ?? message.conversationId,
        'senderId': payload['senderId'] ?? message.senderId,
        'deliveryStatus':
            payload['deliveryStatus'] ?? payload['status'] ?? 'SENT',
        'clientMessageId': payload['clientMessageId'] ?? message.clientMessageId,
        'text': normalizedTextFromResponse,
        'attachments': normalizedAttachments,
        'isDeleted': payload['isDeleted'] ?? false,
        'isPinned': payload['isPinned'] ?? false,
        'deletedById': payload['deletedById'],
        'replyToMessageId': payload['replyToMessageId'] ?? replyToMessageId,
        'editedAt': payload['editedAt'],
        'readAt': payload['readAt'],
        'createdAt': normalizedCreatedAt,
        'updatedAt':
            _normalizeDateValue(payload['updatedAt']) ?? normalizedCreatedAt,
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

  Map<String, dynamic> _extractMessagePayload(dynamic raw) {
    if (raw is! Map<String, dynamic>) {
      throw AppUnknownException(
        message: 'Invalid API response format',
        error: raw,
        stackTrace: StackTrace.current,
      );
    }

    final dynamic nested = raw['data'] ?? raw['message'];
    if (nested is Map<String, dynamic>) {
      return nested;
    }

    return raw;
  }

  List<Map<String, dynamic>> _normalizeAttachments({
    required Object? raw,
    required String messageId,
    required String fallbackTimestamp,
  }) {
    if (raw is! List) {
      return <Map<String, dynamic>>[];
    }

    final List<Map<String, dynamic>> normalized = <Map<String, dynamic>>[];
    for (int index = 0; index < raw.length; index++) {
      final dynamic item = raw[index];
      if (item is! Map) {
        continue;
      }
      final Map<String, dynamic> itemMap = Map<String, dynamic>.from(item);
      final String fileId = (itemMap['fileId'] ?? itemMap['mediaId'] ?? '')
          .toString();
      if (fileId.isEmpty) {
        continue;
      }
      final String id =
          (itemMap['id'] ??
                  itemMap['attachmentId'] ??
                  itemMap['mediaId'] ??
                  'att-$messageId-$index')
              .toString();
      normalized.add(<String, dynamic>{
        'id': id,
        'messageId': messageId,
        'fileId': fileId,
        'fileType': (itemMap['fileType'] ?? itemMap['mimeType'] ?? '')
            .toString(),
        'order': itemMap['order'] is int ? itemMap['order'] as int : index,
        'createdAt':
            _normalizeDateValue(itemMap['createdAt']) ?? fallbackTimestamp,
      });
    }

    return normalized;
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

  @override
  Future<PrivateMessage> markMessageAsRead({
    required String conversationId,
    required String messageId,
  }) async {
    try {
      final httpResponse = await _httpClient.patch(
        path: ApiEndpoints.privateConversationMessageRead(
          conversationId,
          messageId,
        ),
        data: <String, dynamic>{},
      );

      final Map<String, dynamic> payload =
          _extractMessagePayload(httpResponse.data);

      final MessageReadReceiptDto receipt =
          MessageReadReceiptDto.fromJson(payload);

      final PrivateMessage result = PrivateMessage(
        id: receipt.messageId,
        conversationId: receipt.conversationId,
        senderId: receipt.senderId,
        text: '',
        attachments: const <PrivateMessageAttachment>[],
        createdAt: receipt.readAt,
        updatedAt: receipt.readAt,
        isDeleted: false,
        deletedById: null,
        replyToMessageId: null,
        deliveryStatus:
            MessageDeliveryStatus.fromString(receipt.deliveryStatus),
        clientMessageId: null,
        isPinned: false,
        editedAt: null,
        readAt: receipt.readAt,
      );

      _messagesUpdatesController.add((
        updateType: PrivateConversationMessageUpdateType.updated,
        message: result,
      ));

      return result;
    } on AppException {
      rethrow;
    } catch (e, st) {
      throw AppUnknownException(
        message: 'Failed to mark private message as read',
        error: e,
        stackTrace: st,
      );
    }
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

  String? _normalizeReplyToMessageId(String? value) {
    if (value == null) {
      return null;
    }
    final String normalized = value.trim();
    if (normalized.isEmpty) {
      return null;
    }
    return normalized;
  }
}
