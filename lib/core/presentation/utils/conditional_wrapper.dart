import 'package:flutter/widgets.dart';

class ConditionalWrapper extends StatelessWidget {
  const ConditionalWrapper({
    required this.condition,
    required this.wrapper,
    required this.child,
    super.key,
  });

  final bool condition;

  final Widget Function(Widget child) wrapper;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (condition) {
      return wrapper(child);
    }
    return child;
  }
}
