import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tournemnt/consts/colors.dart';


Widget largeText({
  required String title,
  context,
  double fontSize = 25,
  double height = 1.1,
  fontWeight = FontWeight.w700,
  color = loginEnabledButtonColor,
}) {
  return Text(
    title,
    style: GoogleFonts.poppins(
        textStyle: TextStyle(
          height: height.toDouble(),
          fontSize: fontSize.toDouble(),
          fontWeight: fontWeight,
          color: color,
        )),
  );
}

Widget mediumText({
  required String title,
  context,
  double fontSize = 14,
  fontWeight = FontWeight.bold,
  Color color = loginEnabledButtonColor,
}) {
  return Text(
    title,
    style: GoogleFonts.poppins(
        textStyle: TextStyle(
          fontSize: fontSize.toDouble(),
          fontWeight: fontWeight,
          color: color,
        )),
  );
}

Widget smallText({
  required String title,
  context,
  double fontSize = 12,
  fontWeight = FontWeight.w400,
  color = secondaryTextColor,
}) {
  return Text(
    title,
    style: GoogleFonts.poppins(
        textStyle: TextStyle(
          fontSize: fontSize.toDouble(),
          fontWeight: fontWeight,
          color: color,
        )),
    softWrap: true,
    maxLines: 10,
    overflow: TextOverflow.ellipsis,
  );
}






class TextWidgets {

  static TextStyle smallTextStyle({
    double fontSize = 12,
    fontWeight = FontWeight.w400,
    color = secondaryTextColor,
    TextOverflow overflow = TextOverflow.clip
  }) {
    return GoogleFonts.poppins(
        textStyle: TextStyle(
          color: color,
          fontWeight: fontWeight,
          fontSize: fontSize.toDouble(),
          overflow: overflow,
        ));
  }

  static TextStyle mediumTextStyle({
    double fontSize = 14,
    fontWeight = FontWeight.bold,
    Color color = loginEnabledButtonColor,
    TextOverflow overflow = TextOverflow.clip
  }) {
    return GoogleFonts.poppins(
        textStyle: TextStyle(
          color: color,
          fontWeight: fontWeight,
          fontSize: fontSize.toDouble(),
          overflow: overflow,
        ));
  }

  static TextStyle largeTextStyle({
    double fontSize = 25,
    double height = 1.1,
    fontWeight = FontWeight.w700,
    color = loginEnabledButtonColor,
    TextOverflow overflow = TextOverflow.clip
  }) {
    return GoogleFonts.poppins(
        textStyle: TextStyle(
          color: color,
          fontWeight: fontWeight,
          fontSize: fontSize.toDouble(),
          overflow: overflow,
        ));
  }




}
