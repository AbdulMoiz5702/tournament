import 'package:flutter/material.dart';
import 'package:tournemnt/consts/colors.dart';

Widget largeText(
    {required String title,
    context,
    double fontSize = 25,
    fontWeight = FontWeight.bold,
      color = primaryTextColor,
    }) {
  return Text(
    title,
    style: TextStyle(
        fontSize: MediaQuery.textScaleFactorOf(context).toDouble() * fontSize,
        fontWeight: FontWeight.bold,
      color: color,
    ),
  );
}

Widget mediumText(
    {required String title,
      context,
      double fontSize = 18,
      fontWeight = FontWeight.bold,
     Color color = primaryTextColor,
    }) {
  return Text(
    title,
    style: TextStyle(
      fontSize: MediaQuery.textScaleFactorOf(context).toDouble() * fontSize,
      fontWeight: FontWeight.bold,
      color: color,
    ),
  );
}


Widget smallText(
    {required String title,
      context,
      double fontSize = 12,
      fontWeight = FontWeight.w400,
      color = secondaryTextColor,
    }) {
  return Text(
    title,
    style: TextStyle(
      fontSize: MediaQuery.textScaleFactorOf(context).toDouble() * fontSize,
      fontWeight: fontWeight,
      color: color,
    ),
  );
}
