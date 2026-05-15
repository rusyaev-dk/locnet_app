import 'package:flutter/material.dart';
import 'package:locnet_app/app/app.dart';

/// Numeric keypad for PIN entry (phone-style layout).
class PinInputPad extends StatelessWidget {
  const PinInputPad({
    required this.onDigit,
    required this.onBackspace,
    super.key,
  });

  final ValueChanged<int> onDigit;
  final VoidCallback onBackspace;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textScheme = context.textScheme;

    Widget keyCell({required Widget child, VoidCallback? onTap}) {
      return Material(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: SizedBox(
            height: 52,
            child: Center(child: child),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final List<int?> row in <List<int?>>[
            <int?>[1, 2, 3],
            <int?>[4, 5, 6],
            <int?>[7, 8, 9],
            <int?>[null, 0, -1],
          ])
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  for (final int? n in row)
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: n == null
                            ? const SizedBox(height: 52)
                            : n == -1
                            ? keyCell(
                                child: Icon(
                                  Icons.backspace_outlined,
                                  color: colorScheme.onSurface,
                                  size: 22,
                                ),
                                onTap: onBackspace,
                              )
                            : keyCell(
                                child: Text(
                                  '$n',
                                  style: textScheme.title.copyWith(
                                    color: colorScheme.onSurface,
                                  ),
                                ),
                                onTap: () => onDigit(n),
                              ),
                      ),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
