import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/core/core.dart' show showAppAlertDialog;
import 'package:locnet_app/features/settings/presentation/components/components.dart';
import 'package:locnet_app/features/settings/subfeatures/storage/presentation/blocs/storage_cubit.dart';
import 'package:locnet_app/features/settings/subfeatures/storage/presentation/blocs/storage_state.dart';
import 'package:locnet_app/uikit/uikit.dart';

// ─── Category accent colours ──────────────────────────────────────────────────

const _colorPhotos = Color(0xFF4A90E2);
const _colorVideos = Color(0xFF9C5BF5);
const _colorAudio = Color(0xFF4CAF79);
const _colorText = Color(0xFFFF9800);
const _colorOther = Color(0xFF8B93A8);

// ─── Public screen widget ─────────────────────────────────────────────────────

class StorageSettingsContent extends StatefulWidget {
  const StorageSettingsContent({super.key});

  @override
  State<StorageSettingsContent> createState() => _StorageSettingsContentState();
}

class _StorageSettingsContentState extends State<StorageSettingsContent> {
  @override
  void initState() {
    super.initState();
    context.read<StorageCubit>().loadStats();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StorageCubit, StorageState>(
      builder: (context, state) {
        return switch (state) {
          StorageLoadingState() => const _LoadingBody(),
          StorageClearingState(:final prevStats) => _StorageBody(
            stats: prevStats,
            isClearing: true,
          ),
          StorageLoadedState() => _StorageBody(stats: state),
          StorageErrorState(:final error) => _ErrorBody(error: error),
        };
      },
    );
  }
}

// ─── Body ─────────────────────────────────────────────────────────────────────

class _StorageBody extends StatelessWidget {
  const _StorageBody({required this.stats, this.isClearing = false});

  final StorageLoadedState stats;
  final bool isClearing;

  Future<void> _confirmClear(BuildContext context) {
    final l10n = context.l10n;
    return showAppAlertDialog<void>(
      context: context,
      buildActions: (dialogContext) => [
        AppAlertDialogAction(
          child: Text(l10n.cancel),
          onPressed: () => Navigator.of(dialogContext).pop(),
        ),
        AppAlertDialogAction(
          isDestructiveAction: true,
          onPressed: () {
            Navigator.of(dialogContext).pop();
            context.read<StorageCubit>().clearAll();
          },
          child: Text(l10n.settingsStorageClearAll),
        ),
      ],
      title: Text(l10n.settingsStorageClearAllTitle),
      content: Text(l10n.settingsStorageClearAllBody),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final categories = _buildCategories(l10n);

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SettingsSectionHeader(title: l10n.settingsStorageSection),
          const SizedBox(height: 20),

          _StatsCard(stats: stats, categories: categories),
          const SizedBox(height: 20),

          SettingsGroupCard(
            title: l10n.settingsStorageByType,
            children: [
              for (final cat in categories)
                _CategoryTile(category: cat, totalBytes: stats.totalBytes),
            ],
          ),
          const SizedBox(height: 20),

          // ── Actions ─────────────────────────────────────────────────
          SettingsGroupCard(
            title: l10n.settingsStorageActions,
            description: stats.isEmpty
                ? l10n.settingsStorageAlreadyEmpty
                : l10n.settingsStorageClearCacheHint,
            children: [
              SettingsActionTile(
                title: l10n.settingsStorageClearAll,
                leadingIcon: Icons.delete_outline_rounded,
                destructive: true,
                enabled: !isClearing && !stats.isEmpty,
                onTap: () => _confirmClear(context),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<_CategoryData> _buildCategories(dynamic l10n) => [
    _CategoryData(
      icon: Icons.image_outlined,
      label: l10n.settingsStoragePhotos as String,
      color: _colorPhotos,
      bytes: stats.photoBytes,
      fraction: stats.fractionOf(stats.photoBytes),
    ),
    _CategoryData(
      icon: Icons.videocam_outlined,
      label: l10n.settingsStorageVideos as String,
      color: _colorVideos,
      bytes: stats.videoBytes,
      fraction: stats.fractionOf(stats.videoBytes),
    ),
    _CategoryData(
      icon: Icons.forum_outlined,
      label: l10n.settingsStorageMessages as String,
      color: _colorText,
      bytes: stats.textBytes,
      fraction: stats.fractionOf(stats.textBytes),
    ),
    _CategoryData(
      icon: Icons.headphones_outlined,
      label: l10n.settingsStorageAudio as String,
      color: _colorAudio,
      bytes: stats.audioBytes,
      fraction: stats.fractionOf(stats.audioBytes),
    ),
    _CategoryData(
      icon: Icons.insert_drive_file_outlined,
      label: l10n.settingsStorageOtherFiles as String,
      color: _colorOther,
      bytes: stats.otherBytes,
      fraction: stats.fractionOf(stats.otherBytes),
    ),
  ];
}

// ─── Stats hero card ──────────────────────────────────────────────────────────

class _StatsCard extends StatelessWidget {
  const _StatsCard({required this.stats, required this.categories});

  final StorageLoadedState stats;
  final List<_CategoryData> categories;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textScheme = context.textScheme;
    final l10n = context.l10n;

    final totalLabel = stats.isEmpty
        ? l10n.settingsStorageCacheEmpty
        : l10n.settingsStorageTotalCached(formatBytes(stats.totalBytes));

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 92,
            height: 92,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CustomPaint(
                  size: const Size(92, 92),
                  painter: _DonutPainter(
                    categories: categories,
                    trackColor: colorScheme.outlineVariant,
                    isEmpty: stats.isEmpty,
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _compactBytes(stats.totalBytes),
                      style: textScheme.headline.copyWith(
                        color: colorScheme.onSurface,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        height: 1.1,
                      ),
                    ),
                    Text(
                      _bytesUnit(stats.totalBytes),
                      style: textScheme.caption.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 20),
          // Summary
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  totalLabel,
                  style: textScheme.label.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                // Stacked bar
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: _StackedBar(
                    categories: categories,
                    trackColor: colorScheme.outlineVariant,
                  ),
                ),
                const SizedBox(height: 10),
                // Legend
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: [
                    for (final cat in categories)
                      if (cat.bytes > 0)
                        _LegendDot(color: cat.color, label: cat.label),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _compactBytes(int bytes) {
    if (bytes == 0) return '0';
    if (bytes >= _gb) return (bytes / _gb).toStringAsFixed(1);
    if (bytes >= _mb) return (bytes / _mb).toStringAsFixed(0);
    if (bytes >= _kb) return (bytes / _kb).toStringAsFixed(0);
    return bytes.toString();
  }

  String _bytesUnit(int bytes) {
    if (bytes >= _gb) return 'GB';
    if (bytes >= _mb) return 'MB';
    if (bytes >= _kb) return 'KB';
    return 'B';
  }
}

// ─── Stacked horizontal bar ───────────────────────────────────────────────────

class _StackedBar extends StatelessWidget {
  const _StackedBar({required this.categories, required this.trackColor});

  final List<_CategoryData> categories;
  final Color trackColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 6,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final segments = categories.where((c) => c.bytes > 0).toList();
          if (segments.isEmpty) {
            return Container(color: trackColor);
          }
          // Use Expanded with integer flex ratios so total always equals
          // constraints.maxWidth — avoids floating-point overflow.
          return Row(
            children: [
              for (final cat in segments)
                Expanded(
                  flex: math.max(1, (cat.fraction * 10000).round()),
                  child: Container(color: cat.color),
                ),
            ],
          );
        },
      ),
    );
  }
}

// ─── Category tile ────────────────────────────────────────────────────────────

class _CategoryTile extends StatelessWidget {
  const _CategoryTile({required this.category, required this.totalBytes});

  final _CategoryData category;
  final int totalBytes;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textScheme = context.textScheme;
    final pctLabel = totalBytes == 0
        ? '—'
        : '${(category.fraction * 100).round()}%';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: category.color.withAlpha(0x22),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(category.icon, size: 18, color: category.color),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  category.label,
                  style: textScheme.label.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Text(
                formatBytes(category.bytes),
                style: textScheme.caption.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                width: 36,
                child: Text(
                  pctLabel,
                  textAlign: TextAlign.end,
                  style: textScheme.caption.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: category.fraction.clamp(0.0, 1.0),
              minHeight: 4,
              backgroundColor: colorScheme.outlineVariant,
              valueColor: AlwaysStoppedAnimation<Color>(category.color),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Legend dot ───────────────────────────────────────────────────────────────

class _LegendDot extends StatelessWidget {
  const _LegendDot({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 7,
          height: 7,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: context.textScheme.caption.copyWith(
            color: context.colorScheme.onSurfaceVariant,
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}

// ─── Loading / error stubs ────────────────────────────────────────────────────

class _LoadingBody extends StatelessWidget {
  const _LoadingBody();

  @override
  Widget build(BuildContext context) =>
      const Center(child: CircularProgressIndicator());
}

class _ErrorBody extends StatelessWidget {
  const _ErrorBody({required this.error});
  final Object error;

  @override
  Widget build(BuildContext context) => Center(
    child: Text(
      '${context.l10n.storageException}\n$error',
      textAlign: TextAlign.center,
      style: context.textScheme.label.copyWith(
        color: context.colorScheme.onSurfaceVariant,
      ),
    ),
  );
}

// ─── Data model ───────────────────────────────────────────────────────────────

class _CategoryData {
  const _CategoryData({
    required this.icon,
    required this.label,
    required this.color,
    required this.bytes,
    required this.fraction,
  });

  final IconData icon;
  final String label;
  final Color color;
  final int bytes;
  final double fraction;
}

// ─── Donut chart painter ──────────────────────────────────────────────────────

class _DonutPainter extends CustomPainter {
  _DonutPainter({
    required this.categories,
    required this.trackColor,
    required this.isEmpty,
  });

  final List<_CategoryData> categories;
  final Color trackColor;
  final bool isEmpty;

  static const double _strokeWidth = 10.0;
  static const double _gap = 0.05;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (math.min(size.width, size.height) - _strokeWidth) / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    final trackPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = _strokeWidth
      ..color = trackColor;

    canvas.drawCircle(center, radius, trackPaint);

    if (isEmpty) return;

    final active = categories.where((c) => c.fraction > 0).toList();
    if (active.isEmpty) return;

    final totalGap = _gap * active.length;
    final sweepPerUnit = (2 * math.pi - totalGap);
    double currentAngle = -math.pi / 2;

    for (final cat in active) {
      final sweep = sweepPerUnit * cat.fraction;
      if (sweep <= 0) continue;
      final segPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = _strokeWidth
        ..color = cat.color
        ..strokeCap = StrokeCap.round;
      canvas.drawArc(rect, currentAngle, sweep, false, segPaint);
      currentAngle += sweep + _gap;
    }
  }

  @override
  bool shouldRepaint(_DonutPainter old) =>
      old.isEmpty != isEmpty || old.trackColor != trackColor;
}

// ─── Byte formatting helpers ──────────────────────────────────────────────────

const int _kb = 1024;
const int _mb = 1024 * 1024;
const int _gb = 1024 * 1024 * 1024;

String formatBytes(int bytes) {
  if (bytes == 0) return '0 B';
  if (bytes >= _gb) return '${(bytes / _gb).toStringAsFixed(2)} GB';
  if (bytes >= _mb) return '${(bytes / _mb).toStringAsFixed(1)} MB';
  if (bytes >= _kb) return '${(bytes / _kb).toStringAsFixed(0)} KB';
  return '$bytes B';
}
