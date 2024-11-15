import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:tournemnt/reusbale_widget/custom_button.dart';
import 'package:tournemnt/reusbale_widget/custom_indicator.dart';
import 'package:tournemnt/reusbale_widget/custom_textfeild.dart';
import 'package:tournemnt/reusbale_widget/text_widgets.dart';
import 'package:tournemnt/reusbale_widget/toast_class.dart';

import '../consts/colors.dart';
import '../controllers/add_team_to_challnege_controller.dart';
import '../reusbale_widget/custom_sizedBox.dart';

class AddTeamToChallengeScreen extends StatelessWidget {
  final String challengeId;
  final String userId ;
  const AddTeamToChallengeScreen(this.challengeId,this.userId, {super.key});
  @override
  Widget build(BuildContext context) {
    final key = GlobalKey<FormState>();
    var controller = Get.put(AddTeamToChallenge());
    return Scaffold(
      appBar: AppBar(
        title: largeText(title: 'Add Team to Challenge',context: context),
      ),
      body: Padding(
        padding:const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Form(
            key: key,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
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
                Sized(width: 0.03,),
                CustomTextField(
                    validate: (value){
                      return value.isEmpty ? 'Enter Team Name ': null ;
                    },
                    controller: controller.teamNameController, hintText: 'Team Name',title: 'Team Name',),
                Sized(height: 0.03,),
                CustomTextField(
                    validate: (value){
                      return value.isEmpty ? 'Enter Leader Name ': null ;
                    },
                    controller: controller.teamLeaderName, hintText: 'Leader Name',title: 'Leader Name',),
                Sized(height: 0.03,),
                CustomTextField(
                  validate: (value){
                    return value.isEmpty ? 'Enter Phone No ': null ;
                  },
                  controller: controller.teamLeaderPhone, hintText: 'Phone No',keyboardType: TextInputType.number,title: 'Phone No',),
                Sized(height: 0.03,),
                CustomTextField(
                  validate: (value){
                    return value.isEmpty ? 'Enter Address': null ;
                  },
                  controller: controller.location, hintText: 'Address',title: 'Address',),
                Sized(height: 0.05,),
                Obx(()=> controller.isLoading.value == true ?Center(child: CustomIndicator()):CustomButton(
                  onTap: () {
                    if(key.currentState!.validate()){
                      if(controller.selectedImage.value != null && controller.selectedImage.value!.isNotEmpty){
                        controller.addTeam(context: context,challengeId: challengeId);
                      }else{
                      }
                    }else{
                      ToastClass.showToastClass(context: context, message: 'Please Fill all the Fields');
                    }
                  },
                  title: 'Add Team',
                ),),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
