import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:locnet_app/features/auth/presentation/presentation.dart';
import 'package:locnet_app/features/passcode/domain/interactors/passcode_interactor.dart';
import 'package:locnet_app/features/passcode/presentation/blocs/passcode_lock_cubit/passcode_lock_state.dart';

class PasscodeLockCubit extends Cubit<PasscodeLockState> {
  PasscodeLockCubit({
    required PasscodeInteractor passcodeInteractor,
    required AuthCubit authCubit,
  }) : _interactor = passcodeInteractor,
       super(const PasscodeLockDisabledState()) {
    _authSubscription = authCubit.stream.listen(_onAuthState);
    _onAuthState(authCubit.state);
  }

  final PasscodeInteractor _interactor;
  late final StreamSubscription<AuthState> _authSubscription;
  bool _authSessionActive = false;

  void _onAuthState(AuthState authState) {
    if (authState is AuthUnauthenticatedState || authState is AuthFailureState) {
      _authSessionActive = false;
      onSessionCleared();
      return;
    }
    if (authState is AuthAuthenticatedState) {
      final bool firstAuth = !_authSessionActive;
      _authSessionActive = true;
      if (firstAuth) {
        unawaited(initialize());
      }
    }
  }

  /// After session restore or login: applies local passcode settings.
  Future<void> initialize() async {
    final settings = await _interactor.getSettings();
    if (!settings.isEnabled) {
      emit(const PasscodeLockDisabledState());
      return;
    }
    final bool shouldLock = await _interactor.shouldLock();
    emit(
      shouldLock
          ? const PasscodeLockLockedState()
          : const PasscodeLockUnlockedState(),
    );
  }

  Future<void> onAppPaused() async {
    final settings = await _interactor.getSettings();
    if (!settings.isEnabled) return;
    await _interactor.saveLastBackgroundTime(DateTime.now());
    if (settings.timeoutMinutes == 0) {
      emit(const PasscodeLockLockedState());
    }
  }

  Future<void> onAppResumed() async {
    if (state is PasscodeLockDisabledState) return;
    final bool shouldLock = await _interactor.shouldLock();
    if (shouldLock) emit(const PasscodeLockLockedState());
  }

  /// Locks immediately when app lock is enabled (e.g. sidebar lock control).
  Future<void> lockNow() async {
    final settings = await _interactor.getSettings();
    if (!settings.isEnabled) return;
    emit(const PasscodeLockLockedState());
  }

  Future<void> unlock(String pin) async {
    emit(const PasscodeLockVerifyingState());
    final bool correct = await _interactor.verifyPasscode(pin);
    emit(
      correct
          ? const PasscodeLockUnlockedState()
          : const PasscodeLockWrongPinState(),
    );
    if (!correct) {
      await Future<void>.delayed(const Duration(milliseconds: 600));
      emit(const PasscodeLockLockedState());
    }
  }

  Future<void> enablePasscode(String pin) async {
    await _interactor.enablePasscode(pin);
    emit(const PasscodeLockUnlockedState());
  }

  Future<void> disablePasscode(String pin) async {
    await _interactor.disablePasscode(pin);
    emit(const PasscodeLockDisabledState());
  }

  /// Session ended — hide lock overlay.
  void onSessionCleared() => emit(const PasscodeLockDisabledState());

  @override
  Future<void> close() {
    _authSubscription.cancel();
    return super.close();
  }
}
