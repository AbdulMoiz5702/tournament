import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:tournemnt/auth_screen/login_Screen.dart';
import 'package:tournemnt/auth_screen/signpScreen.dart';
import 'package:tournemnt/controllers/auth_controller.dart';
import 'package:tournemnt/reusbale_widget/bg_widgets.dart';
import 'package:tournemnt/reusbale_widget/custom_button.dart';

import '../consts/colors.dart';
import '../reusbale_widget/custom_sizedBox.dart';
import '../reusbale_widget/text_widgets.dart';
import '../reusbale_widget/toast_class.dart';


class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(AuthController());
    return BgWidget(child: Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
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
                smallText(title: 'Sign in-up to enjoy the best managing experience',color: secondaryTextColor,fontWeight: FontWeight.w500),
                Sized(height: 0.05,),
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20,vertical: 15),
                height: MediaQuery.sizeOf(context).height * 0.68,
                width: MediaQuery.sizeOf(context).width * 1,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(topRight: Radius.circular(35),topLeft: Radius.circular(35)),
                  color: whiteColor,
                ),
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
                    Sized(height: 0.05,),
                    Obx(
                        ()=> Column(
                        children: List.generate(controller.roles.length, (index){
                          return GestureDetector(
                            onTap: (){
                              controller.changeIndex(index,controller.roles[index]);
                              print(controller.myRole);
                            },
                            child: Container(
                              margin: EdgeInsets.only(top:10),
                              width: MediaQuery.sizeOf(context).width * 1,
                              height: MediaQuery.sizeOf(context).height * 0.07,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                border: Border.all(color: controller.currentIndex.value == index ? buttonColor: loginRegisterBarColor),
                                borderRadius: BorderRadius.circular(30),
                                color: whiteColor,
                              ),
                              child: mediumText(title: controller.roles[index],fontSize: 14,fontWeight: FontWeight.w600,color: controller.currentIndex.value == index ? buttonColor:loginDisableButtonColor),
                            ),
                          );
                        }),
                      ),
                    ),
                    Sized(height: 0.05,),
                    CustomButton(title: 'Continue', onTap: (){
                      if(controller.myRole.isNotEmpty ){
                        Get.to(()=> SignupScreen());
                      }else{
                        ToastClass.showToastClass(context: context, message: 'Please Select Role in your team');
                      }
                    })
                  ],
                ),
              ),
            ],
          ),
        ],
      )
    ));
  }
}
