import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:locnet_app/features/passcode/presentation/blocs/passcode_lock_cubit/passcode_lock_cubit.dart';
import 'package:locnet_app/features/passcode/presentation/blocs/passcode_lock_cubit/passcode_lock_state.dart';

/// Listened by [GoRouter.refreshListenable] so redirects run when lock toggles.
final class PasscodeFlowController extends ChangeNotifier {
  PasscodeFlowController({required PasscodeLockCubit cubit}) {
    _isLocked = _blocksPasscodeRoute(cubit.state);
    _subscription = cubit.stream.listen((PasscodeLockState state) {
      final bool locked = _blocksPasscodeRoute(state);
      if (locked != _isLocked) {
        _isLocked = locked;
        notifyListeners();
      }
    });
  }

  /// User must stay on `/passcode-lock` while locked, verifying, or showing wrong PIN.
  static bool _blocksPasscodeRoute(PasscodeLockState state) {
    return state is PasscodeLockLockedState ||
        state is PasscodeLockWrongPinState ||
        state is PasscodeLockVerifyingState;
  }

  late bool _isLocked;
  late final StreamSubscription<PasscodeLockState> _subscription;

  bool get isLocked => _isLocked;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
