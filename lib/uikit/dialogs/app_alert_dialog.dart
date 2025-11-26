import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:locnet_app/uikit/uikit.dart';

class AppAlertDialog extends StatelessWidget {
  const AppAlertDialog({
    required this.actions,
    super.key,
    this.title,
    this.content,
  });

  final List<AppAlertDialogAction> actions;
  final Widget? title;
  final Widget? content;

  @override
  Widget build(BuildContext context) {
    final actionsLocal = actions
        .map((action) => action.build(context))
        .toList();

    if (Platform.isIOS) {
      return CupertinoAlertDialog(
        title: title,
        content: content,
        actions: actionsLocal,
      );
    }

    return AlertDialog(title: title, content: content, actions: actionsLocal);
  }
}
