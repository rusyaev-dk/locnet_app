import 'dart:async';

final class UnauthorizedEventBus {
  UnauthorizedEventBus();

  final StreamController<void> _controller = StreamController<void>.broadcast();

  Stream<void> get stream => _controller.stream;

  void emit() {
    _controller.add(null);
  }

  void dispose() {
    _controller.close();
  }
}
