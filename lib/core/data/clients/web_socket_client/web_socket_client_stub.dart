import 'package:locnet_app/core/core.dart';

final class WebSocketClientStub implements IWebSocketClient {
  @override
  bool get isConnected => false;

  @override
  Stream<String> get messages => const Stream<String>.empty();

  @override
  Future<void> send(String message) async {
    throw UnsupportedError('WebSocketClient is not available on this platform');
  }

  @override
  Future<void> close([int? code, String? reason]) async {}
}
