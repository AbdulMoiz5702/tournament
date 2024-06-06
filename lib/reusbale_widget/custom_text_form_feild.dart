import 'package:flutter/material.dart';

import '../consts/colors.dart';

class CustomTextFormField extends StatelessWidget {
  final String initialValue;
  final String labelText;
  final FormFieldSetter<String> onSaved;
  final FormFieldValidator<String>? validator;

  const CustomTextFormField({
    required this.initialValue,
    required this.labelText,
    required this.onSaved,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
      style: const TextStyle(color: whiteColor,fontSize: 14),
      decoration: InputDecoration(
        isDense: true,
        labelText: labelText,
        labelStyle: const TextStyle(color: buttonColors,fontWeight: FontWeight.bold),
        hintStyle: const TextStyle(color: whiteColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: iconColor, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: buttonColors, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: redColor, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: iconColor, width: 1),
        ),
      ),
      onSaved: onSaved,
      validator: validator ?? (value) => value!.isEmpty ? 'Please enter $labelText' : null,
    );
  }
}