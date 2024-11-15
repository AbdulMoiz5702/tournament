import 'package:flutter/material.dart';
import 'package:tournemnt/consts/images_path.dart';


class CustomIndicator extends StatelessWidget {
  const CustomIndicator({this.height = 0.03,this.width =0.07});
  final double height;
  final double width ;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.sizeOf(context).height * height,
      width:MediaQuery.sizeOf(context).width * width,
      decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage(loadingGif),fit: BoxFit.cover,invertColors: true)
      ),
    );
  }
}
