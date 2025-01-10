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
      style: const TextStyle(color: secondaryTextColor, fontWeight: FontWeight.bold,fontSize: 14),
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(color: loginDisableButtonColor,fontWeight: FontWeight.w500,fontSize: 14),
        isDense: true,
        hintStyle: const TextStyle(color: loginDisableButtonColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: loginRegisterButtonBorderColor, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: loginRegisterButtonBorderColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: redColor, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: loginRegisterButtonBorderColor, width: 1),
        ),
      ),
      onSaved: onSaved,
      validator: validator ?? (value) => value!.isEmpty ? 'Please enter $labelText' : null,
    );
  }
}