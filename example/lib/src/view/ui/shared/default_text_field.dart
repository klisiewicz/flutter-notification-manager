import 'package:flutter/material.dart';

typedef TextFieldValidator = FormFieldValidator<String>;

class DefaultTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String labelText;
  final TextFieldValidator? validator;

  const DefaultTextField({
    required this.labelText,
    this.controller,
    this.validator,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: labelText,
      ),
    );
  }
}
