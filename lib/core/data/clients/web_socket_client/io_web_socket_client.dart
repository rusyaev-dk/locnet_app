import 'dart:async';
import 'package:locnet_app/core/core.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

final class IoWebSocketClient implements IWebSocketClient {
  IoWebSocketClient({
    required Uri uri,
    Map<String, dynamic /* String|Iterable<String> */>? headers,
    Duration? pingInterval,
  }) : _uri = uri,
       _headers = headers,
       _pingInterval = pingInterval,
       _messagesController = StreamController<String>.broadcast();

  final Uri _uri;
  final Map<String, dynamic /* String|Iterable<String> */>? _headers;
  final Duration? _pingInterval;

  final StreamController<String> _messagesController;
  WebSocketChannel? _channel;
  StreamSubscription<dynamic>? _subscription;
  bool _connected = false;

  @override
  bool get isConnected => _connected;

  @override
  Stream<String> get messages => _messagesController.stream;

  /// Establishes the WebSocket connection if not already connected.
  Future<void> connect() async {
    if (_connected) return;

    try {
      final IOWebSocketChannel channel = IOWebSocketChannel.connect(
        _uri.toString(),
        headers: _headers,
        pingInterval: _pingInterval,
      );

      _channel = channel;

      _subscription = channel.stream.listen(
        (dynamic data) {
          if (data is String) {
            _messagesController.add(data);
          } else {
            // Convert binary frames if needed.
          }
        },
        onError: (Object error, StackTrace stackTrace) {
          _messagesController.addError(error, stackTrace);
        },
        onDone: () {
          _connected = false;
          // Keep controller open to allow reconnect while keeping the same stream.
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
    try {
      if (!_connected || _channel == null) {
        throw StateError('WebSocket is not connected');
      }
      _channel!.sink.add(message);
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<void> close([int? code, String? reason]) async {
    try {
      await _subscription?.cancel();
      await _channel?.sink.close(code, reason);
    } catch (error) {
      // Intentionally ignore close errors; rethrow if you prefer strict handling.
    } finally {
      _connected = false;
      _subscription = null;
      _channel = null;
    }
  }

  /// Disposes internal resources (e.g., on application shutdown).
  Future<void> dispose() async {
    await close(1000, 'Dispose');
    await _messagesController.close();
  }
}
