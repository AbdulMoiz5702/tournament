// ignore_for_file: use_build_context_synchronously
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tournemnt/auth_screen/login_Screen.dart';
import 'package:tournemnt/consts/colors.dart';
import 'package:tournemnt/consts/images_path.dart';
import 'package:tournemnt/controllers/auth_controller.dart';
import 'package:tournemnt/reusbale_widget/bg_widgets.dart';
import 'package:tournemnt/reusbale_widget/custom_button.dart';
import 'package:tournemnt/reusbale_widget/custom_indicator.dart';
import 'package:tournemnt/reusbale_widget/custom_sizedBox.dart';
import 'package:tournemnt/reusbale_widget/custom_textfeild.dart';
import 'package:tournemnt/reusbale_widget/text_widgets.dart';
import 'package:tournemnt/reusbale_widget/toast_class.dart';

import '../reusbale_widget/customLeading.dart';



class SignupScreen extends StatelessWidget {
  var authController = Get.put(AuthController());
  SignupScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final key = GlobalKey<FormState>();
    return BgWidget(
      child: Scaffold(
        appBar: AppBar(
          leading: CustomLeading(),
          elevation: 0,
          backgroundColor: transparentColor,
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
                      largeText(title: 'Create your',color: whiteColor),
                      largeText(title: 'account',color: whiteColor),
                      Sized(height: 0.005,),
                      smallText(title: 'Enter Your Valid Information to Join our app.',color: secondaryTextColor,fontWeight: FontWeight.w500),
                      Sized(height: 0.05,),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 15),
                  height: MediaQuery.sizeOf(context).height * 0.75,
                  width: MediaQuery.sizeOf(context).width * 1,
                  decoration:const  BoxDecoration(
                    borderRadius: BorderRadius.only(topRight: Radius.circular(35),topLeft: Radius.circular(35)),
                    color: whiteColor,
                  ),
                  child: SingleChildScrollView(
                    child: Form(
                      key: key,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
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
                              children: [
                                GestureDetector(
                                  onTap: (){
                                    Get.offAll(()=> LoginPage());
                                  },
                                  child: Container(
                                    width: MediaQuery.sizeOf(context).width * 0.4,
                                    alignment: Alignment.center,
                                    child: mediumText(title: 'Login',fontSize: 14,fontWeight: FontWeight.w500,color: loginDisableButtonColor),
                                  ),
                                ),
                                Container(
                                  width: MediaQuery.sizeOf(context).width * 0.45,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: loginRegisterButtonBorderColor),
                                    borderRadius: BorderRadius.circular(30),
                                    color: whiteColor,
                                  ),
                                  child: mediumText(title: 'Register',fontSize: 14,fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                          Sized(
                            height: 0.02,
                          ),
                          CustomTextField(
                            imagePath: personIcon,
                            isDense: true,
                            validate: (value){
                              return value.isEmpty ? 'Enter Full Name': null ;
                            },
                            controller: authController.nameController,
                            hintText: 'Full Name',
                            title: 'Full Name',
                          ),
                          Sized(height: 0.02,),
                          CustomTextField(
                            isDense: true,
                            validate: (value){
                              return value.isEmpty ? 'Enter Email-ID': null ;
                            },
                            controller:  authController.emailController,
                            hintText: 'Email-ID',
                            title: 'Email-ID',
                          ),
                          Sized(
                            height: 0.02,
                          ),
                          CustomTextField(
                             imagePath: phoneIcon,
                              isDense: true,
                            validate: (value){
                              return value.isEmpty ? 'Enter Phone No.': null ;
                            },
                            controller:  authController.phoneController,
                            hintText: 'Phone No.',
                            keyboardType: TextInputType.number,
                            title:  'Phone No.'
                          ),
                          Sized(
                            height: 0.02,
                          ),
                          CustomTextField(
                            imagePath: signupAddress,
                            isDense: true,
                            validate: (value){
                              return value.isEmpty ? 'Enter Address': null ;
                            },
                            controller:  authController.location,
                            hintText: 'Address',
                            title:'Address',
                          ),
                          Sized(
                            height: 0.02,
                          ),
                          CustomTextField(
                            imagePath: passwordIcon,
                            isDense: true,
                            validate: (value){
                              return value.isEmpty ? 'Enter Password': null ;
                            },
                            controller:  authController.passwordController,
                            hintText: 'Password',
                            title: 'Password',
                          ),
                          Sized(
                            height: 0.02,
                          ),
                          CustomTextField(
                            imagePath: passwordIcon,
                            isDense: true,
                            validate: (value){
                              return value.isEmpty ? 'Confirm Password': null ;
                            },
                            controller: authController.confirmPassword,
                            hintText: 'Confirm Password',
                            title: 'Confirm Password',
                          ),
                          Sized(height: 0.03,),
                          Obx(() => authController.isLoading.value == true ?const  CustomIndicator():  CustomButton(
                              title: 'Create Account',
                              onTap: () {
                                if(key.currentState!.validate() ){
                                  if( authController.confirmPassword.text.trim() ==  authController.passwordController.text.trim()){
                                    authController.createAccount(context);
                                  }else{
                                    ToastClass.showToastClass(context: context, message: 'Confirm Password and Password must be same');
                                  }
                                }else{
                                  ToastClass.showToastClass(context: context, message: 'Please Fill all the Fields');
                                }
                              }),),
                          Sized(
                            height: 0.03,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              smallText(
                                title: 'Already have an account ?  ',
                                context: context,
                                color: iconColor,
                                fontSize: 14,
                                  fontWeight:FontWeight.w500
                              ),
                              InkWell(
                                  onTap: () {
                                    Get.to(()=> LoginPage());
                                  },
                                  child: smallText(
                                      title: 'Login', fontSize: 14, context: context,color: buttonColor,fontWeight:FontWeight.w500)),
                            ],
                          ),
                        ],
                      ),
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


