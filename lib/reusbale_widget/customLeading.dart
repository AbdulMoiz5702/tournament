import 'package:flutter/material.dart';
import 'package:tournemnt/consts/colors.dart';



class CustomLeading extends StatelessWidget {
  const CustomLeading({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.pop(context);
      },
      child: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.all(12),
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color:transparentColor,
            border: Border.all(color: buttonColor)
        ),
        child: Icon(Icons.arrow_back,color: whiteColor,size: 18,),
      ),
    );
  }
}
