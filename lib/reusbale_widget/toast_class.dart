import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:tournemnt/consts/colors.dart';

class ToastClass {

  static showToastClass ({required BuildContext context,required String message}) {
    return Future(() {
      return showToast(message,
        backgroundColor: listTileLeadingColor,
        borderRadius: BorderRadius.circular(10),
        context: context,
        animation: StyledToastAnimation.scale,
        reverseAnimation: StyledToastAnimation.fade,
        position: StyledToastPosition.top,
        animDuration: Duration(seconds: 1),
        duration: Duration(seconds: 4),
        curve: Curves.elasticOut,
        reverseCurve: Curves.linear,
      );
    });
  }
}