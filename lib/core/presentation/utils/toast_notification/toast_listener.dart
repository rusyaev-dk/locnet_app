import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/core/core.dart';

typedef MessageSelector<L> = String? Function(BuildContext context, L state);

class ToastListener<B extends StateStreamable<S>, S, L extends S>
    extends StatelessWidget {
  const ToastListener({
    required B bloc,
    required MessageSelector<L> messageOf,
    Widget? child,
    IconData icon = Icons.error_outline,
    Color? backgroundColor,
    super.key,
  }) : _bloc = bloc,
       _messageOf = messageOf,
       _child = child,
       _icon = icon,
       _backgroundColor = backgroundColor;

  final B _bloc;
  final MessageSelector<L> _messageOf;
  final Widget? _child;
  final IconData _icon;
  final Color? _backgroundColor;

  ToastListener<B, S, L> withChild(Widget child) {
    return ToastListener<B, S, L>(
      bloc: _bloc,
      messageOf: _messageOf,
      icon: _icon,
      backgroundColor: _backgroundColor,
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    return BlocListener<B, S>(
      bloc: _bloc,
      listenWhen: (S previous, S current) {
        if (current is L) {
          final String? text = _messageOf(context, current);
          return text != null && text.isNotEmpty;
        }
        return false;
      },
      listener: (BuildContext context, S state) {
        if (state is L) {
          final String? text = _messageOf(context, state);
          if (text == null || text.isEmpty) return;

          ToastManager.show(
            context,
            message: text,
            icon: _icon,
            backgroundColor: _backgroundColor ?? colorScheme.error,
          );
        }
      },
      child: _child,
    );
  }
}

class MultiToastListener extends StatelessWidget {
  const MultiToastListener({
    required this.listeners,
    required this.child,
    super.key,
  });

  final List<ToastListener<dynamic, dynamic, dynamic>> listeners;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    Widget composed = child;
    for (final listener in listeners.reversed) {
      composed = listener.withChild(composed);
    }
    return composed;
  }
}
