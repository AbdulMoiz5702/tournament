import 'package:flutter/material.dart';

import '../consts/colors.dart';


class CustomDateFormField extends StatefulWidget {
  final String initialValue;
  final String labelText;
  final FormFieldSetter<String> onSaved;
  final FormFieldValidator<String> validator;

  CustomDateFormField({
    required this.initialValue,
    required this.labelText,
    required this.onSaved,
    required this.validator,
  });

  @override
  _CustomDateFormFieldState createState() => _CustomDateFormFieldState();
}

class _CustomDateFormFieldState extends State<CustomDateFormField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.tryParse(widget.initialValue) ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      setState(() {
        _controller.text = pickedDate.toIso8601String().split('T').first;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _selectDate(context),
      child: AbsorbPointer(
        child: TextFormField(
          controller: _controller,
          style: const TextStyle(color: whiteColor,fontSize: 14),
          decoration: InputDecoration(
            isDense: true,
            labelText: widget.labelText,
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
          onSaved: (value) => widget.onSaved(_controller.text),
          validator: widget.validator,
        ),
      ),
    );
  }
}



