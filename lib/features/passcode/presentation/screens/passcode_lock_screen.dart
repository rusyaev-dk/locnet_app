import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/auth/presentation/presentation.dart';
import 'package:locnet_app/features/passcode/presentation/blocs/passcode_lock_cubit/passcode_lock_cubit.dart';
import 'package:locnet_app/features/passcode/presentation/blocs/passcode_lock_cubit/passcode_lock_state.dart';
import 'package:locnet_app/features/passcode/presentation/passcode_constants.dart';
import 'package:locnet_app/uikit/uikit.dart';

class PasscodeLockScreen extends StatefulWidget {
  const PasscodeLockScreen({super.key});

  @override
  State<PasscodeLockScreen> createState() => _PasscodeLockScreenState();
}

class _PasscodeLockScreenState extends State<PasscodeLockScreen> {
  final TextEditingController _pinController = TextEditingController();
  final FocusNode _pinFocus = FocusNode();
  bool _pinFieldError = false;

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

  Future<void> _confirmLogOut(BuildContext context) async {
    final l10n = context.l10n;
    await showAppAlertDialog<void>(
      context: context,
      title: Text(l10n.logOut),
      content: Text(l10n.logOutConfirmation),
      buildActions: (BuildContext dialogContext) => <AppAlertDialogAction>[
        AppAlertDialogAction(
          child: Text(l10n.cancel),
          onPressed: () => Navigator.of(dialogContext).pop(),
        ),
        AppAlertDialogAction(
          isDestructiveAction: true,
          child: Text(l10n.yesLabel),
          onPressed: () {
            Navigator.of(dialogContext).pop();
            context.read<AuthCubit>().logOut();
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = context.colorScheme;
    final textScheme = context.textScheme;

    return BlocBuilder<AuthCubit, AuthState>(
      builder: (BuildContext context, AuthState authState) {
        if (authState is! AuthAuthenticatedState) {
          return const SizedBox.shrink();
        }
        final user = authState.user;
        final String shortName = user.firstName.isNotEmpty
            ? user.firstName
            : user.username;
        final String initial = user.firstName.isNotEmpty
            ? user.firstName[0].toUpperCase()
            : (user.username.isNotEmpty
                  ? user.username[0].toUpperCase()
                  : '?');

        return BlocConsumer<PasscodeLockCubit, PasscodeLockState>(
          listener: (BuildContext context, PasscodeLockState state) {
            if (state is PasscodeLockWrongPinState) {
              setState(() => _pinFieldError = true);
              _pinController.clear();
              _pinFocus.requestFocus();
            }
          },
          builder: (BuildContext context, PasscodeLockState lockState) {
            final bool verifying = lockState is PasscodeLockVerifyingState;

            return Scaffold(
              backgroundColor: colorScheme.surface,
              body: SafeArea(
                child: LayoutBuilder(
                  builder:
                      (BuildContext context, BoxConstraints constraints) {
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
                                border: Border.all(
                                  color: colorScheme.outline,
                                ),
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
                                      24,
                                      20,
                                      24,
                                      0,
                                    ),
                                    child: Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 22,
                                          backgroundColor:
                                              colorScheme.primaryContainer,
                                          child: Text(
                                            initial,
                                            style: textScheme.title.copyWith(
                                              color: colorScheme
                                                  .onPrimaryContainer,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                shortName,
                                                style: textScheme.label
                                                    .copyWith(
                                                  color: colorScheme.onSurface,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              const SizedBox(height: 2),
                                              Text(
                                                '@${user.username}',
                                                style: textScheme.caption
                                                    .copyWith(
                                                  color: colorScheme
                                                      .onSurfaceVariant,
                                                ),
                                              ),
                                            ],
                                          ),
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
                                      l10n.passcodeUnlockTitle,
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
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        CustomTextField(
                                          controller: _pinController,
                                          focusNode: _pinFocus,
                                          labelText: l10n.passcodeEnterPin,
                                          obscureText: true,
                                          isActive: !verifying,
                                          keyboardType: TextInputType.number,
                                          textInputAction: TextInputAction.done,
                                          extraInputFormatters:
                                              <TextInputFormatter>[
                                            FilteringTextInputFormatter
                                                .digitsOnly,
                                            LengthLimitingTextInputFormatter(
                                              PasscodeConstants.pinLength,
                                            ),
                                          ],
                                          errorText: _pinFieldError
                                              ? l10n.passcodeWrongPin
                                              : null,
                                          onChanged: (String? value) {
                                            final String v = value ?? '';
                                            if (_pinFieldError &&
                                                v.isNotEmpty) {
                                              setState(
                                                () => _pinFieldError = false,
                                              );
                                            }
                                            setState(() {});
                                            if (v.length ==
                                                PasscodeConstants.pinLength) {
                                              _tryUnlock(context, v);
                                            }
                                          },
                                          onSubmitted: (String? value) =>
                                              _tryUnlock(
                                            context,
                                            value ?? _pinController.text,
                                          ),
                                        ),
                                        const SizedBox(height: 12),
                                        Center(
                                          child: TextButton(
                                            onPressed: verifying
                                                ? null
                                                : () => _confirmLogOut(
                                                      context,
                                                    ),
                                            child: Text(l10n.passcodeLogOut),
                                          ),
                                        ),
                                      ],
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
          },
        );
      },
    );
  }

  void _tryUnlock(BuildContext context, String pin) {
    if (pin.length != PasscodeConstants.pinLength) return;
    context.read<PasscodeLockCubit>().unlock(pin);
  }
}
