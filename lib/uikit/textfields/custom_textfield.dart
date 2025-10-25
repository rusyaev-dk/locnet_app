import 'package:flutter/material.dart';
import 'package:locnet_app/uikit/uikit.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    required this.label,
    super.key,
    this.onChanged,
    this.initialValue,
    this.keyboardType = TextInputType.text,
    this.enabled = true,
    this.errorText,
    this.controller,
  });

  final String label;
  final ValueChanged<String>? onChanged;
  final TextInputType keyboardType;
  final String? initialValue;
  final bool? enabled;
  final String? errorText;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    final colorScheme = AppColorScheme.of(context);
    final textScheme = AppTextScheme.of(context);

    return TextFormField(
      controller: controller,
      forceErrorText: errorText,
      enabled: enabled,
      initialValue: initialValue,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: textScheme.label.copyWith(
          fontSize: 17,
          color: colorScheme.onSurface,
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 10,
        ),
      ),
      onChanged: onChanged,
    );
  }
}
