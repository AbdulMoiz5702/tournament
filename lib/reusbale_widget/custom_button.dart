import 'package:flutter/material.dart';
import 'package:tournemnt/consts/colors.dart';
import 'package:tournemnt/reusbale_widget/text_widgets.dart';


class CustomButton extends StatelessWidget {
  final String title ;
  final VoidCallback onTap;
  final double height ;
  final double width ;
  final Color color ;
  final double fontSize;
  final FontWeight fontWeight ;
  const CustomButton({required this.title,required this.onTap,this.height = 0.06,this.width = 1,this.color = buttonColor,this.fontSize = 16.0,this.fontWeight = FontWeight.w700});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        alignment: Alignment.center,
        height: MediaQuery.sizeOf(context).height *height ,
        width: MediaQuery.sizeOf(context).width * width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: color,
        ),
        child: mediumText(title: title,context: context,fontSize: fontSize.toDouble(),color: whiteColor,fontWeight:fontWeight ),
      ),
    );
  }
}
