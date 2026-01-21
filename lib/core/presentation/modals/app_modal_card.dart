import 'package:flutter/material.dart';
import 'package:locnet_app/app/app.dart';

class AppModalCard extends StatelessWidget {
  const AppModalCard({
    required this.child,
    super.key,
    this.maxWidth = 420,
    this.verticalInset = 48,
    this.borderRadius = 14,
  });

  final Widget child;
  final double maxWidth;
  final double verticalInset;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    return SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: maxWidth,
            maxHeight: MediaQuery.of(context).size.height - verticalInset,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(borderRadius),
            child: Material(
              child: Container(
                decoration: BoxDecoration(
                  color: colorScheme.secondary,
                  borderRadius: BorderRadius.circular(borderRadius),
                ),
                child: child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
