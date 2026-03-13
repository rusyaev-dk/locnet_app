import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/features/settings/domain/domain.dart';
import 'package:locnet_app/features/settings/presentation/blocs/blocs.dart';
import 'package:locnet_app/features/settings/presentation/components/components.dart';
import 'package:locnet_app/features/settings/subfeatures/theme/presentation/components/color_scheme_selector.dart';

/// Appearance section: theme brightness, interface density, animations.
class AppearanceSettingsContent extends StatefulWidget {
  const AppearanceSettingsContent({super.key});

  @override
  State<AppearanceSettingsContent> createState() =>
      _AppearanceSettingsContentState();
}

class _AppearanceSettingsContentState
    extends State<AppearanceSettingsContent> {
  bool _dynamicTheme = false;

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
              dynamicTheme: _dynamicTheme,
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
              onDynamicThemeChanged: (v) =>
                  setState(() => _dynamicTheme = v),
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
    required this.isLight,
    required this.accentIndex,
    required this.dynamicTheme,
    required this.textScaleFactor,
    required this.onBrightnessChanged,
    required this.onAccentChanged,
    required this.onDynamicThemeChanged,
    required this.onTextScaleChanged,
  });

  final bool isLight;
  final int accentIndex;
  final bool dynamicTheme;
  final double textScaleFactor;
  final ValueChanged<bool> onBrightnessChanged;
  final ValueChanged<int> onAccentChanged;
  final ValueChanged<bool> onDynamicThemeChanged;
  final ValueChanged<double> onTextScaleChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SettingsSectionHeader(
            title: l10n.appearance,
            description: 'Настройте тему оформления и параметры интерфейса.',
          ),

          // ── Тема ───────────────────────────────────────────
          SettingsGroupCard(
            title: 'Тема',
            children: [
              SettingsSegmentedTile(
                title: 'Режим темы',
                options: [
                  l10n.themeModeLight,
                  l10n.themeModeDark,
                  l10n.themeModeSystem,
                ],
                selectedIndex: isLight ? 0 : 1,
                onSelected: (i) => onBrightnessChanged(i == 0),
              ),
              SettingsSwitchTile(
                title: 'Динамическая тема',
                subtitle: 'Адаптировать цвета к обоям устройства',
                value: dynamicTheme,
                onChanged: onDynamicThemeChanged,
              ),
              _ThemePreviewTile(),
            ],
          ),
          const SizedBox(height: 20),

          // ── Интерфейс ─────────────────────────────────────
          SettingsGroupCard(
            title: 'Интерфейс',
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
                          'Размер текста',
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
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // ── Акцент ────────────────────────────────────────
          SettingsGroupCard(
            title: 'Акцентный цвет',
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
          const SizedBox(height: 8),
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
              'Предпросмотр',
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
