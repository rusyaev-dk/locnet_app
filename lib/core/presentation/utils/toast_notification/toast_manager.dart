import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ToastManager {
  static void show(
    BuildContext context, {
    required String message,
    IconData? icon,
    Color? backgroundColor,
    Duration duration = const Duration(seconds: 3),
  }) {
    final overlay = Overlay.of(context);

    final overlayEntry = OverlayEntry(
      builder: (ctx) {
        final screenHeight = MediaQuery.of(ctx).size.height;
        final topOffset = screenHeight * 0.12;

        return Positioned(
          top: topOffset,
          left: 0,
          right: 0,
          child: AppToast(
            message: message,
            icon: icon,
            backgroundColor: backgroundColor,
          ),
        );
      },
    );

    overlay.insert(overlayEntry);

    Future.delayed(duration, () {
      overlayEntry.remove();
    });
  }
}

class AppToast extends StatelessWidget {
  const AppToast({
    required this.message,
    super.key,
    this.icon,
    this.backgroundColor,
  });

  final String message;
  final IconData? icon;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: Colors.transparent,
      child: Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: backgroundColor ?? colorScheme.error,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                if (icon != null) ...[
                  Animate(
                    effects: const [
                      ShakeEffect(delay: Duration(milliseconds: 175)),
                    ],
                    child: Icon(icon, color: colorScheme.onError, size: 30),
                  ),
                  const SizedBox(width: 8),
                ],
                Expanded(
                  child: Text(
                    message,
                    style: TextStyle(color: colorScheme.onError, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
