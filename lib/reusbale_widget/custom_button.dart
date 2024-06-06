import 'package:flutter/material.dart';
import 'package:tournemnt/consts/colors.dart';
import 'package:tournemnt/reusbale_widget/text_widgets.dart';


class CustomButton extends StatelessWidget {
  final String title ;
  final VoidCallback onTap;
  final double height ;
  final double width ;
  final Color color ;
  const CustomButton({required this.title,required this.onTap,this.height = 0.05,this.width = 0.5,this.color = blueColor});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        alignment: Alignment.center,
        height: MediaQuery.sizeOf(context).height *height ,
        width: MediaQuery.sizeOf(context).width * width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: color,
          gradient: LinearGradient(
            colors: [
              color.withOpacity(0.9), // Slightly darker at the start
              color.withOpacity(0.7),
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        child: mediumText(title: title,context: context,fontSize: 15,color: whiteColor),
      ),
    );
  }
}
