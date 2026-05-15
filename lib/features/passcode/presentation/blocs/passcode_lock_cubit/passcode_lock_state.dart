sealed class PasscodeLockState {
  const PasscodeLockState();
}

/// Passcode off or not applicable for this session.
final class PasscodeLockDisabledState extends PasscodeLockState {
  const PasscodeLockDisabledState();
}

/// Unlocked: correct PIN or timeout not elapsed.
final class PasscodeLockUnlockedState extends PasscodeLockState {
  const PasscodeLockUnlockedState();
}

/// Full-screen lock: PIN required.
final class PasscodeLockLockedState extends PasscodeLockState {
  const PasscodeLockLockedState();
}

/// Wrong PIN; UI may shake and then returns to [PasscodeLockLockedState].
final class PasscodeLockWrongPinState extends PasscodeLockState {
  const PasscodeLockWrongPinState();
}

/// PIN is being verified on the server/storage — stay on lock route.
final class PasscodeLockVerifyingState extends PasscodeLockState {
  const PasscodeLockVerifyingState();
}
