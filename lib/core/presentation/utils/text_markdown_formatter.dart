// text_markdown_formatter.dart
import 'package:flutter/material.dart';

class TextMarkdownFormatter {
  static TextEditingValue wrapSelection({
    required TextEditingValue value,
    required String left,
    String? right,
  }) {
    final String closing = right ?? left;

    final TextSelection selection = value.selection;
    if (!selection.isValid) {
      return value;
    }

    final String text = value.text;
    final int start = selection.start;
    final int end = selection.end;

    final String selected = text.substring(start, end);

    final String newText = text.replaceRange(
      start,
      end,
      '$left$selected$closing',
    );

    final int newCursorPosition =
        start + left.length + selected.length + closing.length;

    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newCursorPosition),
    );
  }

  static TextEditingValue toggleBold(TextEditingValue value) {
    return wrapSelection(value: value, left: '**');
  }

  static TextEditingValue toggleItalic(TextEditingValue value) {
    return wrapSelection(value: value, left: '*');
  }

  static TextEditingValue toggleCode(TextEditingValue value) {
    return wrapSelection(value: value, left: '`');
  }

  static TextEditingValue toggleStrike(TextEditingValue value) {
    return wrapSelection(value: value, left: '~~');
  }

  static TextEditingValue insertLink(TextEditingValue value) {
    final TextSelection selection = value.selection;
    final String selected = selection.isValid && !selection.isCollapsed
        ? value.text.substring(selection.start, selection.end)
        : 'text';

    final String replacement = '[$selected](https://)';

    final String newText = value.text.replaceRange(
      selection.start,
      selection.end,
      replacement,
    );

    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(
        offset: selection.start + replacement.length - 1,
      ),
    );
  }

  static String? selectedText(TextEditingValue value) {
    final TextSelection selection = value.selection;
    if (!selection.isValid || selection.isCollapsed) {
      return null;
    }

    final int start = selection.start;
    final int end = selection.end;

    if (start < 0 ||
        end < 0 ||
        start > value.text.length ||
        end > value.text.length) {
      return null;
    }

    return value.text.substring(start, end);
  }

  static TextEditingValue cutSelection(TextEditingValue value) {
    final TextSelection selection = value.selection;
    if (!selection.isValid || selection.isCollapsed) {
      return value;
    }

    final int start = selection.start;
    final int end = selection.end;

    final String newText = value.text.replaceRange(start, end, '');

    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: start),
    );
  }
}
