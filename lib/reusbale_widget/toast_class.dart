import 'package:flutter/material.dart';
import 'package:tournemnt/consts/colors.dart';


class ToastClass {

  static showToastClass ({required BuildContext context,required String message}) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backGroundColor,
        duration: Duration(seconds: 3),
      ),
    );
  }
}