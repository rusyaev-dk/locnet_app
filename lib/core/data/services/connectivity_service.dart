import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

abstract interface class IConnectivityService {
  /// Emits true when the device has any network access, false otherwise.
  Stream<bool> get onConnectivityChanged;

  /// Returns the current connectivity status immediately.
  Future<bool> get isConnected;

  void dispose();
}

/// Reports whether the remote server (socket) is reachable.
/// Populated by socket repositories calling [reportConnected] / [reportError].
abstract interface class IServerConnectivityService {
  /// Emits true when a socket connects, false when it fails to connect.
  Stream<bool> get onStatusChanged;

  /// Call from a socket repo when the connection is established or restored.
  void reportConnected();

  /// Call from a socket repo when a connection attempt fails.
  void reportError();

  void dispose();
}

final class ServerConnectivityService implements IServerConnectivityService {
  final StreamController<bool> _controller =
      StreamController<bool>.broadcast();

  @override
  Stream<bool> get onStatusChanged => _controller.stream;

  @override
  void reportConnected() {
    if (!_controller.isClosed) _controller.add(true);
  }

  @override
  void reportError() {
    if (!_controller.isClosed) _controller.add(false);
  }

  @override
  void dispose() => _controller.close();
}

final class ConnectivityService implements IConnectivityService {
  ConnectivityService() {
    _subscription = Connectivity()
        .onConnectivityChanged
        .map(_hasConnection)
        .distinct()
        .listen(_controller.add);
  }

  final StreamController<bool> _controller =
      StreamController<bool>.broadcast();
  StreamSubscription<bool>? _subscription;

  @override
  Stream<bool> get onConnectivityChanged => _controller.stream;

  @override
  Future<bool> get isConnected async {
    final results = await Connectivity().checkConnectivity();
    return _hasConnection(results);
  }

  bool _hasConnection(List<ConnectivityResult> results) =>
      results.any((ConnectivityResult r) => r != ConnectivityResult.none);

  @override
  void dispose() {
    _subscription?.cancel();
    _controller.close();
  }
}
