import 'package:flutter/material.dart';

Widget slideFadeDialogTransition(
  BuildContext context,
  Animation<double> animation,
  Animation<double> secondaryAnimation,
  Widget child,
) {
  final Animation<double> eased = CurvedAnimation(
    parent: animation,
    curve: Curves.fastOutSlowIn,
    reverseCurve: Curves.fastOutSlowIn,
  );

  final Animation<Offset> slideAnimation = Tween<Offset>(
    begin: const Offset(0.03, 0),
    end: Offset.zero,
  ).animate(eased);

  final Animation<double> fadeAnimation = eased;

  return SlideTransition(
    position: slideAnimation,
    child: FadeTransition(opacity: fadeAnimation, child: child),
  );
}
