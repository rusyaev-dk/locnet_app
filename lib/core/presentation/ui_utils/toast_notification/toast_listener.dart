import 'package:flutter/material.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ToastListener<B extends StateStreamable<S>, S, L extends S>
    extends StatelessWidget {
  const ToastListener({
    required B bloc,
    required AppMessage? Function(L) messageOf,
    Widget? child,
    IconData icon = Icons.error_outline,
    Color? backgroundColor,
    super.key,
  }) : _bloc = bloc,
       _messageOf = messageOf,
       _child = child,
       _icon = icon,
       _backgroundColor = backgroundColor;

  // Bloc instance to listen to.
  final B _bloc;

  // Extractor that returns a nullable message string from the loaded state.
  final AppMessage? Function(L) _messageOf;

  // Child subtree to render.
  final Widget? _child;

  // Icon to show in toast.
  final IconData _icon;

  // Optional background color for toast. Fallbacks to Theme.colorScheme.error.
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
          final AppMessage? msg = _messageOf(current);
          return msg != null;
        }
        return false;
      },
      listener: (BuildContext context, S state) {
        if (state is L) {
          final AppMessage? message = _messageOf(state);
          if (message == null) return;

          ToastManager.show(
            context,
            message: AppMessageEnumTranslator.translate(context, message.key),
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
    for (final ToastListener<dynamic, dynamic, dynamic> listener
        in listeners.reversed) {
      composed = listener.withChild(composed);
    }
    return composed;
  }
}
