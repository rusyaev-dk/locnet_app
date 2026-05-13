import 'dart:async';

import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/auth/data/data.dart';
import 'package:locnet_app/features/conversation/subfeatures/private/data/data.dart';
import 'package:locnet_app/features/conversation/subfeatures/private/domain/models/private_conversation.dart';
import 'package:locnet_app/features/conversation/subfeatures/private/domain/models/private_conversation_message_update.dart';
import 'package:locnet_app/features/conversation/subfeatures/private/domain/models/private_message.dart';
import 'package:locnet_app/features/message/subfeatures/private_message/data/repositories/private_message_repo/http_private_message_repo.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:stream_transform/stream_transform.dart';

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
      final httpResponse = await _httpClient.delete(
        path: ApiEndpoints.privateConversation(conversationId),
      );
      final dynamic data = httpResponse.data;
      if (data is! Map<String, dynamic>) {
        throw AppUnknownException(
          message: 'Invalid delete conversation response',
          error: data,
          stackTrace: StackTrace.current,
        );
      }
      if (data['success'] != true) {
        throw AppUnknownException(
          message: 'Delete conversation was not successful',
          error: data,
          stackTrace: StackTrace.current,
        );
      }
      final dynamic conv = data['conversation'];
      if (conv is! Map<String, dynamic>) {
        throw AppUnknownException(
          message: 'Missing conversation in delete response',
          error: data,
          stackTrace: StackTrace.current,
        );
      }
      final PrivateConversationDto dto = PrivateConversationDto.fromJson(conv);
      if (!dto.isDeleted) {
        throw AppUnknownException(
          message: 'Conversation is not marked deleted after delete',
          error: conv,
          stackTrace: StackTrace.current,
        );
      }
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
    _socketLog('messagesUpdates stream requested');
    _tryConnectSocket();
    return _messagesUpdatesController.stream.merge(
      HttpPrivateMessageRepo.messagesUpdates,
    );
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
    _socketLog(
      '_tryConnectSocket called. connected=${_socket?.connected == true}, connecting=$_isSocketConnecting',
    );
    if (_socket?.connected ?? false) {
      _socketLog('skip connect: socket already connected');
      return;
    }

    if (_isSocketConnecting) {
      _socketLog('skip connect: socket is already connecting');
      return;
    }

    final String baseUrl = _apiConfig.baseSocketUrl.trim();
    if (baseUrl.isEmpty || _sessionCacheRepo == null) {
      _socketLog(
        'skip connect: baseUrlEmpty=${baseUrl.isEmpty}, hasSessionCacheRepo=${_sessionCacheRepo != null}',
      );
      return;
    }

    _socketLog('starting socket initialization. baseUrl=$baseUrl');
    _isSocketConnecting = true;
    _createAndConnectSocket(baseUrl: baseUrl).whenComplete(() {
      _isSocketConnecting = false;
      _socketLog('socket initialization attempt completed');
    });
  }

  Future<void> _createAndConnectSocket({required String baseUrl}) async {
    try {
      final session = await _sessionCacheRepo!.loadSession();
      final String token = session.accessToken;
      if (token.isEmpty) {
        _socketLog('skip connect: session token is empty');
        return;
      }
      _socketLog(
        'session token loaded. tokenLength=${token.length}, baseUrl=$baseUrl',
      );

      _socket?.dispose();
      _socket = null;
      _socketLog('disposed previous socket instance');

      // Use websocket-only transport to avoid HTTP long-polling issues on
      // macOS where Dart's HttpClient can silently stall polling requests
      // when running without the Dart VM service (i.e. outside the IDE).
      final io.OptionBuilder options = io.OptionBuilder()
          .setTransports(<String>['websocket'])
          .disableAutoConnect()
          .enableForceNew()
          .disableMultiplex()
          .setPath('/socket.io/')
          .setTimeout(10000)
          .setAuth(<String, dynamic>{'token': token})
          .setExtraHeaders(<String, dynamic>{'Authorization': 'Bearer $token'})
          .enableReconnection()
          .setReconnectionAttempts(999999)
          .setReconnectionDelay(1000);

      final io.Socket socket = io.io(baseUrl, options.build());
      _socketLog('socket instance created, registering listeners');

      socket
        ..on('connecting', (dynamic _) {
          _socketLog('event: connecting');
        })
        ..on('new_private_message', (dynamic payload) {
          _socketLog(
            'event: new_private_message payloadType=${payload.runtimeType}',
          );
          _emitIncomingUpdate(
            updateType: PrivateConversationMessageUpdateType.created,
            payload: payload,
          );
        })
        ..on('private_message_edited', (dynamic payload) {
          _socketLog(
            'event: private_message_edited payloadType=${payload.runtimeType}',
          );
          _emitIncomingUpdate(
            updateType: PrivateConversationMessageUpdateType.updated,
            payload: payload,
          );
        })
        ..on('private_message_deleted', (dynamic payload) {
          _socketLog(
            'event: private_message_deleted payloadType=${payload.runtimeType}',
          );
          _emitIncomingUpdate(
            updateType: PrivateConversationMessageUpdateType.deleted,
            payload: payload,
          );
        })
        ..onConnect((_) {
          _socketLog('event: connect');
        })
        ..onDisconnect((dynamic reason) {
          _socketLog('event: disconnect reason=$reason');
        })
        ..onReconnect((dynamic attempt) {
          _socketLog('event: reconnect attempt=$attempt');
        })
        ..onReconnectAttempt((dynamic attempt) {
          _socketLog('event: reconnect_attempt attempt=$attempt');
        })
        ..onReconnectError((dynamic error) {
          _socketLog('event: reconnect_error error=$error');
        })
        ..onReconnectFailed((dynamic error) {
          _socketLog('event: reconnect_failed error=$error');
        })
        ..onConnectError((dynamic error) {
          _socketLog('event: connect_error error=$error');
          if (error.toString().toLowerCase().contains('jwt expired')) {
            _socketLog('connect_error contains jwt expired, trying reconnect');
            _tryReconnectWithFreshSessionToken();
          }
          _messagesUpdatesController.addError(
            AppUnknownException(message: 'Socket connect error: $error'),
          );
        })
        ..onError((dynamic error) {
          _socketLog('event: error error=$error');
          _messagesUpdatesController.addError(
            AppUnknownException(message: 'Socket error: $error'),
          );
        })
        ..onPing((_) {
          _socketLog('event: ping');
        })
        ..onPong((_) {
          _socketLog('event: pong');
        })
        ..connect();
      _socketLog('connect() invoked');
      _socket = socket;
    } on StorageException catch (e, st) {
      // Expected before login/session restore: skip socket startup.
      _socketLogException(e, st);
      return;
    } catch (e, st) {
      _socketLogException(e, st);
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
        _socketLog(
          'skip token-refresh reconnect: hasSessionCacheRepo=${_sessionCacheRepo != null}, baseUrlEmpty=${baseUrl.isEmpty}',
        );
        return;
      }
      _socketLog('trying reconnect with refreshed session token');
      await _createAndConnectSocket(baseUrl: baseUrl);
    } catch (e, st) {
      _socketLog('reconnect with refreshed token failed: $e');
      _logger?.exception(e, st);
    }
  }

  void _socketLog(String message) {
    final String formatted = '[PrivateConversationSocket] $message';
    _logger?.log(formatted);
    // Keep explicit stdout output for macOS desktop diagnostics.
    print(formatted);
  }

  void _socketLogException(Object error, [StackTrace? stackTrace]) {
    final StringBuffer buffer = StringBuffer(
      'exception type=${error.runtimeType}; value=$error',
    );
    if (error is AppException) {
      buffer.write('; message=${error.message}');
      if (error.error != null) {
        buffer.write('; cause=${error.error}');
      }
      if (error.statusCode != null) {
        buffer.write('; statusCode=${error.statusCode}');
      }
      if (error.details != null) {
        buffer.write('; details=${error.details}');
      }
    }
    _socketLog(buffer.toString());
    final StackTrace? traceToLog =
        stackTrace ?? (error is AppException ? error.stackTrace : null);
    if (traceToLog != null) {
      _socketLog('stackTrace:\n$traceToLog');
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
}
