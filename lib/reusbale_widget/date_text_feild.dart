import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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


  _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.tryParse(widget.initialValue) ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            datePickerTheme: DatePickerThemeData(
              dividerColor: whiteColor,
              confirmButtonStyle: ButtonStyle(
                foregroundColor: WidgetStateProperty.all<Color>(whiteColor),
                backgroundColor: WidgetStateProperty.all<Color>(cardBgColor),
              ),
              cancelButtonStyle: ButtonStyle(
                foregroundColor: WidgetStateProperty.all<Color>(whiteColor),
                backgroundColor: WidgetStateProperty.all<Color>(cardCallButtonColor),
              ),
            ),
            colorScheme:  ColorScheme.light(
              primary: cardTextColor, // Header background color
              onPrimary: whiteColor, // Header text color
              surface: cardTextColor, // Background color of calendar picker
              onSurface: whiteColor, // Text color
            ),
            dialogBackgroundColor: cardTextColor,
          ),
          child: child!,
        );
      },
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
          style: const TextStyle(color: secondaryTextColor, fontWeight: FontWeight.bold,fontSize: 14),
          decoration: InputDecoration(
            isDense: true,
            labelText: widget.labelText,
            labelStyle: const TextStyle(color: loginDisableButtonColor,fontWeight: FontWeight.w500,fontSize: 14),
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
          onSaved: (value) => widget.onSaved(_controller.text),
          validator: widget.validator,
        ),
      ),
    );
  }
}


class CustomTimeFormField extends StatefulWidget {
  final String initialValue;
  final String labelText;
  final FormFieldSetter<String> onSaved;
  final FormFieldValidator<String> validator;

  CustomTimeFormField({
    required this.initialValue,
    required this.labelText,
    required this.onSaved,
    required this.validator,
  });

  @override
  _CustomTimeFormFieldState createState() => _CustomTimeFormFieldState();
}

class _CustomTimeFormFieldState extends State<CustomTimeFormField> {
  late TextEditingController _controller;
  late TimeOfDay _selectedTime;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
    _selectedTime = _parseInitialTime(widget.initialValue);
  }

  TimeOfDay _parseInitialTime(String time) {
    try {
      final parts = time.split(":");
      final hour = int.parse(parts[0]);
      final minute = int.parse(parts[1]);
      return TimeOfDay(hour: hour, minute: minute);
    } catch (e) {
      return TimeOfDay.now();
    }
  }

  Future<void> selectTime(BuildContext context) async {
    var theme = Theme.of(context);
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      builder: (BuildContext context, Widget? child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
            child: Theme(
              data: ThemeData.light().copyWith(
                timePickerTheme: TimePickerThemeData(
                  entryModeIconColor: whiteColor,
                  helpTextStyle: TextStyle(color: whiteColor),
                  dayPeriodBorderSide: BorderSide(color: cardBgColor),
                  confirmButtonStyle: ButtonStyle(
                    foregroundColor: WidgetStateProperty.all<Color>(whiteColor),
                    backgroundColor: WidgetStateProperty.all<Color>(cardBgColor),
                  ),
                  cancelButtonStyle: ButtonStyle(
                    foregroundColor: WidgetStateProperty.all<Color>(whiteColor),
                    backgroundColor: WidgetStateProperty.all<Color>(cardCallButtonColor),
                  ),
                  dialTextColor: blackColor,
                  backgroundColor: cardTextColor,
                  hourMinuteTextColor: whiteColor,
                  dialHandColor: loginEnabledButtonColor,
                  dialBackgroundColor:whiteColor,
                  shape: RoundedRectangleBorder(
                    side:  BorderSide(color: theme.scaffoldBackgroundColor),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  dayPeriodColor: WidgetStateColor.resolveWith(
                        (states) => theme.scaffoldBackgroundColor, // Set to white
                  ),
                  dayPeriodTextColor: WidgetStateColor.resolveWith(
                        (states) => whiteColor,
                  ),
                  dayPeriodShape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero, // Remove the border radius
                    side: BorderSide.none, // Remove the border
                  ),
                  hourMinuteColor: WidgetStateColor.resolveWith(
                        (states) => theme.scaffoldBackgroundColor, // Change this to white
                  ),
                  hourMinuteShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  inputDecorationTheme: InputDecorationTheme(
                    fillColor: theme.scaffoldBackgroundColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  dayPeriodTextStyle:  TextStyle(
                    color: buttonColor,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              child: child!,
            ),
          );
        },
    );

    if (picked != null) {
      setState(() {
        _selectedTime = picked;
        _controller.text = formatTime(picked);
      });
    }
  }

  String formatTime(TimeOfDay time) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return DateFormat.jm().format(dt);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => selectTime(context),
      child: AbsorbPointer(
        child: TextFormField(
          controller: _controller,
          style: const TextStyle(color: secondaryTextColor, fontWeight: FontWeight.bold,fontSize: 14),
          decoration: InputDecoration(
            isDense: true,
            labelText: widget.labelText,
            labelStyle: const TextStyle(color: loginDisableButtonColor,fontWeight: FontWeight.w500,fontSize: 14),
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
          onSaved: (value) => widget.onSaved(_controller.text),
          validator: widget.validator,
        ),
      ),
    );
  }
}




