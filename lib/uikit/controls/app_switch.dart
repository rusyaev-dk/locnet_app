import 'package:flutter/material.dart';
import 'package:locnet_app/uikit/colors/app_color_sheme.dart';
import 'package:locnet_app/uikit/tokens/app_design_tokens.dart';

/// Toggle in Locnet Messenger style: accent pill when on, muted bordered track when off.
class AppSwitch extends StatelessWidget {
  const AppSwitch({
    required this.value,
    required this.onChanged,
    super.key,
  });

  final bool value;
  final ValueChanged<bool>? onChanged;

  static const double _width = 50;
  static const double _height = 28;
  static const double _thumbDiameter = 22;
  static const double _inset = 3;

  @override
  Widget build(BuildContext context) {
    final colorScheme = AppColorScheme.of(context);
    final motion = AppDesignTokens.of(context).motion;
    final enabled = onChanged != null;

    return MouseRegion(
      cursor: enabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
      child: GestureDetector(
        onTap: enabled ? () => onChanged!(!value) : null,
        behavior: HitTestBehavior.opaque,
        child: Semantics(
          toggled: value,
          enabled: enabled,
          child: AnimatedOpacity(
            opacity: enabled ? 1 : 0.45,
            duration: motion.fast,
            curve: motion.fastCurve,
            child: AnimatedContainer(
              duration: motion.medium,
              curve: motion.mediumCurve,
              width: _width,
              height: _height,
              padding: const EdgeInsets.all(_inset),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(_height / 2),
                color: value ? colorScheme.primary : colorScheme.surfaceContainer,
                border: Border.all(
                  color: value ? colorScheme.primary : colorScheme.outline,
                ),
              ),
              child: AnimatedAlign(
                duration: motion.medium,
                curve: motion.mediumCurve,
                alignment: value ? Alignment.centerRight : Alignment.centerLeft,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: colorScheme.surfaceBright,
                    boxShadow: [
                      BoxShadow(
                        color: colorScheme.shadow.withAlpha(0x28),
                        blurRadius: 4,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: const SizedBox.square(dimension: _thumbDiameter),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
