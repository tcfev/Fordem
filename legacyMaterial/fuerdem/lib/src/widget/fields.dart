
import 'package:flutter/material.dart';
import 'package:fuerdem/src/config/constants/style.dart';

/// Decorated Text field for fields
class DecoratedTextField extends StatelessWidget {
  const DecoratedTextField(
      {Key key,
        this.controller,
        this.placeholder,
        this.maxLines,
        this.maxLength,
        this.obscureText,
        this.obscuringCharacter,
        this.minLines, this.onChange, this.keyboardType, this.counterText, this.label})
      : super(key: key);

  final TextEditingController controller;
  final String placeholder, obscuringCharacter;
  final int minLines, maxLines, maxLength;
  final bool obscureText;
  // ignore: inference_failure_on_function_return_type
  final Function(String text) onChange;
  final TextInputType keyboardType;
  final String counterText;
  final String label;

  @override
  Widget build(BuildContext context) => TextField(
    obscureText: obscureText ?? false,
    minLines: minLines ?? 1,
    obscuringCharacter: obscuringCharacter ?? '•',
    maxLines: maxLines ?? 1,
    onChanged: onChange,
    maxLength: maxLength,
    keyboardType: keyboardType,
    controller: controller,
    decoration: furdemInputDecoration(placeholder, counterText, label),
  );
}
