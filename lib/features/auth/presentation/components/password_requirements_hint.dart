import 'package:flutter/material.dart';
import 'package:locnet_app/app/app.dart';

class PasswordRequirementsHint extends StatelessWidget {
  const PasswordRequirementsHint({
    required this.password,
    required this.isActive,
    super.key,
  });

  final String password;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textScheme = context.textScheme;
    final l10n = context.l10n;

    final PasswordRequirementsState state =
        PasswordRequirementsState.fromPassword(password: password);

    final Color baseTextColor = colorScheme.onSurface.withAlpha(179);

    return Semantics(
      container: true,
      label: l10n.passwordRequirementsTitle,
      child: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "${l10n.passwordRequirementsTitle}:",
              style: textScheme.label.copyWith(
                fontSize: 14,
                color: baseTextColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            _PasswordRequirementLine(
              text: l10n.passwordRequirementMinLength(14),
              isSatisfied: state.hasMinLength,
              isActive: isActive,
            ),
            _PasswordRequirementLine(
              text: l10n.passwordRequirementUppercase,
              isSatisfied: state.hasUppercase,
              isActive: isActive,
            ),
            _PasswordRequirementLine(
              text: l10n.passwordRequirementLowercase,
              isSatisfied: state.hasLowercase,
              isActive: isActive,
            ),
            _PasswordRequirementLine(
              text: l10n.passwordRequirementDigit,
              isSatisfied: state.hasDigit,
              isActive: isActive,
            ),
            _PasswordRequirementLine(
              text: l10n.passwordRequirementSpecial,
              isSatisfied: state.hasSpecial,
              isActive: isActive,
            ),
            _PasswordRequirementLine(
              text: l10n.passwordRequirementAllowedChars,
              isSatisfied: state.hasOnlyAllowedChars,
              isActive: isActive,
            ),
          ],
        ),
      ),
    );
  }
}

class _PasswordRequirementLine extends StatelessWidget {
  const _PasswordRequirementLine({
    required this.text,
    required this.isSatisfied,
    required this.isActive,
  });

  final String text;
  final bool isSatisfied;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textScheme = context.textScheme;

    final Color satisfiedColor = colorScheme.primary;
    final Color unsatisfiedColor = colorScheme.onSurface.withAlpha(179);
    final Color disabledColor = colorScheme.onSurface.withAlpha(100);

    final Color textColor = !isActive
        ? disabledColor
        : (isSatisfied ? satisfiedColor : unsatisfiedColor);

    final IconData icon = isSatisfied
        ? Icons.check_circle
        : Icons.radio_button_unchecked;

    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Icon(icon, size: 16, color: textColor),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: textScheme.label.copyWith(fontSize: 14, color: textColor),
            ),
          ),
        ],
      ),
    );
  }
}

class PasswordRequirementsState {
  PasswordRequirementsState({
    required this.hasMinLength,
    required this.hasUppercase,
    required this.hasLowercase,
    required this.hasDigit,
    required this.hasSpecial,
    required this.hasOnlyAllowedChars,
  });

  factory PasswordRequirementsState.fromPassword({required String password}) {
    final bool hasMinLength = password.length >= 14;
    final bool hasUppercase = RegExp(r'[A-Z]').hasMatch(password);
    final bool hasLowercase = RegExp(r'[a-z]').hasMatch(password);
    final bool hasDigit = RegExp(r'\d').hasMatch(password);

    final RegExp allowed = RegExp(r'^[A-Za-z0-9!?@#$%^&*()_\-{}]+$');
    final bool hasOnlyAllowedChars = password.isEmpty
        ? true
        : allowed.hasMatch(password);

    final RegExp special = RegExp(r'[!?@#$%^&*()_\-{}]');
    final bool hasSpecial = special.hasMatch(password);

    return PasswordRequirementsState(
      hasMinLength: hasMinLength,
      hasUppercase: hasUppercase,
      hasLowercase: hasLowercase,
      hasDigit: hasDigit,
      hasSpecial: hasSpecial,
      hasOnlyAllowedChars: hasOnlyAllowedChars,
    );
  }

  final bool hasMinLength;
  final bool hasUppercase;
  final bool hasLowercase;
  final bool hasDigit;
  final bool hasSpecial;
  final bool hasOnlyAllowedChars;
}
