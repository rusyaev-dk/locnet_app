import 'package:flutter/widgets.dart';

class ConditionalWrapper extends StatelessWidget {
  const ConditionalWrapper({
    required this.condition,
    required this.wrapper,
    required this.child,
    super.key,
  });

  /// Condition that defines whether wrapper should be applied.
  final bool condition;

  /// Function that takes child widget and returns wrapped widget.
  final Widget Function(Widget child) wrapper;

  /// The child widget to be conditionally wrapped.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (condition) {
      return wrapper(child);
    }
    return child;
  }
}
