
import 'package:flutter/material.dart';

import '../consts/images_path.dart';



class BgWidget extends StatelessWidget {
  final Widget child ;
  const BgWidget({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return  Container(
      height: MediaQuery.sizeOf(context).height * 1,
      width :MediaQuery.sizeOf(context).width * 1,
      decoration: const BoxDecoration(
        image: DecorationImage(image: AssetImage(bgImage),fit: BoxFit.cover),
      ),
      child: child,
    ) ;
  }
}