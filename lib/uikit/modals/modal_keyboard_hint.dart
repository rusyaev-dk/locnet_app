import 'package:flutter/material.dart';
import 'package:locnet_app/app/app.dart';

/// Key cap + short label for modal footers (search dialogs, etc.).
class ModalKeyboardHint extends StatelessWidget {
  const ModalKeyboardHint({
    required this.keyLabel,
    required this.description,
    super.key,
  });

  final String keyLabel;
  final String description;

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
          decoration: BoxDecoration(
            color: cs.surfaceContainer,
            border: Border.all(color: cs.outline),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Text(
            keyLabel,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: cs.onSurfaceVariant,
              height: 1.2,
            ),
          ),
        ),
        const SizedBox(width: 5),
        Text(
          description,
          style: TextStyle(
            fontSize: 11,
            color: cs.onSurfaceVariant,
            height: 1.2,
          ),
        ),
      ],
    );
  }
}
