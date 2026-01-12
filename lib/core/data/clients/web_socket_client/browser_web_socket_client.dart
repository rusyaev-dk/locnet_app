import 'dart:async';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/html.dart';
import 'package:locnet_app/core/core.dart';

final class BrowserWebSocketClient implements IWebSocketClient {
  BrowserWebSocketClient({required Uri uri, List<String>? protocols})
    : _uri = uri,
      _protocols = protocols,
      _messagesController = StreamController<String>.broadcast();

  final Uri _uri;
  final List<String>? _protocols;

  final StreamController<String> _messagesController;
  WebSocketChannel? _channel;
  StreamSubscription<dynamic>? _subscription;
  bool _connected = false;

  @override
  bool get isConnected => _connected;

  @override
  Stream<String> get messages => _messagesController.stream;

  /// Establishes the connection to WebSocket endpoint (browser).
  /// Notes:
  /// - Custom headers are not supported by browser WebSocket API.
  /// - Ping/pong is handled by the server; the browser does not expose ping timers.
  Future<void> connect() async {
    if (_connected) return;

    try {
      final HtmlWebSocketChannel channel = HtmlWebSocketChannel.connect(
        _uri.toString(),
        protocols: _protocols,
      );

      _channel = channel;

      _subscription = channel.stream.listen(
        (dynamic data) {
          if (data is String) {
            _messagesController.add(data);
          } else {
            // Convert binary frames if your server sends them.
          }
        },
        onError: (Object error, StackTrace stackTrace) {
          _messagesController.addError(error, stackTrace);
        },
        onDone: () {
          _connected = false;
          // Keep controller open to allow reconnect + same stream subscribers.
        },
        cancelOnError: true,
      );

      _connected = true;
    } catch (error) {
      _connected = false;
      rethrow;
    }
  }

  @override
  Future<void> send(String message) async {
    if (!_connected || _channel == null) {
      throw StateError('WebSocket is not connected');
    }
    _channel!.sink.add(message);
  }

  @override
  Future<void> close([int? code, String? reason]) async {
    try {
      await _subscription?.cancel();
      await _channel?.sink.close(code, reason);
    } catch (_) {
      // Swallow close errors to keep shutdown simple.
    } finally {
      _connected = false;
      _subscription = null;
      _channel = null;
    }
  }

  /// Disposes the broadcast controller (e.g., on app shutdown).
  Future<void> dispose() async {
    await close(1000, 'Dispose');
    await _messagesController.close();
  }
}
