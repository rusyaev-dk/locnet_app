import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/features/settings/domain/domain.dart';
import 'package:locnet_app/features/settings/presentation/blocs/blocs.dart';
import 'package:locnet_app/features/settings/presentation/components/components.dart';
import 'package:locnet_app/features/settings/subfeatures/theme/presentation/components/color_scheme_selector.dart';

/// Appearance: theme mode, text/UI scale, accent.
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
              isLight: state.themeType.isLight,
              accentIndex: state.themeType.accentIndex,
              textScaleFactor: state.textScaleFactor,
              elementScaleFactor: state.elementScaleFactor,
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
              onElementScaleChanged: (v) =>
                  context.read<SettingsCubit>().changeElementScale(v),
            ),
        };
      },
    );
  }
}

class _AppearanceBody extends StatelessWidget {
  const _AppearanceBody({
    required this.isLight,
    required this.accentIndex,
    required this.textScaleFactor,
    required this.elementScaleFactor,
    required this.onBrightnessChanged,
    required this.onAccentChanged,
    required this.onTextScaleChanged,
    required this.onElementScaleChanged,
  });

  final bool isLight;
  final int accentIndex;
  final double textScaleFactor;
  final double elementScaleFactor;
  final ValueChanged<bool> onBrightnessChanged;
  final ValueChanged<int> onAccentChanged;
  final ValueChanged<double> onTextScaleChanged;
  final ValueChanged<double> onElementScaleChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SettingsGroupCard(
            title: l10n.settingsThemeSection,
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
              _ThemePreviewTile(),
            ],
          ),
          const SizedBox(height: 16),
          SettingsGroupCard(
            title: l10n.settingsInterfaceSection,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          l10n.settingsTextScale,
                          style: context.textScheme.title.copyWith(
                            color: context.colorScheme.onSurface,
                          ),
                        ),
                        Text(
                          '${(textScaleFactor * 100).round()}%',
                          style: context.textScheme.label.copyWith(
                            color: context.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
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
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          l10n.settingsElementScale,
                          style: context.textScheme.title.copyWith(
                            color: context.colorScheme.onSurface,
                          ),
                        ),
                        Text(
                          '${(elementScaleFactor * 100).round()}%',
                          style: context.textScheme.label.copyWith(
                            color: context.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        overlayShape: const RoundSliderOverlayShape(),
                        thumbShape: const RoundSliderThumbShape(
                          enabledThumbRadius: 8,
                        ),
                        trackHeight: 4,
                      ),
                      child: Slider(
                        value: elementScaleFactor,
                        min: 0.9,
                        max: 1.15,
                        divisions: 5,
                        onChanged: onElementScaleChanged,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SettingsGroupCard(
            title: l10n.settingsAccentSection,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                child: ColorSchemeSelector(
                  selectedAccentIndex: accentIndex,
                  onAccentSelected: onAccentChanged,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ThemePreviewTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textScheme = context.textScheme;
    final l10n = context.l10n;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainer,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: colorScheme.outlineVariant),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: colorScheme.primary,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 9,
                    width: 90,
                    decoration: BoxDecoration(
                      color: colorScheme.onSurface.withAlpha(200),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    height: 7,
                    width: 60,
                    decoration: BoxDecoration(
                      color: colorScheme.onSurfaceVariant.withAlpha(120),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
            ),
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
