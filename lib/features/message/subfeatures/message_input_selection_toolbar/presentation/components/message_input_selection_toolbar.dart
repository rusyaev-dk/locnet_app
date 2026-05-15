import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/features/message/subfeatures/message_input_selection_toolbar/presentation/presentation.dart';

class MessageInputSelectionToolbarOverlay extends StatelessWidget {
  const MessageInputSelectionToolbarOverlay({
    required this.position,
    required this.actions,
    required this.onDismiss,
    super.key,
  });

  final RelativeRect position;
  final List<MessageInputSelectionToolbarAction> actions;
  final VoidCallback onDismiss;

  static const double _menuMaxWidth = 260;
  static const double _screenPadding = 8;
  static const double _estimatedItemHeight = 44;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    return Material(
      color: Colors.transparent,
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final double estimatedMenuHeight =
              actions.length * _estimatedItemHeight;

          final double maxLeft = math.max(
            _screenPadding,
            constraints.maxWidth - _menuMaxWidth - _screenPadding,
          );

          final double maxTop = math.max(
            _screenPadding,
            constraints.maxHeight - estimatedMenuHeight - _screenPadding,
          );

          final double left = position.left.clamp(_screenPadding, maxLeft);
          final double top = position.top.clamp(_screenPadding, maxTop);

          return Stack(
            children: [
              Positioned(
                left: left,
                top: top,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: _menuMaxWidth),
                  child: Material(
                    color: colorScheme.surfaceContainerHigh,
                    borderRadius: BorderRadius.circular(14),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: colorScheme.outlineVariant.withAlpha(110),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: colorScheme.shadow.withAlpha(40),
                            blurRadius: 18,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            for (final MessageInputSelectionToolbarAction action
                                in actions)
                              MessageInputSelectionToolbarItem(
                                title: action.title,
                                icon: action.icon,
                                isEnabled: action.isEnabled,
                                isDestructive: action.isDestructive,
                                onPressed: () {
                                  if (!action.isEnabled) {
                                    return;
                                  }

                                  action.onPressed();
                                },
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
