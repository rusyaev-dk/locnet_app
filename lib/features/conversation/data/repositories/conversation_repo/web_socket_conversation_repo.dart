import 'dart:async';
import 'dart:convert';

import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/conversation/data/data.dart';
import 'package:locnet_app/features/conversation/domain/domain.dart';

final class WebSocketConversationRepo implements IConversationRepo {
  WebSocketConversationRepo({
    required IWebSocketClient webSocketClient,
    required ILogger logger,
  }) : _webSocketClient = webSocketClient,
       _logger = logger {
    _listenToIncomingMessages();
  }

  final IWebSocketClient _webSocketClient;
  final ILogger _logger;

  static const int _defaultLimit = 20;

  // Internal controller with DTO
  final StreamController<({ConversationUpdateType kind, ConversationDTO dto})>
  _changesController =
      StreamController<
        ({ConversationUpdateType kind, ConversationDTO dto})
      >.broadcast();

  @override
  Stream<ConversationsUpdateRec> get conversationsUpdates =>
      _changesController.stream.map(
        (({ConversationUpdateType kind, ConversationDTO dto}) event) =>
            (kind: event.kind, conversation: Conversation.fromDTO(event.dto)),
      );

  @override
  Future<List<Conversation>> loadConversations({int page = 1}) async {
    try {
      await _ensureConnected();

      final Map<String, dynamic> request = <String, dynamic>{
        'type': 'feed.list',
        'payload': <String, dynamic>{'page': page, 'limit': _defaultLimit},
      };

      await _webSocketClient.send(jsonEncode(request));

      final String responseJson = await _webSocketClient.messages.firstWhere((
        String rawMessage,
      ) {
        final Map<String, dynamic> decoded =
            jsonDecode(rawMessage) as Map<String, dynamic>;
        return decoded['type'] == 'feed.list.result';
      });

      final Map<String, dynamic> decodedResponse =
          jsonDecode(responseJson) as Map<String, dynamic>;

      final Map<String, dynamic> payload =
          decodedResponse['payload'] as Map<String, dynamic>? ??
          <String, dynamic>{};

      final List<dynamic> rawItems =
          payload['items'] as List<dynamic>? ?? <dynamic>[];

      final List<ConversationDTO> dtoItems = rawItems
          .map(
            (dynamic raw) =>
                ConversationDTO.fromJson(raw as Map<String, dynamic>),
          )
          .toList();

      final List<Conversation> conversations = dtoItems
          .map((ConversationDTO dto) => Conversation.fromDTO(dto))
          .toList();

      return conversations;
    } catch (error, stackTrace) {
      _logger.exception(error, stackTrace);

      throw AppUnknownException(
        message: 'Failed to load conversations from WebSocket',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  @override
  Future<bool> toggleNotifications({
    required String conversationId,
    required bool newNotificationsStatus,
  }) async {
    throw UnimplementedError('toggleNotifications is not implemented yet');
  }

  void _listenToIncomingMessages() {
    _webSocketClient.messages.listen(
      (String rawMessage) {
        try {
          final Map<String, dynamic> decoded =
              jsonDecode(rawMessage) as Map<String, dynamic>;

          final String? messageType = decoded['type'] as String?;

          if (messageType == null) {
            return;
          }

          ConversationUpdateType? kind;

          switch (messageType) {
            case 'conversation.created':
              kind = ConversationUpdateType.created;
              break;
            case 'conversation.updated':
              kind = ConversationUpdateType.updated;
              break;
            case 'conversation.deleted':
              kind = ConversationUpdateType.deleted;
              break;
            default:
              break;
          }

          if (kind == null) {
            return;
          }

          final Map<String, dynamic> payload =
              decoded['payload'] as Map<String, dynamic>;

          final ConversationDTO dto = ConversationDTO.fromJson(payload);

          _changesController.add((kind: kind, dto: dto));
        } catch (error, stackTrace) {
          _logger.exception(error, stackTrace);
        }
      },
      onError: (Object error, StackTrace stackTrace) {
        _logger.exception(error, stackTrace);
      },
    );
  }

  Future<void> _ensureConnected() async {
    if (_webSocketClient.isConnected) {
      return;
    }

    if (_webSocketClient is MockWebSocketClient) {
      final MockWebSocketClient mockClient = _webSocketClient;
      await mockClient.connect();
    }
  }

  Future<void> dispose() async {
    await _changesController.close();
  }
}
