import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tournemnt/consts/colors.dart';
import 'package:tournemnt/consts/images_path.dart';
import 'package:tournemnt/reusbale_widget/custom_sizedBox.dart';
import 'package:tournemnt/reusbale_widget/text_widgets.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final TextInputType keyboardType;
  final String ? title;
  final String  imagePath;
  final bool obscureText;
  final FormFieldValidator validate;
  final bool isDense ;
  final bool isMaxLines;
  final bool showLeading;
  final VoidCallback ? onTap ;

  const CustomTextField(
      {required this.controller,
        this.imagePath = emailIcon,
        this.showLeading = true,
      required this.hintText,
      this.keyboardType = TextInputType.text,
      this.title,
      required this.validate,
         this.obscureText = false ,
        this.isDense =false,
        this.isMaxLines = false,
        this.onTap,
      });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: onTap,
      maxLines: isMaxLines == true ? 5: 1,
      obscuringCharacter: '*',
      obscureText: obscureText,
      validator: validate,
      style: const TextStyle(color: secondaryTextColor, fontWeight: FontWeight.bold,fontSize: 14),
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            showLeading == false ? Sized() : SvgPicture.asset(imagePath),
            Sized(width: 0.05,),
            mediumText(title: hintText,fontWeight: FontWeight.w500,color: loginDisableButtonColor)
          ],
        ),
        isDense: isDense,
        hintStyle: const TextStyle(color: loginDisableButtonColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: loginRegisterButtonBorderColor, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: loginRegisterButtonBorderColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: redColor, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: loginRegisterButtonBorderColor, width: 1),
        ),
      ),
    );
  }
}
