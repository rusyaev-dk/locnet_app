import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/features/passcode/domain/exceptions/passcode_exceptions.dart';
import 'package:locnet_app/features/passcode/domain/interactors/passcode_interactor.dart';
import 'package:locnet_app/features/passcode/presentation/blocs/passcode_lock_cubit/passcode_lock_cubit.dart';
import 'package:locnet_app/features/passcode/presentation/passcode_constants.dart';
import 'package:locnet_app/uikit/uikit.dart';

enum PasscodeSetupMode { create, change, disable }

class PasscodeSetupScreen extends StatefulWidget {
  const PasscodeSetupScreen({required this.mode, super.key});

  final PasscodeSetupMode mode;

  @override
  State<PasscodeSetupScreen> createState() => _PasscodeSetupScreenState();
}

class _PasscodeSetupScreenState extends State<PasscodeSetupScreen> {
  /// create: 0 = first pin, 1 = confirm. change: 0 = old, 1 = new, 2 = confirm.
  int _step = 0;
  String _firstPin = '';
  String _oldPin = '';
  String? _errorText;
  bool _busy = false;

  final TextEditingController _pinController = TextEditingController();
  final FocusNode _pinFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _pinFocus.requestFocus();
      }
    });
  }

  @override
  void dispose() {
    _pinController.dispose();
    _pinFocus.dispose();
    super.dispose();
  }

  void _advanceStepOrClearField() {
    _pinController.clear();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _pinFocus.requestFocus();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = context.colorScheme;
    final textScheme = context.textScheme;

    final String stepInstruction = switch (widget.mode) {
      PasscodeSetupMode.create when _step == 0 => l10n.passcodeEnterPin,
      PasscodeSetupMode.create => l10n.passcodeConfirmPin,
      PasscodeSetupMode.change when _step == 0 => l10n.passcodeCurrentPin,
      PasscodeSetupMode.change when _step == 1 => l10n.passcodeEnterPin,
      PasscodeSetupMode.change => l10n.passcodeConfirmPin,
      PasscodeSetupMode.disable => l10n.passcodeCurrentPin,
    };

    final String screenTitle = switch (widget.mode) {
      PasscodeSetupMode.create => l10n.passcodeSetupTitle,
      PasscodeSetupMode.change => l10n.passcodeChangeTitle,
      PasscodeSetupMode.disable => l10n.passcodeDisableTitle,
    };

    return Scaffold(
          backgroundColor: colorScheme.surface,
          body: SafeArea(
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 40,
                  ),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight - 80,
                    ),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 400),
                        child: Container(
                          decoration: BoxDecoration(
                            color: colorScheme.secondary,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: colorScheme.outline),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withAlpha(60),
                                blurRadius: 40,
                                offset: const Offset(0, 20),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                  16,
                                  8,
                                  8,
                                  0,
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          left: 8,
                                        ),
                                        child: Text(
                                          screenTitle,
                                          style: textScheme.title.copyWith(
                                            fontWeight: FontWeight.w600,
                                            color: colorScheme.onSurface,
                                          ),
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.close),
                                      onPressed: _busy
                                          ? null
                                          : () => Navigator.of(context)
                                              .pop(false),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                  24,
                                  20,
                                  24,
                                  0,
                                ),
                                child: Text(
                                  stepInstruction,
                                  style: textScheme.body.copyWith(
                                    color: colorScheme.onSurfaceVariant,
                                    height: 1.35,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                  24,
                                  20,
                                  24,
                                  24,
                                ),
                                child: CustomTextField(
                                  controller: _pinController,
                                  focusNode: _pinFocus,
                                  labelText: l10n.passcodeEnterPin,
                                  obscureText: true,
                                  isActive: !_busy,
                                  keyboardType: TextInputType.number,
                                  textInputAction: TextInputAction.done,
                                  extraInputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(
                                      PasscodeConstants.pinLength,
                                    ),
                                  ],
                                  errorText: _errorText,
                                  onChanged: (String? value) {
                                    final String v = value ?? '';
                                    if (_errorText != null && v.isNotEmpty) {
                                      setState(() => _errorText = null);
                                    }
                                    setState(() {});
                                    if (v.length ==
                                        PasscodeConstants.pinLength) {
                                      _submitPin(context, v);
                                    }
                                  },
                                  onSubmitted: (String? value) => _submitPin(
                                    context,
                                    value ?? _pinController.text,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
  }

  Future<void> _submitPin(BuildContext context, String pin) async {
    if (pin.length != PasscodeConstants.pinLength || _busy) return;

    switch (widget.mode) {
      case PasscodeSetupMode.create:
        await _handleCreate(context, pin);
      case PasscodeSetupMode.change:
        await _handleChange(context, pin);
      case PasscodeSetupMode.disable:
        await _handleDisable(context, pin);
    }
  }

  Future<void> _handleDisable(BuildContext context, String pin) async {
    setState(() => _busy = true);
    try {
      final PasscodeLockCubit cubit = context.read<PasscodeLockCubit>();
      await cubit.disablePasscode(pin);
      if (!context.mounted) return;
      Navigator.of(context).pop(true);
    } on PasscodeWrongPinException {
      if (!context.mounted) return;
      setState(() {
        _errorText = context.l10n.passcodeWrongPin;
      });
      _pinController.clear();
      _pinFocus.requestFocus();
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _handleCreate(BuildContext context, String pin) async {
    if (_step == 0) {
      setState(() {
        _firstPin = pin;
        _step = 1;
        _errorText = null;
      });
      _advanceStepOrClearField();
      return;
    }

    if (pin != _firstPin) {
      if (!mounted) return;
      final String mismatch = context.l10n.passcodePinsMismatch;
      setState(() {
        _errorText = mismatch;
        _step = 0;
        _firstPin = '';
      });
      _pinController.clear();
      _pinFocus.requestFocus();
      return;
    }

    setState(() => _busy = true);
    try {
      final PasscodeLockCubit cubit = context.read<PasscodeLockCubit>();
      await cubit.enablePasscode(pin);
      if (!context.mounted) return;
      Navigator.of(context).pop(true);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _handleChange(BuildContext context, String pin) async {
    final PasscodeInteractor interactor = context.read<PasscodeInteractor>();

    if (_step == 0) {
      setState(() => _busy = true);
      try {
        final bool ok = await interactor.verifyPasscode(pin);
        if (!context.mounted) return;
        if (!ok) {
          final String wrong = context.l10n.passcodeWrongPin;
          setState(() {
            _errorText = wrong;
          });
          _pinController.clear();
          _pinFocus.requestFocus();
          return;
        }
        setState(() {
          _oldPin = pin;
          _step = 1;
          _errorText = null;
        });
        _advanceStepOrClearField();
      } finally {
        if (mounted) setState(() => _busy = false);
      }
      return;
    }

    if (_step == 1) {
      setState(() {
        _firstPin = pin;
        _step = 2;
        _errorText = null;
      });
      _advanceStepOrClearField();
      return;
    }

    if (pin != _firstPin) {
      if (!mounted) return;
      final String mismatch = context.l10n.passcodePinsMismatch;
      setState(() {
        _errorText = mismatch;
        _step = 1;
        _firstPin = '';
      });
      _pinController.clear();
      _pinFocus.requestFocus();
      return;
    }

    setState(() => _busy = true);
    try {
      try {
        await interactor.changePasscode(_oldPin, pin);
      } on PasscodeWrongPinException {
        if (!context.mounted) return;
        final String wrong = context.l10n.passcodeWrongPin;
        setState(() {
          _errorText = wrong;
          _step = 0;
          _firstPin = '';
          _oldPin = '';
        });
        _pinController.clear();
        _pinFocus.requestFocus();
        return;
      }
      if (!context.mounted) return;
      Navigator.of(context).pop(true);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }
}
