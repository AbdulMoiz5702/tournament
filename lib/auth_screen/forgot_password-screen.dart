import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tournemnt/consts/colors.dart';
import 'package:tournemnt/reusbale_widget/customLeading.dart';
import 'package:tournemnt/reusbale_widget/custom_button.dart';
import 'package:tournemnt/reusbale_widget/custom_sizedBox.dart';
import 'package:tournemnt/reusbale_widget/custom_textfeild.dart';
import 'package:tournemnt/reusbale_widget/text_widgets.dart';
import 'package:tournemnt/reusbale_widget/toast_class.dart';
import 'package:tournemnt/reusbale_widget/tournment-card.dart';

import '../consts/images_path.dart';


class ForgotScreen extends StatefulWidget {
  const ForgotScreen({super.key});

  @override
  State<ForgotScreen> createState() => _ForgotScreenState();
}

class _ForgotScreenState extends State<ForgotScreen> {
  TextEditingController emailController = TextEditingController();
  final key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Form(
          key: key,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Sized(height: 0.04,),
              Image.asset(appLogo,height: MediaQuery.sizeOf(context).height * 0.2,alignment: Alignment.center,),
              Sized(
                height: 0.03,
              ),
              Align(
                  alignment: Alignment.centerLeft,
                  child: largeText(title: 'Forget Password',context: context)),
              Sized(
                height: 0.001,
              ),
              Align(
                  alignment: Alignment.centerLeft,
                  child: smallText(title: 'Enter your valid email Address we will send you a recovery email to reset your Password.',context: context)),
              Sized(height:0.05,),
              CustomTextField(
                validate: (value){
                  return value.isEmpty ? 'Enter Email': null ;
                },
                controller: emailController, hintText: 'Conformation Email',title:'Email'),
              Sized(height:0.05,),
              CustomButton(title: 'Reset Password', onTap: () async{
                if(key.currentState!.validate()){
                  try{
                    FirebaseAuth.instance.sendPasswordResetEmail(email: emailController.text.toString()).then((value){
                      ToastClass.showToastClass(context: context, message: " Password email has send to the ${emailController.text.toString()}");
                    });
                  }catch(e){
                    ToastClass.showToastClass(context: context, message: "Something went wrong Error : $e");
                  }
                }
              }),
            ],
          ),
        ),
      ),
    );
  }
}
