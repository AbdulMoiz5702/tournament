import 'package:flutter/material.dart';
import 'package:tournemnt/consts/colors.dart';


class CustomLeading extends StatelessWidget {
  const CustomLeading({super.key});

  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
      onTap: (){
        Navigator.pop(context);
      },
      child: Container(
        margin: EdgeInsets.all(6),
        padding: EdgeInsets.all(3),
        decoration:const  BoxDecoration(
          shape: BoxShape.circle,
          color: listTileColor,
        ),
        child: Center(child: Icon(Icons.arrow_back_ios,color: iconColor,))
      ),
    );
  }
}
