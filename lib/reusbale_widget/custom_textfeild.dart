import 'package:flutter/material.dart';
import 'package:tournemnt/consts/colors.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final TextInputType keyboardType;
  final String ? title;
  final bool obscureText;
  final FormFieldValidator validate;
  const CustomTextField(
      {required this.controller,
      required this.hintText,
      this.keyboardType = TextInputType.text,
      this.title,
      required this.validate,
         this.obscureText = false ,
      });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscuringCharacter: '*',
      obscureText: obscureText,
      validator: validate,
      style: const TextStyle(color: secondaryTextColor, fontWeight: FontWeight.bold,fontSize: 14),
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        isDense: true,
        hintText: hintText,
        label: Text(title.toString(),style: const TextStyle(color: blueColor),),
        hintStyle: const TextStyle(color: secondaryTextColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: secondaryTextFieldColor, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: blueColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: redColor, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: secondaryTextFieldColor, width: 1),
        ),
      ),
    );
  }
}
