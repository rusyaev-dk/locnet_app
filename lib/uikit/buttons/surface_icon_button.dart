import 'package:flutter/material.dart';
import 'package:locnet_app/app/app.dart';

/// Visual style for [SurfaceIconButton] / [SurfaceIconShell].
enum SurfaceIconVariant {
  /// Secondary fill + outline (headers, modal chrome).
  toolbar,

  /// Transparent; hover shows a light overlay (e.g. back chevron).
  ghost,
}

/// Non-interactive chrome shared with [SurfaceIconButton] and
/// [PopupMenuButton] triggers (hover only; parent handles tap).
class SurfaceIconShell extends StatefulWidget {
  const SurfaceIconShell({
    required this.icon,
    super.key,
    this.variant = SurfaceIconVariant.toolbar,
    this.dimension = 34,
    this.iconSize = 16,
    this.margin = EdgeInsets.zero,
    this.foregroundColor,
    this.borderRadius,
  });

  final IconData icon;
  final SurfaceIconVariant variant;
  final double dimension;
  final double iconSize;
  final EdgeInsetsGeometry margin;
  final Color? foregroundColor;
  final BorderRadius? borderRadius;

  @override
  State<SurfaceIconShell> createState() => _SurfaceIconShellState();
}

class _SurfaceIconShellState extends State<SurfaceIconShell> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    final Color fg = widget.foregroundColor ?? cs.onSurfaceVariant;

    final Color bg = switch (widget.variant) {
      SurfaceIconVariant.toolbar => _hover
          ? Color.alphaBlend(
              cs.onSurface.withValues(alpha: 0.08),
              cs.secondary,
            )
          : cs.secondary,
      SurfaceIconVariant.ghost => _hover
          ? cs.onSurface.withValues(alpha: 0.08)
          : Colors.transparent,
    };

    final Border? border = widget.variant == SurfaceIconVariant.toolbar
        ? Border.all(color: cs.outline)
        : null;

    final BorderRadius br =
        widget.borderRadius ?? BorderRadius.circular(8);

    return Padding(
      padding: widget.margin,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hover = true),
        onExit: (_) => setState(() => _hover = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 140),
          curve: Curves.easeOut,
          width: widget.dimension,
          height: widget.dimension,
          decoration: BoxDecoration(
            color: bg,
            borderRadius: br,
            border: border,
          ),
          alignment: Alignment.center,
          child: Icon(widget.icon, size: widget.iconSize, color: fg),
        ),
      ),
    );
  }
}

/// Toolbar / modal icon control: same look as header media actions; swap [icon] only.
class SurfaceIconButton extends StatelessWidget {
  const SurfaceIconButton({
    required this.icon,
    required this.onPressed,
    super.key,
    this.variant = SurfaceIconVariant.toolbar,
    this.dimension = 34,
    this.iconSize = 16,
    this.margin = const EdgeInsets.only(left: 6),
    this.tooltip,
    this.foregroundColor,
    this.borderRadius,
  });

  final IconData icon;
  final VoidCallback onPressed;
  final SurfaceIconVariant variant;
  final double dimension;
  final double iconSize;
  final EdgeInsetsGeometry margin;
  final String? tooltip;
  final Color? foregroundColor;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    Widget child = GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onPressed,
      child: SurfaceIconShell(
        icon: icon,
        variant: variant,
        dimension: dimension,
        iconSize: iconSize,
        margin: margin,
        foregroundColor: foregroundColor,
        borderRadius: borderRadius,
      ),
    );

    if (tooltip != null && tooltip!.isNotEmpty) {
      child = Tooltip(message: tooltip!, child: child);
    }
    return child;
  }
}
