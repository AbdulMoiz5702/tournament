// ignore_for_file: use_build_context_synchronously
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:tournemnt/auth_screen/forgot_password-screen.dart';
import 'package:tournemnt/auth_screen/role_selection_screen.dart';
import 'package:tournemnt/consts/images_path.dart';
import 'package:tournemnt/reusbale_widget/bg_widgets.dart';
import 'package:tournemnt/reusbale_widget/custom_button.dart';
import 'package:tournemnt/reusbale_widget/custom_sizedBox.dart';
import 'package:tournemnt/reusbale_widget/custom_textfeild.dart';
import 'package:tournemnt/reusbale_widget/text_widgets.dart';
import '../consts/colors.dart';
import '../controllers/auth_controller.dart';
import '../reusbale_widget/custom_indicator.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var authController = Get.put(AuthController());
    final  key = GlobalKey<FormState>();
    return BgWidget(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor:transparentColor ,
        ),
        backgroundColor: transparentColor,
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
                      largeText(title: 'Go ahead and set up',color: whiteColor),
                      largeText(title: 'your account',color: whiteColor),
                      Sized(height: 0.005,),
                      smallText(title: 'Sign in-up to enjoy the best managing experience',color: secondaryTextColor,fontWeight: FontWeight.w500),
                      Sized(height: 0.05,),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20,vertical: 15),
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
                      children: [
                        Container(
                          padding: EdgeInsets.all(5),
                          height: MediaQuery.sizeOf(context).height * 0.065,
                          width: MediaQuery.sizeOf(context).width * 1,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: loginRegisterBarColor,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: MediaQuery.sizeOf(context).width * 0.45,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  border: Border.all(color: loginRegisterButtonBorderColor),
                                  borderRadius: BorderRadius.circular(30),
                                  color: whiteColor,
                                ),
                                child: mediumText(title: 'Login',fontSize: 14,fontWeight: FontWeight.w600),
                              ),
                              GestureDetector(
                                onTap: (){
                                  Get.offAll(()=> RoleSelectionScreen());
                                },
                                child: Container(
                                  width: MediaQuery.sizeOf(context).width * 0.4,
                                  alignment: Alignment.center,
                                  child: mediumText(title: 'Register',fontSize: 14,fontWeight: FontWeight.w500,color: loginDisableButtonColor),
                                ),
                              )
                            ],
                          ),
                        ),
                        Sized(
                          height: 0.07,
                        ),
                        CustomTextField(
                          imagePath: emailIcon,
                          validate: (value) {
                            return value.isEmpty ? 'Enter Email': null ;
                          },
                          controller: authController.emailController,
                          hintText: 'E-mail ID',
                          title: 'Email',
                        ),
                        Sized(
                          height: 0.03,
                        ),
                        CustomTextField(
                          imagePath: passwordIcon,
                          validate: (value) {
                            return value.isEmpty ? 'Enter password': null ;
                          },
                          controller: authController.passwordController,
                          hintText: 'Password',
                          title: 'Password',
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Obx(
                                      ()=> Checkbox(
                                        activeColor: forgotPasswordColor,
                                      side: BorderSide(color: forgotPasswordColor),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      value: authController.isCheck.value, onChanged: (newValue){
                                    authController.isCheck.value = newValue!;
                                  }),
                                ),
            
                                smallText(title: 'Remember me',color: loginDisableButtonColor,fontWeight: FontWeight.w600),
                              ],
                            ),
                            GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      CupertinoPageRoute(
                                          builder: (context) => ForgotScreen()));
                                },
                                child: smallText(
                                    title: 'Forgot Password?',
                                    context: context,
                                    fontWeight: FontWeight.w600,
                                    color: forgotPasswordColor)),
                          ],
                        ),
                        Sized(
                          height: 0.03,
                        ),
                        Obx(() =>authController.isLoading.value == true ? const CustomIndicator(): CustomButton(
                            title: 'Login',
                            onTap: () {
                              if(key.currentState!.validate()){
                                authController.signInWithEmailPassword(context);
                              }
                            }),),
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
