import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:tournemnt/consts/colors.dart';
import 'package:tournemnt/reusbale_widget/bg_widgets.dart';
import 'package:tournemnt/reusbale_widget/customLeading.dart';
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
    return BgWidget(
      child: Scaffold(
        backgroundColor: transparentColor,
        appBar: AppBar(
          backgroundColor: transparentColor,
         leading: CustomLeading(),
        ),
        body: Align(
          alignment: Alignment.bottomCenter,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding:  EdgeInsets.symmetric(horizontal: MediaQuery.sizeOf(context).width *0.08),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      largeText(title: 'Reset Password',color: whiteColor),
                      Sized(height: 0.005,),
                      smallText(title: 'Enter your valid email address we will send you a recovery email to reset your password.',color: secondaryTextColor,fontWeight: FontWeight.w500),
                      Sized(height: 0.05,),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                  height: MediaQuery.sizeOf(context).height * 0.68,
                  width: MediaQuery.sizeOf(context).width * 1,
                  decoration:  BoxDecoration(
                      color: whiteColor,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(40),
                        topLeft: Radius.circular(40),
                      )),
                  child: Form(
                    key: key,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: EdgeInsets.all(5),
                          height: MediaQuery.sizeOf(context).height * 0.065,
                          width: MediaQuery.sizeOf(context).width * 1,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: loginRegisterBarColor,
                          ),
                          child: Container(
                            width: MediaQuery.sizeOf(context).width * 0.1,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              border: Border.all(color: loginRegisterButtonBorderColor),
                              borderRadius: BorderRadius.circular(30),
                              color: whiteColor,
                            ),
                            child: mediumText(title: 'Reset Password ',fontSize: 14,fontWeight: FontWeight.w600),
                          ),
                        ),
                        CustomTextField(
                          validate: (value){
                            return value.isEmpty ? 'Enter Email': null ;
                          },
                          controller: authController.emailController, hintText: 'Enter Your Email',title:'Email'),
                        CustomButton(title: 'Send', onTap: () async{
                          if(key.currentState!.validate()){
                            try{
                              FirebaseAuth.instance.sendPasswordResetEmail(email: authController.emailController.text.toString()).then((value){
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
