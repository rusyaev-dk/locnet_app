import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/features/settings/domain/domain.dart';
import 'package:locnet_app/features/settings/presentation/blocs/blocs.dart';
import 'package:locnet_app/features/settings/presentation/components/components.dart';
import 'package:locnet_app/features/settings/subfeatures/theme/presentation/components/color_scheme_selector.dart';
import 'package:locnet_app/features/settings/subfeatures/theme/presentation/components/theme_preview_colors.dart';

/// Appearance: theme mode, accent colors, text scale.
class AppearanceSettingsContent extends StatelessWidget {
  const AppearanceSettingsContent({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        return switch (state) {
          SettingsInitialState() || SettingsLoadingState() =>
            const Center(child: CircularProgressIndicator()),
          SettingsFailureState() => Center(
              child: Text(
                l10n.appException,
                style: TextStyle(color: context.colorScheme.error),
              ),
            ),
          SettingsLoadedState() => _AppearanceBody(
              themeType: state.themeType,
              textScaleFactor: state.textScaleFactor,
              onBrightnessChanged: (light) {
                final newType = AppThemeType.fromAccentAndBrightness(
                  accentIndex: state.themeType.accentIndex,
                  isLight: light,
                );
                context.read<SettingsCubit>().changeThemeType(newType);
              },
              onAccentChanged: (index) {
                final newType = AppThemeType.fromAccentAndBrightness(
                  accentIndex: index,
                  isLight: state.themeType.isLight,
                );
                context.read<SettingsCubit>().changeThemeType(newType);
              },
              onTextScaleChanged: (v) =>
                  context.read<SettingsCubit>().changeTextScale(v),
            ),
        };
      },
    );
  }
}

class _AppearanceBody extends StatelessWidget {
  const _AppearanceBody({
    required this.themeType,
    required this.textScaleFactor,
    required this.onBrightnessChanged,
    required this.onAccentChanged,
    required this.onTextScaleChanged,
  });

  final AppThemeType themeType;
  final double textScaleFactor;
  final ValueChanged<bool> onBrightnessChanged;
  final ValueChanged<int> onAccentChanged;
  final ValueChanged<double> onTextScaleChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isLight = themeType.isLight;
    final accentIndex = themeType.accentIndex;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SettingsGroupCard(
            title: l10n.colorSchemeTitle,
            children: [
              SettingsSegmentedTile(
                title: l10n.settingsThemeModeLabel,
                options: [
                  l10n.themeModeLight,
                  l10n.themeModeDark,
                ],
                selectedIndex: isLight ? 0 : 1,
                onSelected: (i) => onBrightnessChanged(i == 0),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 2, 16, 8),
                child: ColorSchemeSelector(
                  selectedAccentIndex: accentIndex,
                  onAccentSelected: onAccentChanged,
                ),
              ),
              _ThemePreviewStrip(themeType: themeType),
            ],
          ),
          const SizedBox(height: 16),
          SettingsGroupCard(
            title: l10n.settingsInterfaceSection,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          l10n.settingsTextScale,
                          style: context.textScheme.label.copyWith(
                            color: context.colorScheme.onSurface,
                          ),
                        ),
                        Text(
                          '${(textScaleFactor * 100).round()}%',
                          style: context.textScheme.caption.copyWith(
                            color: context.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        overlayShape: const RoundSliderOverlayShape(),
                        thumbShape: const RoundSliderThumbShape(
                          enabledThumbRadius: 8,
                        ),
                        trackHeight: 4,
                      ),
                      child: Slider(
                        value: textScaleFactor,
                        min: 0.85,
                        max: 1.2,
                        divisions: 7,
                        onChanged: onTextScaleChanged,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ThemePreviewStrip extends StatelessWidget {
  const _ThemePreviewStrip({required this.themeType});

  final AppThemeType themeType;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textScheme = context.textScheme;
    final radii = context.radii;
    final l10n = context.l10n;
    final palette = themePreviewColors(themeType);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainer,
          borderRadius: radii.largeRadius,
          border: Border.all(color: colorScheme.outlineVariant.withAlpha(0xAA)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  for (int i = 0; i < palette.length; i++) ...[
                    if (i > 0) const SizedBox(width: 6),
                    Expanded(
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: palette[i],
                            borderRadius: radii.mediumRadius,
                            border: Border.all(
                              color: colorScheme.outlineVariant.withAlpha(0x66),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 12),
            Text(
              l10n.settingsPreviewLabel,
              style: textScheme.caption.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
