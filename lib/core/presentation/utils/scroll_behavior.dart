import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class NoGlowClampingBehavior extends ScrollBehavior {
  const NoGlowClampingBehavior();

  @override
  Set<PointerDeviceKind> get dragDevices {
    if (!kIsWeb) {
      return super.dragDevices;
    }

    return super.dragDevices
        .where((PointerDeviceKind kind) => kind != PointerDeviceKind.trackpad)
        .toSet();
  }

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    return const ClampingScrollPhysics();
  }

  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    return child;
  }

  @override
  Widget buildScrollbar(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    return Scrollbar(
      controller: details.controller,
      thickness: 2.5,
      child: child,
    );
  }
}
