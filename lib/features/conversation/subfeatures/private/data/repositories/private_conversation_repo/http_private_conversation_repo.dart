import 'dart:async';

import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/auth/data/data.dart';
import 'package:locnet_app/features/conversation/subfeatures/private/data/data.dart';
import 'package:locnet_app/features/conversation/subfeatures/private/domain/models/private_conversation.dart';
import 'package:locnet_app/features/conversation/subfeatures/private/domain/models/private_conversation_message_update.dart';
import 'package:locnet_app/features/conversation/subfeatures/private/domain/models/private_message.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class HttpPrivateConversationRepo implements IPrivateConversationRepo {
  HttpPrivateConversationRepo({
    required IHttpClient httpClient,
    required ApiConfig apiConfig,
    ISessionCacheRepo? sessionCacheRepo,
    ILogger? logger,
  }) : _httpClient = httpClient,
       _apiConfig = apiConfig,
       _sessionCacheRepo = sessionCacheRepo,
       _logger = logger;

  final IHttpClient _httpClient;
  final ApiConfig _apiConfig;
  final ISessionCacheRepo? _sessionCacheRepo;
  final ILogger? _logger;
  io.Socket? _socket;
  bool _isSocketConnecting = false;

  final StreamController<PrivateConversationMessageUpdateRec>
  _messagesUpdatesController =
      StreamController<PrivateConversationMessageUpdateRec>.broadcast();

  @override
  Future<bool> blockCompanion({
    required String companionId,
    required String blockedByUserId,
    required String reason,
  }) {
    // TODO: implement blockCompanion
    throw UnimplementedError();
  }

  @override
  Future<bool> deleteConversation({
    required String conversationId,
    required bool deleteAtRecipient,
  }) async {
    try {
      // The backend exposes a hard DELETE and a PUT for soft delete.
      // We use DELETE here regardless of [deleteAtRecipient] until the
      // soft-delete UX is wired up.
      await _httpClient.delete(
        path: ApiEndpoints.privateConversation(conversationId),
      );
      return true;
    } on AppException {
      rethrow;
    } catch (e, st) {
      throw AppUnknownException(
        message: 'Failed to delete private conversation',
        error: e,
        stackTrace: st,
      );
    }
  }

  @override
  Future<User> getCompanion({required String conversationId}) async {
    try {
      final httpResponse = await _httpClient.get(
        path: ApiEndpoints.conversationsList,
      );
      final dynamic data = httpResponse.data;
      if (data is! Map<String, dynamic>) {
        throw AppUnknownException(
          message: 'Invalid API response format',
          error: data,
          stackTrace: StackTrace.current,
        );
      }

      final dynamic rawTiles = data['tiles'] ?? data;
      if (rawTiles is! List) {
        throw AppUnknownException(
          message: 'Conversation tiles payload is missing',
          error: rawTiles,
          stackTrace: StackTrace.current,
        );
      }

      for (final dynamic rawTile in rawTiles) {
        if (rawTile is! Map<String, dynamic>) {
          continue;
        }
        if (rawTile['conversationId'] != conversationId) {
          continue;
        }
        final dynamic rawCompanion = rawTile['companion'];
        if (rawCompanion is! Map<String, dynamic>) {
          break;
        }
        return User.fromDto(UserDto.fromJson(rawCompanion));
      }

      throw AppUnknownException(
        message: 'Companion for private conversation was not found',
      );
    } on AppException {
      rethrow;
    } catch (e, st) {
      throw AppUnknownException(
        message: 'Failed to load private conversation companion',
        error: e,
        stackTrace: st,
      );
    }
  }

  @override
  Future<PrivateConversation> getOrCreateByCompanion({
    required String companionId,
  }) async {
    try {
      final httpResponse = await _httpClient.post(
        path: ApiEndpoints.privateConversations,
        data: <String, dynamic>{'companionId': companionId},
      );

      final dynamic data = httpResponse.data;
      if (data is! Map<String, dynamic>) {
        throw AppUnknownException(
          message: 'Invalid API response format',
          error: data,
          stackTrace: StackTrace.current,
        );
      }

      final dynamic rawConversation = data['conversation'] ?? data;
      if (rawConversation is! Map<String, dynamic>) {
        throw AppUnknownException(
          message: 'Conversation payload is missing',
          error: rawConversation,
          stackTrace: StackTrace.current,
        );
      }

      final PrivateConversationDto conversationDto =
          PrivateConversationDto.fromJson(rawConversation);
      return PrivateConversation.fromDto(conversationDto);
    } on AppException {
      rethrow;
    } catch (e, st) {
      throw AppUnknownException(
        message: 'Failed to get or create private conversation',
        error: e,
        stackTrace: st,
      );
    }
  }

  @override
  Future<List<PrivateConversation>> listConversations({int page = 1}) async {
    try {
      final int safePage = page <= 0 ? 1 : page;
      final httpResponse = await _httpClient.get(
        path: ApiEndpoints.privateConversations,
        uriParameters: <String, dynamic>{'page': safePage.toString()},
      );

      final dynamic data = httpResponse.data;
      if (data is! Map<String, dynamic>) {
        throw AppUnknownException(
          message: 'Invalid API response format',
          error: data,
          stackTrace: StackTrace.current,
        );
      }

      final dynamic rawConversations = data['conversations'] ?? data;
      if (rawConversations is! List) {
        return <PrivateConversation>[];
      }

      final List<PrivateConversation> conversations = <PrivateConversation>[];
      for (final dynamic rawConversation in rawConversations) {
        if (rawConversation is! Map<String, dynamic>) {
          continue;
        }

        final PrivateConversationDto dto = PrivateConversationDto.fromJson(
          rawConversation,
        );
        conversations.add(PrivateConversation.fromDto(dto));
      }

      return conversations;
    } on AppException {
      rethrow;
    } catch (e, st) {
      throw AppUnknownException(
        message: 'Failed to list private conversations',
        error: e,
        stackTrace: st,
      );
    }
  }

  @override
  Future<List<PrivateMessage>> loadMessagesPage({
    required String conversationId,
    int page = 1,
  }) async {
    try {
      final int safePage = page <= 0 ? 1 : page;
      final httpResponse = await _httpClient.get(
        path: ApiEndpoints.privateConversationMessages(conversationId),
        uriParameters: <String, dynamic>{'page': safePage.toString()},
      );

      final dynamic data = httpResponse.data;
      if (data is! Map<String, dynamic>) {
        throw AppUnknownException(
          message: 'Invalid API response format',
          error: data,
          stackTrace: StackTrace.current,
        );
      }

      final dynamic rawMessages = data['messages'] ?? data['items'] ?? data;
      if (rawMessages is! List) {
        return <PrivateMessage>[];
      }

      final List<PrivateMessage> messages = <PrivateMessage>[];

      for (final dynamic message in rawMessages) {
        if (message is! Map<String, dynamic>) {
          continue;
        }

        final DateTime now = DateTime.now().toUtc();
        final String fallbackTimestamp = now.toIso8601String();

        // Backend history items can differ from DTO shape:
        // - omit conversationId (known from request path)
        // - use Go-like timestamps
        // - use attachment history projection (mediaId/mimeType/...)
        final Map<String, dynamic> normalized = <String, dynamic>{
          ...message,
          'id': message['id'] ?? message['messageId'] ?? '',
          'messageId': message['messageId'] ?? message['id'] ?? '',
          'conversationId': message['conversationId'] ?? conversationId,
          'createdAt':
              _normalizeDateValue(message['createdAt']) ??
              _normalizeDateValue(message['updatedAt']) ??
              fallbackTimestamp,
          'updatedAt':
              _normalizeDateValue(message['updatedAt']) ??
              _normalizeDateValue(message['createdAt']) ??
              fallbackTimestamp,
          'editedAt': _normalizeDateValue(message['editedAt']) ?? '',
          'deletedAt': _normalizeDateValue(message['deletedAt']) ?? '',
          'readAt': _normalizeDateValue(message['readAt']) ?? '',
          'attachments': _normalizeHistoryAttachments(
            raw: message['attachments'],
            messageId: (message['id'] ?? message['messageId'] ?? '').toString(),
            fallbackTimestamp: fallbackTimestamp,
          ),
        };

        final PrivateMessageDto messageDto = PrivateMessageDto.fromJson(
          normalized,
        );

        messages.add(PrivateMessage.fromDto(messageDto));
      }

      return messages;
    } on AppException {
      rethrow;
    } catch (e, st) {
      throw AppUnknownException(
        message: 'Failed to load private messages page',
        error: e,
        stackTrace: st,
      );
    }
  }

  @override
  Stream<PrivateConversationMessageUpdateRec> get messagesUpdates {
    _tryConnectSocket();
    return _messagesUpdatesController.stream;
  }

  @override
  Future<bool> toggleNotifications({
    required String conversationId,
    required bool newNotificationsStatus,
  }) {
    // TODO: implement toggleNotifications
    throw UnimplementedError();
  }

  void _tryConnectSocket() {
    if (_socket?.connected ?? false) {
      return;
    }

    if (_isSocketConnecting) {
      return;
    }

    final String baseUrl = _apiConfig.baseSocketUrl.trim();
    if (baseUrl.isEmpty || _sessionCacheRepo == null) {
      return;
    }

    _isSocketConnecting = true;
    _createAndConnectSocket(baseUrl: baseUrl).whenComplete(() {
      _isSocketConnecting = false;
    });
  }

  Future<void> _createAndConnectSocket({required String baseUrl}) async {
    try {
      final session = await _sessionCacheRepo!.loadSession();
      final String token = session.accessToken;
      if (token.isEmpty) {
        return;
      }

      _socket?.dispose();
      _socket = null;

      final io.OptionBuilder options = io.OptionBuilder()
          .setTransports(<String>['websocket'])
          .disableAutoConnect()
          .setAuth(<String, dynamic>{'token': token})
          .enableReconnection()
          .setReconnectionAttempts(999999)
          .setReconnectionDelay(1000);

      final io.Socket socket = io.io(baseUrl, options.build());

      socket.on('new_private_message', (dynamic payload) {
        _emitIncomingUpdate(
          updateType: PrivateConversationMessageUpdateType.created,
          payload: payload,
        );
      });

      socket.on('private_message_edited', (dynamic payload) {
        _emitIncomingUpdate(
          updateType: PrivateConversationMessageUpdateType.updated,
          payload: payload,
        );
      });

      socket.on('private_message_deleted', (dynamic payload) {
        _emitIncomingUpdate(
          updateType: PrivateConversationMessageUpdateType.deleted,
          payload: payload,
        );
      });

      socket.onConnectError((dynamic error) {
        _logger?.warning('Socket connect error: $error');
        if (error.toString().toLowerCase().contains('jwt expired')) {
          _tryReconnectWithFreshSessionToken();
        }
        _messagesUpdatesController.addError(
          AppUnknownException(message: 'Socket connect error: $error'),
        );
      });

      socket.onError((dynamic error) {
        _logger?.warning('Socket error: $error');
        _messagesUpdatesController.addError(
          AppUnknownException(message: 'Socket error: $error'),
        );
      });

      socket.connect();
      _socket = socket;
    } on StorageException {
      // Expected before login/session restore: skip socket startup.
      return;
    } catch (e, st) {
      _logger?.exception(e, st);
      _messagesUpdatesController.addError(
        e is AppException
            ? e
            : AppUnknownException(
                message: 'Failed to initialize socket for private messages',
                error: e,
                stackTrace: st,
              ),
      );
    }
  }

  void _emitIncomingUpdate({
    required PrivateConversationMessageUpdateType updateType,
    required dynamic payload,
  }) {
    try {
      if (payload is! Map) {
        return;
      }

      final Map<String, dynamic> payloadMap = Map<String, dynamic>.from(
        payload,
      );
      final DateTime now = DateTime.now().toUtc();
      final String fallbackTimestamp = now.toIso8601String();

      final Map<String, dynamic> normalizedPayload = <String, dynamic>{
        'id': payloadMap['id'] ?? payloadMap['messageId'] ?? '',
        'messageId': payloadMap['messageId'] ?? payloadMap['id'] ?? '',
        'conversationId': payloadMap['conversationId'] ?? '',
        'senderId': payloadMap['senderId'] ?? payloadMap['deletedById'] ?? '',
        'text': payloadMap['text'] ?? '',
        'attachments': _normalizeHistoryAttachments(
          raw: payloadMap['attachments'],
          messageId: (payloadMap['id'] ?? payloadMap['messageId'] ?? '')
              .toString(),
          fallbackTimestamp: fallbackTimestamp,
        ),
        'createdAt':
            _normalizeDateValue(payloadMap['createdAt']) ??
            _normalizeDateValue(payloadMap['updatedAt']) ??
            _normalizeDateValue(payloadMap['deletedAt']) ??
            fallbackTimestamp,
        'updatedAt':
            _normalizeDateValue(payloadMap['updatedAt']) ??
            _normalizeDateValue(payloadMap['editedAt']) ??
            _normalizeDateValue(payloadMap['deletedAt']) ??
            _normalizeDateValue(payloadMap['createdAt']) ??
            fallbackTimestamp,
        'isDeleted': payloadMap['isDeleted'] ?? false,
        'deletedById': payloadMap['deletedById'],
        'replyToMessageId': payloadMap['replyToMessageId'],
        'deliveryStatus': payloadMap['deliveryStatus'] ?? 'SENT',
        'clientMessageId': payloadMap['clientMessageId'],
        'isPinned': payloadMap['isPinned'] ?? false,
        'editedAt': payloadMap['editedAt'],
        'readAt': _normalizeDateValue(payloadMap['readAt']) ?? '',
      };

      final PrivateMessageDto dto = PrivateMessageDto.fromJson(
        normalizedPayload,
      );
      final PrivateMessage message = PrivateMessage.fromDto(dto);
      _messagesUpdatesController.add((
        updateType: updateType,
        message: message,
      ));
    } catch (e, st) {
      _logger?.exception(e, st);
      _messagesUpdatesController.addError(
        e is AppException
            ? e
            : AppUnknownException(
                message:
                    'Failed to parse incoming private message socket payload',
                error: e,
                stackTrace: st,
              ),
      );
    }
  }

  Future<void> _tryReconnectWithFreshSessionToken() async {
    try {
      final String baseUrl = _apiConfig.baseSocketUrl.trim();
      if (_sessionCacheRepo == null || baseUrl.isEmpty) {
        return;
      }
      await _createAndConnectSocket(baseUrl: baseUrl);
    } catch (e, st) {
      _logger?.exception(e, st);
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

    // Convert common Go time format:
    // 2026-03-25 15:02:32.271023728 +0000 UTC -> 2026-03-25T15:02:32.271023728+00:00
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

  List<Map<String, dynamic>> _normalizeHistoryAttachments({
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
      final String id =
          (itemMap['id'] ?? itemMap['attachmentId'] ?? itemMap['mediaId'] ?? '')
              .toString();
      final String fileId = (itemMap['fileId'] ?? itemMap['mediaId'] ?? '')
          .toString();
      if (id.isEmpty || fileId.isEmpty) {
        continue;
      }

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
}
