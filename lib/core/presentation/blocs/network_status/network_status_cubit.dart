import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locnet_app/core/data/services/connectivity_service.dart';

enum NetworkStatus {
  /// Device internet is available and server socket is reachable.
  online,

  /// Device has no internet access.
  offline,

  /// Device has internet, but the server socket cannot be reached.
  serverUnreachable,
}

final class NetworkStatusCubit extends Cubit<NetworkStatus> {
  NetworkStatusCubit({
    required IConnectivityService connectivityService,
    required IServerConnectivityService serverConnectivityService,
  }) : super(NetworkStatus.online) {
    _init(connectivityService, serverConnectivityService);
  }

  StreamSubscription<bool>? _deviceSub;
  StreamSubscription<bool>? _serverSub;

  bool _deviceConnected = true;
  bool _serverReachable = true;

  Future<void> _init(
    IConnectivityService deviceService,
    IServerConnectivityService serverService,
  ) async {
    _deviceConnected = await deviceService.isConnected;
    _emitStatus();

    _deviceSub = deviceService.onConnectivityChanged.listen((bool connected) {
      _deviceConnected = connected;
      _emitStatus();
    });

    _serverSub = serverService.onStatusChanged.listen((bool reachable) {
      _serverReachable = reachable;
      _emitStatus();
    });
  }

  void _emitStatus() {
    if (isClosed) return;
    if (!_deviceConnected) {
      emit(NetworkStatus.offline);
    } else if (!_serverReachable) {
      emit(NetworkStatus.serverUnreachable);
    } else {
      emit(NetworkStatus.online);
    }
  }

  @override
  Future<void> close() {
    _deviceSub?.cancel();
    _serverSub?.cancel();
    return super.close();
  }
}
