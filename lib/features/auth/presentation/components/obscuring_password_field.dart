import 'package:flutter/material.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/uikit/uikit.dart';

/// Password [CustomTextField] with a suffix control to show or hide the text.
class ObscuringPasswordField extends StatefulWidget {
  const ObscuringPasswordField({
    required this.controller,
    required this.labelText,
    required this.isActive,
    super.key,
    this.textInputAction,
    this.onChanged,
    this.onSubmitted,
    this.onFocusChange,
    this.errorText,
  });

  final TextEditingController controller;
  final String labelText;
  final bool isActive;
  final TextInputAction? textInputAction;
  final ValueChanged<String?>? onChanged;
  final ValueChanged<String?>? onSubmitted;
  final ValueChanged<String?>? onFocusChange;
  final String? errorText;

  @override
  State<ObscuringPasswordField> createState() => _ObscuringPasswordFieldState();
}

class _ObscuringPasswordFieldState extends State<ObscuringPasswordField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    return CustomTextField(
      isActive: widget.isActive,
      controller: widget.controller,
      labelText: widget.labelText,
      obscureText: _obscure,
      textInputAction: widget.textInputAction,
      onSubmitted: widget.onSubmitted,
      onChanged: widget.onChanged,
      onFocusChange: widget.onFocusChange,
      errorText: widget.errorText,
      suffixIcon: IconButton(
        onPressed: widget.isActive
            ? () {
                setState(() {
                  _obscure = !_obscure;
                });
              }
            : null,
        style: IconButton.styleFrom(
          foregroundColor: colorScheme.onSurfaceVariant,
        ),
        icon: Icon(
          _obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined,
        ),
      ),
    );
  }
}
