import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/passcode/domain/interactors/passcode_interactor.dart';
import 'package:locnet_app/features/passcode/domain/models/passcode_settings.dart';
import 'package:locnet_app/features/passcode/presentation/blocs/passcode_lock_cubit/passcode_lock_cubit.dart';
import 'package:locnet_app/features/passcode/presentation/screens/passcode_setup_screen.dart';
import 'package:locnet_app/features/settings/presentation/components/components.dart';
import 'package:locnet_app/features/settings/subfeatures/notifications/presentation/components/notification_switch_tile.dart';
import 'package:locnet_app/uikit/uikit.dart';

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
                  final bool? ok = await Navigator.of(context).push<bool>(
                    MaterialPageRoute<bool>(
                      builder: (BuildContext ctx) {
                        return BlocProvider<PasscodeLockCubit>.value(
                          value: context.read<PasscodeLockCubit>(),
                          child: const PasscodeSetupScreen(
                            mode: PasscodeSetupMode.disable,
                          ),
                        );
                      },
                    ),
                  );
                  if (ok == true && context.mounted) {
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

    await showGeneralDialog<void>(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: context.colorScheme.scrim.withValues(alpha: 0.45),
      transitionBuilder: slideFadeDialogTransition,
      pageBuilder: (BuildContext dialogContext, _, _) {
        final colorScheme = dialogContext.colorScheme;
        final textScheme = dialogContext.textScheme;

        return AppModalCard(
          maxWidth: 400,
          verticalInset: 56,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _PasscodeModalHeader(
                title: l10n.passcodeLockAfter,
                onClose: () => Navigator.of(dialogContext).pop(),
              ),
              for (int i = 0; i < options.length; i++) ...[
                if (i > 0)
                  Divider(color: colorScheme.outlineVariant),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () async {
                      Navigator.of(dialogContext).pop();
                      final ({int? minutes, String label}) selected = options[i];
                      await interactor.updateTimeout(selected.minutes);
                      if (context.mounted) {
                        _refresh();
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 14,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              options[i].label,
                              style: textScheme.body.copyWith(
                                color: colorScheme.onSurface,
                              ),
                            ),
                          ),
                          if (options[i].minutes == current.timeoutMinutes)
                            Icon(
                              Icons.check_rounded,
                              size: 22,
                              color: colorScheme.primary,
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _PasscodeModalHeader extends StatelessWidget {
  const _PasscodeModalHeader({
    required this.title,
    required this.onClose,
  });

  final String title;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final l10n = context.l10n;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 16, 16),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: colorScheme.outline)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
                height: 1.2,
              ),
            ),
          ),
          SurfaceIconButton(
            icon: Icons.close,
            dimension: 32,
            iconSize: 14,
            margin: EdgeInsets.zero,
            foregroundColor: colorScheme.onSurfaceVariant,
            tooltip: l10n.close,
            onPressed: onClose,
          ),
        ],
      ),
    );
  }
}
