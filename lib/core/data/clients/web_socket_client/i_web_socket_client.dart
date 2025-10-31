// comments must be in English only
import 'dart:async';

abstract class IWebSocketClient {
  /// Incoming messages stream (UTF-8 text frames or your DTOs).
  Stream<String> get messages;

  /// Sends a message to server.
  Future<void> send(String message);

  /// Closes the connection.
  Future<void> close([int? code, String? reason]);

  /// Whether the socket is currently open.
  bool get isConnected;
}
