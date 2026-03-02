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
  int _densityIndex = 1;
  int _textSizeIndex = 1;
  bool _animations = true;
  bool _reducedMotion = false;
  bool _autoAccent = true;

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
              densityIndex: _densityIndex,
              textSizeIndex: _textSizeIndex,
              animations: _animations,
              reducedMotion: _reducedMotion,
              autoAccent: _autoAccent,
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
              onDensityChanged: (i) => setState(() => _densityIndex = i),
              onTextSizeChanged: (i) => setState(() => _textSizeIndex = i),
              onAnimationsChanged: (v) => setState(() => _animations = v),
              onReducedMotionChanged: (v) =>
                  setState(() => _reducedMotion = v),
              onAutoAccentChanged: (v) => setState(() => _autoAccent = v),
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
    required this.densityIndex,
    required this.textSizeIndex,
    required this.animations,
    required this.reducedMotion,
    required this.autoAccent,
    required this.onBrightnessChanged,
    required this.onAccentChanged,
    required this.onDynamicThemeChanged,
    required this.onDensityChanged,
    required this.onTextSizeChanged,
    required this.onAnimationsChanged,
    required this.onReducedMotionChanged,
    required this.onAutoAccentChanged,
  });

  final bool isLight;
  final int accentIndex;
  final bool dynamicTheme;
  final int densityIndex;
  final int textSizeIndex;
  final bool animations;
  final bool reducedMotion;
  final bool autoAccent;
  final ValueChanged<bool> onBrightnessChanged;
  final ValueChanged<int> onAccentChanged;
  final ValueChanged<bool> onDynamicThemeChanged;
  final ValueChanged<int> onDensityChanged;
  final ValueChanged<int> onTextSizeChanged;
  final ValueChanged<bool> onAnimationsChanged;
  final ValueChanged<bool> onReducedMotionChanged;
  final ValueChanged<bool> onAutoAccentChanged;

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
              SettingsSegmentedTile(
                title: 'Плотность интерфейса',
                options: const ['Компактная', 'Стандартная', 'Расширенная'],
                selectedIndex: densityIndex,
                onSelected: onDensityChanged,
              ),
              SettingsSegmentedTile(
                title: 'Размер текста',
                options: const ['S', 'M', 'L'],
                selectedIndex: textSizeIndex,
                onSelected: onTextSizeChanged,
              ),
              SettingsSwitchTile(
                title: 'Анимации интерфейса',
                value: animations,
                onChanged: onAnimationsChanged,
              ),
              SettingsSwitchTile(
                title: 'Сниженное движение',
                subtitle: 'Минимизировать движущиеся элементы',
                value: reducedMotion,
                enabled: animations,
                onChanged: onReducedMotionChanged,
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
              SettingsSwitchTile(
                title: 'Автоматически адаптировать акцент',
                value: autoAccent,
                onChanged: onAutoAccentChanged,
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
