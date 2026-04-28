import 'dart:async';

import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/auth/data/data.dart';
import 'package:locnet_app/features/conversations_list/data/data.dart';
import 'package:locnet_app/features/conversations_list/domain/models/conversation_tile.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class HttpConversationsListRepo implements IConversationsListRepo {
  HttpConversationsListRepo({
    required IHttpClient httpClient,
    ISessionCacheRepo? sessionCacheRepo,
    ILogger? logger,
    String? socketBaseUrl,
  }) : _httpClient = httpClient,
       _sessionCacheRepo = sessionCacheRepo,
       _logger = logger,
       _socketBaseUrl = socketBaseUrl;

  final IHttpClient _httpClient;
  final ISessionCacheRepo? _sessionCacheRepo;
  final ILogger? _logger;
  final String? _socketBaseUrl;
  io.Socket? _socket;
  bool _isSocketConnecting = false;
  final StreamController<ConversationsListUpdateRec> _updatesController =
      StreamController<ConversationsListUpdateRec>.broadcast();

  @override
  Stream<ConversationsListUpdateRec> get conversationsUpdates {
    _tryConnectSocket();
    return _updatesController.stream;
  }

  @override
  Future<List<ConversationTile>> loadConversationsList({int page = 1}) async {
    try {
      final int safePage = page <= 0 ? 1 : page;
      final httpResponse = await _httpClient.get(
        path: ApiEndpoints.conversationsList,
        uriParameters: <String, dynamic>{'page': safePage.toString()},
      );

      final dynamic responseData = httpResponse.data;
      if (responseData is! Map<String, dynamic>) {
        throw AppUnknownException(
          message: 'Invalid API response format',
          error: responseData,
          stackTrace: StackTrace.current,
        );
      }

      final Map<String, dynamic> responseJson = responseData;
      final dynamic rawTiles = responseJson['tiles'] ?? responseJson['conversations'];
      if (rawTiles is! List) {
        return <ConversationTile>[];
      }

      final List<ConversationTile> conversations = <ConversationTile>[];
      for (final dynamic conversationRaw in rawTiles) {
        if (conversationRaw is! Map<String, dynamic>) {
          continue;
        }

        final Map<String, dynamic>? normalizedTile = _normalizeTilePayload(
          conversationRaw,
        );
        if (normalizedTile == null) {
          continue;
        }
        final ConversationTileDto conversationDto = ConversationTileDto.fromJson(
          normalizedTile,
        );
        conversations.add(ConversationTile.fromDto(conversationDto));
      }

      return conversations;
    } on AppException {
      rethrow;
    } catch (e, st) {
      throw AppUnknownException(
        message: 'Failed to load conversations list',
        error: e,
        stackTrace: st,
      );
    }
  }

  void _tryConnectSocket() {
    if (_socket?.connected ?? false) {
      return;
    }

    if (_isSocketConnecting) {
      return;
    }

    final String? baseUrl = _socketBaseUrl;
    if (baseUrl == null || baseUrl.isEmpty || _sessionCacheRepo == null) {
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
        ..setTransports(<String>['websocket'])
        ..disableAutoConnect()
        ..setAuth(<String, dynamic>{'token': token})
        ..enableReconnection()
        ..setReconnectionAttempts(999999)
        ..setReconnectionDelay(1000);

      final io.Socket socket = io.io(baseUrl, options.build())
        ..on('private_conversation_upsert', (dynamic payload) {
          unawaited(_emitConversationUpsert(payload));
        })
        ..on('new_private_message', (dynamic payload) {
          unawaited(_emitNewPrivateMessage(payload));
        })
        ..onConnectError((dynamic error) {
          _logger?.warning('Conversations socket connect error: $error');
          if (error.toString().toLowerCase().contains('jwt expired')) {
            _tryReconnectWithFreshSessionToken();
          }
          _updatesController.addError(
            AppUnknownException(
              message: 'Conversations socket connect error: $error',
            ),
          );
        })
        ..onError((dynamic error) {
          _logger?.warning('Conversations socket error: $error');
          _updatesController.addError(
            AppUnknownException(message: 'Conversations socket error: $error'),
          );
        })
        ..connect();
      _socket = socket;
    } catch (e, st) {
      _logger?.exception(e, st);
      _updatesController.addError(
        e is AppException
            ? e
            : AppUnknownException(
                message: 'Failed to initialize conversations list socket',
                error: e,
                stackTrace: st,
              ),
      );
    }
  }

  Future<void> _emitConversationUpsert(dynamic payload) async {
    try {
      if (payload is! Map) {
        return;
      }

      final Map<String, dynamic> payloadMap = Map<String, dynamic>.from(payload);
      final String conversationId = (payloadMap['conversationId'] ?? '').toString();
      if (conversationId.isEmpty) {
        return;
      }

      final bool isDeleted = payloadMap['isDeleted'] == true;
      final DateTime now = DateTime.now().toUtc();
      final DateTime updatedAt =
          _tryParseDate(payloadMap['updatedAt']) ??
          _tryParseDate(payloadMap['createdAt']) ??
          now;

      final ConversationTile tile =
          await _fetchConversationTileById(conversationId) ??
          ConversationTile(
            id: conversationId,
            type: ConversationTileType.private,
            title: 'Private chat',
            updatedAt: updatedAt,
          );

      _updatesController.add((
        updateType: isDeleted
            ? ConversationTileUpdateType.deleted
            : ConversationTileUpdateType.updated,
        conversationTile: tile,
      ));
    } catch (e, st) {
      _logger?.exception(e, st);
    }
  }

  Future<void> _emitNewPrivateMessage(dynamic payload) async {
    try {
      if (payload is! Map) {
        return;
      }

      final Map<String, dynamic> payloadMap = Map<String, dynamic>.from(payload);
      final String conversationId = (payloadMap['conversationId'] ?? '').toString();
      if (conversationId.isEmpty) {
        return;
      }

      final DateTime now = DateTime.now().toUtc();
      final DateTime updatedAt =
          _tryParseDate(payloadMap['conversationUpdatedAt']) ??
          _tryParseDate(payloadMap['updatedAt']) ??
          _tryParseDate(payloadMap['createdAt']) ??
          now;

      final DateTime? lastMessageAt =
          _tryParseDate(payloadMap['createdAt']) ?? _tryParseDate(payloadMap['updatedAt']);

      final ConversationTile? serverTile = await _fetchConversationTileById(
        conversationId,
      );
      final ConversationTile tile = serverTile != null
          ? serverTile.copyWith(
              lastMessageText:
                  _nonEmptyString(payloadMap['text']) ?? serverTile.lastMessageText,
              lastMessageSenderId:
                  _nonEmptyString(payloadMap['senderId']) ??
                  serverTile.lastMessageSenderId,
              lastMessageAt: lastMessageAt ?? serverTile.lastMessageAt,
              updatedAt: updatedAt,
            )
          : ConversationTile(
              id: conversationId,
              type: ConversationTileType.private,
              title: 'Private chat',
              lastMessageText: _nonEmptyString(payloadMap['text']),
              lastMessageSenderId: _nonEmptyString(payloadMap['senderId']),
              lastMessageAt: lastMessageAt,
              updatedAt: updatedAt,
            );

      _updatesController.add((
        updateType: ConversationTileUpdateType.updated,
        conversationTile: tile,
      ));
    } catch (e, st) {
      _logger?.exception(e, st);
    }
  }

  Future<void> _tryReconnectWithFreshSessionToken() async {
    try {
      final String? baseUrl = _socketBaseUrl;
      if (_sessionCacheRepo == null || baseUrl == null) {
        return;
      }
      await _createAndConnectSocket(baseUrl: baseUrl);
    } catch (e, st) {
      _logger?.exception(e, st);
    }
  }

  DateTime? _tryParseDate(Object? raw) {
    if (raw == null) {
      return null;
    }
    if (raw is DateTime) {
      return raw;
    }
    if (raw is int) {
      return DateTimeFormatter.parse(raw).toUtc();
    }
    if (raw is! String) {
      return null;
    }

    final String candidate = raw.trim();
    if (candidate.isEmpty) {
      return null;
    }

    try {
      return DateTimeFormatter.parse(candidate).toUtc();
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
      return DateTime.parse(isoLike).toUtc();
    } catch (_) {
      return null;
    }
  }

  String? _nonEmptyString(Object? raw) {
    if (raw is! String) {
      return null;
    }
    final String value = raw.trim();
    return value.isEmpty ? null : value;
  }

  Future<ConversationTile?> _fetchConversationTileById(String conversationId) async {
    try {
      final httpResponse = await _httpClient.get(
        path: ApiEndpoints.conversationsList,
        uriParameters: <String, dynamic>{
          'page': '1',
          'limit': '100',
        },
      );

      final dynamic responseData = httpResponse.data;
      if (responseData is! Map<String, dynamic>) {
        return null;
      }

      final dynamic rawTiles = responseData['tiles'] ?? responseData['conversations'];
      if (rawTiles is! List) {
        return null;
      }

      for (final dynamic tileRaw in rawTiles) {
        if (tileRaw is! Map<String, dynamic>) {
          continue;
        }
        final Map<String, dynamic>? normalizedTile = _normalizeTilePayload(tileRaw);
        if (normalizedTile == null) {
          continue;
        }
        if (normalizedTile['id'] != conversationId) {
          continue;
        }
        return ConversationTile.fromDto(ConversationTileDto.fromJson(normalizedTile));
      }
    } catch (e, st) {
      _logger?.exception(e, st);
    }

    return null;
  }

  Map<String, dynamic>? _normalizeTilePayload(Map<String, dynamic> raw) {
    final String id = _nonEmptyString(raw['id']) ??
        _nonEmptyString(raw['conversationId']) ??
        '';
    if (id.isEmpty) {
      return null;
    }

    final DateTime now = DateTime.now().toUtc();
    final DateTime updatedAt =
        _tryParseDate(raw['updatedAt']) ?? _tryParseDate(raw['createdAt']) ?? now;
    final DateTime? lastMessageAt = _tryParseDate(raw['lastMessageAt']);

    final dynamic companionRaw = raw['companion'];
    final Map<String, dynamic>? normalizedCompanion =
        companionRaw is Map<String, dynamic>
        ? _normalizeCompanionPayload(companionRaw)
        : null;

    String title = _nonEmptyString(raw['title']) ?? '';
    if (title.isEmpty && normalizedCompanion != null) {
      final String firstName = _nonEmptyString(normalizedCompanion['firstName']) ?? '';
      final String lastName = _nonEmptyString(normalizedCompanion['lastName']) ?? '';
      final String fullName = '$firstName $lastName'.trim();
      title = fullName.isNotEmpty ? fullName : 'Private chat';
    } else if (title.isEmpty) {
      title = 'Private chat';
    }

    return <String, dynamic>{
      'id': id,
      'type': _nonEmptyString(raw['type']) ?? 'private',
      'title': title,
      'description': _nonEmptyString(raw['description']),
      'lastMessageText': _nonEmptyString(raw['lastMessageText']),
      'lastMessageSenderId': _nonEmptyString(raw['lastMessageSenderId']),
      'lastMessageAt': lastMessageAt?.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'companion': normalizedCompanion,
    };
  }

  Map<String, dynamic>? _normalizeCompanionPayload(Map<String, dynamic> raw) {
    final String id = _nonEmptyString(raw['id']) ?? _nonEmptyString(raw['userId']) ?? '';
    if (id.isEmpty) {
      return null;
    }

    final DateTime now = DateTime.now().toUtc();
    final DateTime createdAt = _tryParseDate(raw['createdAt']) ?? now;
    final DateTime updatedAt = _tryParseDate(raw['updatedAt']) ?? createdAt;

    return <String, dynamic>{
      'id': id,
      'username': _nonEmptyString(raw['username']) ?? '',
      'firstName': _nonEmptyString(raw['firstName']) ?? '',
      'lastName': _nonEmptyString(raw['lastName']) ?? '',
      'patronymic': _nonEmptyString(raw['patronymic']),
      'languageCode': _nonEmptyString(raw['languageCode']) ?? 'en',
      'description': _nonEmptyString(raw['description']),
      'avatarId': _nonEmptyString(raw['avatarId']),
      'isDeleted': raw['isDeleted'] == true,
      'isBanned': raw['isBanned'] == true,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
