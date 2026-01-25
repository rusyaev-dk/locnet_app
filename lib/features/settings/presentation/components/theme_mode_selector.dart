import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/features/settings/presentation/presentation.dart';

class ThemeModeSelector extends StatelessWidget {
  const ThemeModeSelector({
    required this.selectedThemeMode,
    super.key,
  });

  final ThemeMode selectedThemeMode;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textScheme = context.textScheme;
    final l10n = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.themeMode,
          style: textScheme.label.copyWith(color: colorScheme.onSurfaceVariant),
        ),
        const SizedBox(height: 8),
        ThemeModeSegmentedControl(
          selectedThemeMode: selectedThemeMode,
          onThemeModeSelected: (ThemeMode mode) {
            context.read<SettingsCubit>().changeThemeMode(mode);
          },
        ),
      ],
    );
  }
}

class ThemeModeSegmentedControl extends StatelessWidget {
  const ThemeModeSegmentedControl({
    required this.selectedThemeMode,
    required this.onThemeModeSelected,
    super.key,
  });

  final ThemeMode selectedThemeMode;
  final ValueChanged<ThemeMode> onThemeModeSelected;

  static const Duration _moveDuration = Duration(milliseconds: 260);
  static const Curve _moveCurve = Curves.easeOutCubic;

  Alignment _getIndicatorAlignment(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.system:
        return Alignment.centerLeft;
      case ThemeMode.light:
        return Alignment.center;
      case ThemeMode.dark:
        return Alignment.centerRight;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final l10n = context.l10n;

    final Alignment indicatorAlignment = _getIndicatorAlignment(selectedThemeMode);

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double segmentWidth = (constraints.maxWidth - 8) / 3;

        return Container(
          height: 52,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: colorScheme.outlineVariant),
          ),
          child: Stack(
            children: [
              AnimatedAlign(
                duration: _moveDuration,
                curve: _moveCurve,
                alignment: indicatorAlignment,
                child: _SegmentIndicator(width: segmentWidth),
              ),
              Row(
                children: [
                  Expanded(
                    child: _SegmentButton(
                      title: l10n.themeModeSystem,
                      icon: Icons.brightness_auto,
                      isSelected: selectedThemeMode == ThemeMode.system,
                      onPressed: () => onThemeModeSelected(ThemeMode.system),
                    ),
                  ),
                  Expanded(
                    child: _SegmentButton(
                      title: l10n.themeModeLight,
                      icon: Icons.light_mode_outlined,
                      isSelected: selectedThemeMode == ThemeMode.light,
                      onPressed: () => onThemeModeSelected(ThemeMode.light),
                    ),
                  ),
                  Expanded(
                    child: _SegmentButton(
                      title: l10n.themeModeDark,
                      icon: Icons.dark_mode_outlined,
                      isSelected: selectedThemeMode == ThemeMode.dark,
                      onPressed: () => onThemeModeSelected(ThemeMode.dark),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SegmentIndicator extends StatelessWidget {
  const _SegmentIndicator({required this.width});

  final double width;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    return Container(
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: colorScheme.primary.withAlpha(0x14),
        border: Border.all(color: colorScheme.primary.withAlpha(0x3D)),
        boxShadow: [
          BoxShadow(
            blurRadius: 12,
            spreadRadius: -6,
            offset: const Offset(0, 4),
            color: colorScheme.primary.withAlpha(0x22),
          ),
        ],
      ),
    );
  }
}

class _SegmentButton extends StatelessWidget {
  const _SegmentButton({
    required this.title,
    required this.icon,
    required this.isSelected,
    required this.onPressed,
  });

  final String title;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onPressed;

  static const Duration _styleDuration = Duration(milliseconds: 220);
  static const Curve _styleCurve = Curves.easeOutCubic;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textScheme = context.textScheme;

    final Color targetForegroundColor = isSelected
        ? colorScheme.primary
        : colorScheme.onSurfaceVariant;

    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(12),
      child: Center(
        child: TweenAnimationBuilder<Color?>(
          duration: _styleDuration,
          curve: _styleCurve,
          tween: ColorTween(end: targetForegroundColor),
          builder: (BuildContext context, Color? animatedColor, Widget? child) {
            final Color resolvedColor = animatedColor ?? targetForegroundColor;

            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 20, color: resolvedColor),
                const SizedBox(width: 8),
                Flexible(
                  child: AnimatedDefaultTextStyle(
                    duration: _styleDuration,
                    curve: _styleCurve,
                    style: textScheme.label.copyWith(
                      color: resolvedColor,
                      fontSize: 15,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    ),
                    child: Text(
                      title,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
