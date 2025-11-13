// comments must be in English only
import 'dart:async';
import 'dart:convert';

import 'package:locnet_app/core/core.dart';

final class MockWebSocketClient implements IWebSocketClient {
  MockWebSocketClient()
    : _messagesController = StreamController<String>.broadcast();

  final StreamController<String> _messagesController;

  bool _connected = false;

  @override
  bool get isConnected => _connected;

  @override
  Stream<String> get messages => _messagesController.stream;

  @override
  Future<void> send(String message) async {
    if (!_connected) {
      throw StateError('WebSocket is not connected');
    }

    // Decode message to understand what client requests.
    final Map<String, dynamic> decoded =
        jsonDecode(message) as Map<String, dynamic>;

    final String? type = decoded['type'] as String?;
    final Map<String, dynamic> payload =
        decoded['payload'] as Map<String, dynamic>? ?? <String, dynamic>{};

    if (type == 'feed.list') {
      final int page = payload['page'] as int? ?? 1;
      final int limit = payload['limit'] as int? ?? 20;

      final List<Map<String, dynamic>> items = _buildFakeConversations(
        page: page,
        limit: limit,
      );

      // Simulate asynchronous response from server
      await Future<void>.delayed(const Duration(milliseconds: 120));

      final Map<String, dynamic> response = <String, dynamic>{
        'type': 'feed.list.result',
        'payload': <String, dynamic>{'page': page, 'items': items},
      };

      _messagesController.add(jsonEncode(response));
    }
  }

  @override
  Future<void> close([int? code, String? reason]) async {
    if (!_connected) return;
    _connected = false;
    await _messagesController.close();
  }

  /// Connects the mock socket (no real networking).
  Future<void> connect() async {
    _connected = true;
  }

  List<Map<String, dynamic>> _buildFakeConversations({
    required int page,
    required int limit,
  }) {
    final List<Map<String, dynamic>> items = <Map<String, dynamic>>[];
    final int baseIndex = (page - 1) * limit;

    for (int index = 0; index < limit; index++) {
      final int conversationIndex = baseIndex + index + 1;

      items.add(<String, dynamic>{
        'id': 'conversation_$conversationIndex',
        'title': 'Conversation #$conversationIndex',
        'lastMessagePreview':
            'Last message for conversation #$conversationIndex',
        'unreadCount': conversationIndex % 4,
      });
    }

    return items;
  }
}
