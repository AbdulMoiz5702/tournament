import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:tournemnt/consts/colors.dart';
import 'package:tournemnt/controllers/call_controller.dart';
import 'package:tournemnt/reusbale_widget/custom_button.dart';
import 'package:tournemnt/reusbale_widget/custom_indicator.dart';
import 'package:tournemnt/reusbale_widget/custom_sizedBox.dart';
import 'package:tournemnt/reusbale_widget/custom_textfeild.dart';
import 'package:tournemnt/reusbale_widget/text_widgets.dart';
import 'package:tournemnt/reusbale_widget/toast_class.dart';

import '../controllers/add_challenges_controller.dart';

class AddChallengeScreen extends StatelessWidget {
  final String userId;
  const  AddChallengeScreen({required this.userId});
  @override
  Widget build(BuildContext context) {
    final key = GlobalKey<FormState>();
    var controller = Get.put(AddChallengesController());
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: largeText(title: 'Add Challenge',context: context),
      ),
      body: Padding(
        padding:const  EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Form(
            key: key,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Sized(height: 0.03,),
                Obx(
                  ()=> Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: secondaryWhiteColor,
                      borderRadius: BorderRadius.circular(10),
                      image: controller.selectedImage.value != null
                          ? DecorationImage(image: AssetImage(controller.selectedImage.value!))
                          : null,
                    ),
                    height: MediaQuery.sizeOf(context).height * 0.16,
                    width: MediaQuery.sizeOf(context).width * 0.3,
                    child:  IconButton(onPressed: (){
                      controller.selectImage(context);
                    }, icon: Icon(Icons.camera_alt_outlined,color:blueColor,),),
                  ),
                ),
                Sized(height: 0.03,),
                CustomTextField(controller: controller.teamName, hintText: 'Team Name',validate: (value){
                  return value.isEmpty ? 'Enter  Team Name': null ;
                },title: 'Team Name',),
                Sized(height: 0.03,),
                CustomTextField(validate: (value){
                  return value.isEmpty ? 'Enter  Challenger Name': null ;
                },controller: controller.captainName, hintText: 'Challenger Name',title: 'Challenger Name',),
                Sized(height: 0.03,),
                CustomTextField(
                  validate: (value){
                    return value.isEmpty ? 'Enter Phone No': null ;
                  },
                  controller: controller.leaderPhone, hintText: 'Phone No',keyboardType: TextInputType.number,title: 'Phone No',),
                Sized(height: 0.03,),
                CustomTextField(
                  validate: (value){
                    return value.isEmpty ? 'Enter Address': null ;
                  },
                  controller: controller.location, hintText: 'Address',keyboardType: TextInputType.streetAddress,title: 'Address',),
                Sized(height: 0.03,),
                CustomTextField(
                  validate: (value){
                    return value.isEmpty ? 'Enter Overs': null ;

                  },
                  controller: controller.matchOvers, hintText: 'Overs',keyboardType: TextInputType.number,title: 'Overs',),
                Sized(height: 0.03,),
                GestureDetector(
                  onTap: () {
                    controller.selectDate(context);
                  },
                  child: AbsorbPointer(
                    child: CustomTextField(
                      validate: (value){
                        return value.isEmpty ? 'Enter Start Date': null ;

                      },
                      controller: controller.startDateController,
                      hintText: 'Date',
                      title: 'Date',
                    ),
                  ),
                ),
                Sized(height: 0.05,),
               Obx(()=>  controller.isLoading.value == true ? const Center(child: CustomIndicator()):CustomButton(
                 onTap: () {
                   if(key.currentState!.validate()){
                     if(controller.selectedImage.value != null && controller.selectedImage.value!.isNotEmpty){
                       controller.addChallenge(context:context);
                     }else{
                       ToastClass.showToastClass(context: context, message: 'Please Select your Challenger Icon');
                     }
                   }else{
                     ToastClass.showToastClass(context: context, message: 'Please Fill all the Fields');
                   }
                 } ,
                 title: 'Add Challenge',
               ),),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

