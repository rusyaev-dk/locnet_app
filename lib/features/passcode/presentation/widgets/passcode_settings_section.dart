import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/features/passcode/domain/exceptions/passcode_exceptions.dart';
import 'package:locnet_app/features/passcode/domain/interactors/passcode_interactor.dart';
import 'package:locnet_app/features/passcode/domain/models/passcode_settings.dart';
import 'package:locnet_app/features/passcode/presentation/blocs/passcode_lock_cubit/passcode_lock_cubit.dart';
import 'package:locnet_app/features/passcode/presentation/passcode_constants.dart';
import 'package:locnet_app/features/passcode/presentation/screens/passcode_setup_screen.dart';
import 'package:locnet_app/features/passcode/presentation/widgets/pin_dots.dart';
import 'package:locnet_app/features/passcode/presentation/widgets/pin_input_pad.dart';
import 'package:locnet_app/features/settings/presentation/components/components.dart';
import 'package:locnet_app/features/settings/subfeatures/notifications/presentation/components/notification_switch_tile.dart';

class PasscodeSettingsSection extends StatefulWidget {
  const PasscodeSettingsSection({super.key});

  @override
  State<PasscodeSettingsSection> createState() =>
      _PasscodeSettingsSectionState();
}

class _PasscodeSettingsSectionState extends State<PasscodeSettingsSection> {
  Future<PasscodeSettings>? _settingsFuture;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _settingsFuture ??= context.read<PasscodeInteractor>().getSettings();
  }

  void _refresh() {
    setState(() {
      _settingsFuture = context.read<PasscodeInteractor>().getSettings();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return FutureBuilder<PasscodeSettings>(
      future: _settingsFuture,
      builder: (BuildContext context, AsyncSnapshot<PasscodeSettings> snap) {
        if (snap.connectionState != ConnectionState.done || !snap.hasData) {
          return const SizedBox.shrink();
        }
        final PasscodeSettings settings = snap.data!;

        return SettingsGroupCard(
          title: l10n.passcodeSectionTitle,
          children: [
            NotificationSwitchTile(
              title: l10n.passcodeAppLock,
              value: settings.isEnabled,
              onChanged: (bool enabled) async {
                if (enabled) {
                  final bool? ok = await Navigator.of(context).push<bool>(
                    MaterialPageRoute<bool>(
                      builder: (BuildContext ctx) {
                        return BlocProvider<PasscodeLockCubit>.value(
                          value: context.read<PasscodeLockCubit>(),
                          child: const PasscodeSetupScreen(
                            mode: PasscodeSetupMode.create,
                          ),
                        );
                      },
                    ),
                  );
                  if (ok == true && context.mounted) {
                    _refresh();
                  }
                } else {
                  await _showDisableSheet(context);
                  if (context.mounted) {
                    _refresh();
                  }
                }
              },
            ),
            if (settings.isEnabled) ...[
              SettingsNavTile(
                title: l10n.passcodeLockAfter,
                trailingText: _timeoutLabel(context, settings),
                onTap: () => _showTimeoutPicker(context, settings),
              ),
              SettingsNavTile(
                title: l10n.passcodeChange,
                onTap: () async {
                  final bool? ok = await Navigator.of(context).push<bool>(
                    MaterialPageRoute<bool>(
                      builder: (BuildContext ctx) {
                        return BlocProvider<PasscodeLockCubit>.value(
                          value: context.read<PasscodeLockCubit>(),
                          child: const PasscodeSetupScreen(
                            mode: PasscodeSetupMode.change,
                          ),
                        );
                      },
                    ),
                  );
                  if (ok == true && context.mounted) {
                    _refresh();
                  }
                },
              ),
            ],
          ],
        );
      },
    );
  }

  String _timeoutLabel(BuildContext context, PasscodeSettings settings) {
    final l10n = context.l10n;
    final int? m = settings.timeoutMinutes;
    if (m == null) return l10n.passcodeNever;
    if (m == 0) return l10n.passcodeImmediate;
    if (m == 1) return l10n.passcode1Minute;
    if (m == 5) return l10n.passcode5Minutes;
    if (m == 15) return l10n.passcode15Minutes;
    if (m == 30) return l10n.passcode30Minutes;
    if (m == 60) return l10n.passcode1Hour;
    return l10n.passcodeMinutesCount(m);
  }

  Future<void> _showTimeoutPicker(
    BuildContext context,
    PasscodeSettings current,
  ) async {
    final l10n = context.l10n;
    final PasscodeInteractor interactor = context.read<PasscodeInteractor>();

    final List<({int? minutes, String label})> options =
        <({int? minutes, String label})>[
          (minutes: 0, label: l10n.passcodeImmediate),
          (minutes: 1, label: l10n.passcode1Minute),
          (minutes: 5, label: l10n.passcode5Minutes),
          (minutes: 15, label: l10n.passcode15Minutes),
          (minutes: 30, label: l10n.passcode30Minutes),
          (minutes: 60, label: l10n.passcode1Hour),
          (minutes: null, label: l10n.passcodeNever),
        ];

    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (BuildContext sheetContext) {
        final colorScheme = sheetContext.colorScheme;
        return SafeArea(
          child: ListView(
            shrinkWrap: true,
            children: [
              for (final ({int? minutes, String label}) o in options)
                ListTile(
                  title: Text(o.label),
                  trailing: o.minutes == current.timeoutMinutes
                      ? Icon(Icons.check, color: colorScheme.primary)
                      : null,
                  onTap: () async {
                    Navigator.of(sheetContext).pop();
                    await interactor.updateTimeout(o.minutes);
                    if (context.mounted) {
                      _refresh();
                    }
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _showDisableSheet(BuildContext context) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (BuildContext sheetContext) {
        return BlocProvider<PasscodeLockCubit>.value(
          value: context.read<PasscodeLockCubit>(),
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.viewInsetsOf(sheetContext).bottom,
            ),
            child: _PasscodeDisableBody(
              onDone: () {
                Navigator.of(sheetContext).pop();
              },
            ),
          ),
        );
      },
    );
  }
}

class _PasscodeDisableBody extends StatefulWidget {
  const _PasscodeDisableBody({required this.onDone});

  final VoidCallback onDone;

  @override
  State<_PasscodeDisableBody> createState() => _PasscodeDisableBodyState();
}

class _PasscodeDisableBodyState extends State<_PasscodeDisableBody> {
  String _pin = '';
  String? _error;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = context.colorScheme;
    final textScheme = context.textScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.passcodeDisableTitle,
            style: textScheme.subtitle,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            l10n.passcodeEnterPin,
            textAlign: TextAlign.center,
            style: textScheme.caption.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),
          PinDots(
            length: PasscodeConstants.pinLength,
            filled: _pin.length,
            showError: _error != null,
          ),
          if (_error != null) ...[
            const SizedBox(height: 8),
            Text(
              _error!,
              textAlign: TextAlign.center,
              style: textScheme.caption.copyWith(color: colorScheme.error),
            ),
          ],
          const SizedBox(height: 16),
          PinInputPad(
            onDigit: (int d) => _onDigit(d),
            onBackspace: () {
              if (_pin.isEmpty) return;
              setState(() {
                _pin = _pin.substring(0, _pin.length - 1);
                _error = null;
              });
            },
          ),
        ],
      ),
    );
  }

  Future<void> _onDigit(int d) async {
    if (_pin.length >= PasscodeConstants.pinLength) return;
    setState(() {
      _pin += '$d';
      _error = null;
    });
    if (_pin.length < PasscodeConstants.pinLength) return;

    try {
      await context.read<PasscodeLockCubit>().disablePasscode(_pin);
      if (!mounted) return;
      widget.onDone();
    } on PasscodeWrongPinException {
      if (!mounted) return;
      setState(() {
        _error = context.l10n.passcodeWrongPin;
        _pin = '';
      });
    }
  }
}
