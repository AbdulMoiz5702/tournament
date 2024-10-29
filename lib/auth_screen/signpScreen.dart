// ignore_for_file: use_build_context_synchronously
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tournemnt/auth_screen/login_Screen.dart';
import 'package:tournemnt/consts/colors.dart';
import 'package:tournemnt/controllers/auth_controller.dart';
import 'package:tournemnt/reusbale_widget/custom_button.dart';
import 'package:tournemnt/reusbale_widget/custom_sizedBox.dart';
import 'package:tournemnt/reusbale_widget/custom_textfeild.dart';
import 'package:tournemnt/reusbale_widget/text_widgets.dart';
import 'package:tournemnt/reusbale_widget/toast_class.dart';


class SignupScreen extends StatelessWidget {
  var authController = Get.put(AuthController());
  @override
  Widget build(BuildContext context) {
    final key = GlobalKey<FormState>();
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: Form(
            key: key,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Sized(
                  height: 0.06,
                ),
                Sized(
                  height: 0.03,
                ),
                Align(
                    alignment: Alignment.centerLeft,
                    child: largeText(title: 'Create Account',context: context)),
                Sized(
                  height: 0.001,
                ),
                Align(
                    alignment: Alignment.centerLeft,
                    child: smallText(title: 'Enter your valid information to join our app.',context: context)),
                Sized(
                  height: 0.02,
                ),
                CustomTextField(
                  validate: (value){
                    return value.isEmpty ? 'Enter UserName': null ;
                  },
                  controller: authController.nameController,
                  hintText: 'Username',
                  title: 'Username',
                ),
                Sized(
                  height: 0.02,
                ),
                CustomTextField(
                  validate: (value){
                    return value.isEmpty ? 'Enter Phone No': null ;
                  },
                  controller:  authController.phoneController,
                  hintText: 'Phone',
                  keyboardType: TextInputType.number,
                  title:  'Phone'
                ),
                Sized(
                  height: 0.02,
                ),
                CustomTextField(
                  validate: (value){
                    return value.isEmpty ? 'Enter Address': null ;
                  },
                  controller:  authController.location,
                  hintText: 'Address',
                  title:'Address',
                ),
                Sized(height: 0.02,),
                CustomTextField(
                  validate: (value){
                    return value.isEmpty ? 'Enter Email': null ;
                  },
                  controller:  authController.emailController,
                  hintText: 'Email',
                  title: 'Email',
                ),
                Sized(
                  height: 0.02,
                ),
                CustomTextField(
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
                  validate: (value){
                    return value.isEmpty ? 'Retype Password': null ;
                  },
                  controller: authController.confirmPassword,
                  hintText: 'Confirm Password',
                  title: 'Confirm Password',
                ),
                Sized(height: 0.03,),
                Align(
                  alignment: Alignment.centerLeft,
                    child: smallText(title: 'My Role in Team:',context: context,fontSize: 10,color: iconColor)),
                Sized(height: 0.01,),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate( authController.roles.length, (index) {
                  return InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () {
                        authController.myRole.value =  authController.roles[index];
                    },
                    child: Container(
                      margin: const EdgeInsets.only(left: 5),
                      child: Chip(
                        autofocus: true,
                        backgroundColor:  authController.myRole.value ==  authController.roles[index]
                            ? blueColor// Highlight selected role
                            : secondaryWhiteColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        label: smallText(
                          title:  authController.roles[index],
                          context: context,
                          fontSize: 10,
                          color: authController.myRole.value ==  authController.roles[index] ?  whiteColor : secondaryTextColor
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
                Sized(
                  height: 0.03,
                ),
                Obx(() => authController.isLoading.value == true ?const  Center(child: CircularProgressIndicator(color: blueColor,),):  CustomButton(
                    title: 'Create Account',
                    onTap: () {
                      if(key.currentState!.validate() ){
                        if( authController.confirmPassword.text.toString() ==  authController.passwordController.text.toString()){
                          if( authController.myRole.isNotEmpty){
                            authController.createAccount(context);
                          }else{
                            ToastClass.showToastClass(context: context, message: 'Please Select Role in your team');
                          }
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
                      color: iconColor
                    ),
                    InkWell(
                        onTap: () {
                          Get.to(()=> LoginPage());
                        },
                        child: smallText(
                            title: 'Login', fontSize: 16, context: context,color: blueColor)),
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


