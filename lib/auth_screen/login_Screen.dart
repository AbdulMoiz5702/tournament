// ignore_for_file: use_build_context_synchronously
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:tournemnt/auth_screen/forgot_password-screen.dart';
import 'package:tournemnt/auth_screen/signpScreen.dart';
import 'package:tournemnt/consts/images_path.dart';
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
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: Form(
            key: key,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Sized(height: 0.04,),
                Image.asset(appLogo,height: MediaQuery.sizeOf(context).height * 0.2,alignment: Alignment.center,),
                Sized(
                  height: 0.03,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                    child: largeText(title: 'Let\'s you Login',context: context)),
                Sized(
                  height: 0.001,
                ),
                Align(
                    alignment: Alignment.centerLeft,
                    child: smallText(title: 'Enter your email and password.',context: context)),
                Sized(
                  height: 0.015,
                ),
                CustomTextField(
                  validate: (value) {
                    return value.isEmpty ? 'Enter Email': null ;
                  },
                  controller: authController.emailController,
                  hintText: 'Email',
                  title: 'Email',
                ),
                Sized(
                  height: 0.02,
                ),
                CustomTextField(
                  validate: (value) {
                    return value.isEmpty ? 'Enter password': null ;
                  },
                  controller: authController.passwordController,
                  hintText: 'Password',
                  title: 'Password',
                ),
                Sized(
                  height: 0.03,
                ),
                Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) => ForgotScreen()));
                        },
                        child: smallText(
                            title: 'Forgot Password ?',
                            context: context,
                            fontSize: 12,
                            color: blueColor))),
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
                Sized(
                  height: 0.2,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    smallText(
                      title: 'Don\'t have an account ? ',
                      context: context,
                    ),
                    InkWell(
                        onTap: () {
                         Get.to(()=> SignupScreen());
                        },
                        child: smallText(
                            title: 'Create an account', fontSize: 16, context: context,color: blueColor)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
