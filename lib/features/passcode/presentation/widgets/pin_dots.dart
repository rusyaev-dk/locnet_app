import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:locnet_app/app/app.dart';

/// Filled dots indicator for PIN entry (●●●○○○).
class PinDots extends StatefulWidget {
  const PinDots({
    required this.length,
    required this.filled,
    this.showError = false,
    super.key,
  });

  final int length;
  final int filled;
  final bool showError;

  @override
  State<PinDots> createState() => _PinDotsState();
}

class _PinDotsState extends State<PinDots> with SingleTickerProviderStateMixin {
  late final AnimationController _shakeController;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 420),
    );
  }

  @override
  void didUpdateWidget(PinDots oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.showError && !oldWidget.showError) {
      _shakeController.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final Color activeColor = widget.showError
        ? colorScheme.error
        : colorScheme.primary;
    final Color emptyColor = colorScheme.outlineVariant;

    return AnimatedBuilder(
      animation: _shakeController,
      builder: (BuildContext context, Widget? child) {
        final double t = _shakeController.value;
        final double offset =
            math.sin(t * math.pi * 6) * (1 - t) * 10 * (widget.showError ? 1 : 0);
        return Transform.translate(
          offset: Offset(offset, 0),
          child: child,
        );
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List<Widget>.generate(widget.length, (int i) {
          final bool filled = i < widget.filled;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: filled ? activeColor : Colors.transparent,
                border: Border.all(
                  color: filled ? activeColor : emptyColor,
                  width: 2,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
