import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:tournemnt/reusbale_widget/custom_button.dart';
import 'package:tournemnt/reusbale_widget/custom_sizedBox.dart';
import 'package:tournemnt/reusbale_widget/custom_textfeild.dart';
import 'package:tournemnt/reusbale_widget/text_widgets.dart';
import 'package:tournemnt/reusbale_widget/toast_class.dart';
import '../consts/images_path.dart';
import '../controllers/auth_controller.dart';


class ForgotScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var authController = Get.put(AuthController());
    final key = GlobalKey<FormState>();
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
                controller: authController.emailController, hintText: 'Conformation Email',title:'Email'),
              Sized(height:0.05,),
              CustomButton(title: 'Reset Password', onTap: () async{
                if(key.currentState!.validate()){
                  try{
                    FirebaseAuth.instance.sendPasswordResetEmail(email: authController.emailController.text.toString()).then((value){
                      ToastClass.showToastClass(context: context, message: " Password email has been sent");
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
