class PasscodeSettings {
  const PasscodeSettings({
    required this.isEnabled,
    required this.timeoutMinutes, // 0 = immediately, null = never
  });

  final bool isEnabled;

  /// `null` means «never lock by timeout» (PIN only when opening the app).
  final int? timeoutMinutes;

  static const PasscodeSettings disabled = PasscodeSettings(
    isEnabled: false,
    timeoutMinutes: null,
  );
}
