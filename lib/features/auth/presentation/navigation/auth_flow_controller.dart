import 'dart:async';

import 'package:flutter/material.dart';
import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/auth/presentation/presentation.dart';

enum AuthFlowStatus {
  unknown, // app just started
  loading, // fetching Telegram initData / session
  authenticated, // have valid session and user
  unauthenticated, // no session; user must register
}

final class AuthFlowController extends ChangeNotifier {
  AuthFlowController({
    required AuthCubit authCubit,
    required UnauthorizedEventBus unauthorizedEventBus,
  }) : _authCubit = authCubit {
    _status = _mapStateToStatus(_authCubit.state);
    _subscription = _authCubit.stream.listen((newState) {
      final AuthFlowStatus next = _mapStateToStatus(newState);
      if (next != _status) {
        _status = next;
        notifyListeners();
      }
    });
    _unauthorizedSubscription = unauthorizedEventBus.stream.listen((_) {
      _handleUnauthorizedEvent();
    });
  }

  final AuthCubit _authCubit;
  late final StreamSubscription<AuthState> _subscription;
  late final StreamSubscription<void> _unauthorizedSubscription;
  late AuthFlowStatus _status;
  bool _isHandlingUnauthorized = false;

  AuthFlowStatus get status => _status;

  AuthFlowStatus _mapStateToStatus(AuthState state) {
    if (state is AuthInitialState) {
      return AuthFlowStatus.unknown;
    }
    if (state is AuthLoadingState) {
      return AuthFlowStatus.loading;
    }
    if (state is AuthAuthenticatedState) {
      return AuthFlowStatus.authenticated;
    }
    if (state is AuthUnauthenticatedState || state is AuthFailureState) {
      return AuthFlowStatus.unauthenticated;
    }
    return AuthFlowStatus.unknown;
  }

  void _handleUnauthorizedEvent() {
    if (_status == AuthFlowStatus.unauthenticated || _isHandlingUnauthorized) {
      return;
    }

    _isHandlingUnauthorized = true;
    _authCubit.logOut().whenComplete(() {
      _isHandlingUnauthorized = false;
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    _unauthorizedSubscription.cancel();
    super.dispose();
  }
}
