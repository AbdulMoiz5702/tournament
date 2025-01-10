import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tournemnt/consts/images_path.dart';
import 'package:tournemnt/reusbale_widget/bg_widgets.dart';
import 'package:tournemnt/reusbale_widget/custom_button.dart';
import 'package:tournemnt/reusbale_widget/custom_indicator.dart';
import 'package:tournemnt/reusbale_widget/custom_textfeild.dart';
import 'package:tournemnt/reusbale_widget/text_widgets.dart';
import 'package:tournemnt/reusbale_widget/toast_class.dart';

import '../consts/colors.dart';
import '../controllers/add_team_to_challnege_controller.dart';
import '../reusbale_widget/customLeading.dart';
import '../reusbale_widget/custom_sizedBox.dart';

class AddTeamToChallengeScreen extends StatelessWidget {
  final String challengeId;
  final String userId ;
  const AddTeamToChallengeScreen(this.challengeId,this.userId, {super.key});
  @override
  Widget build(BuildContext context) {
    final key = GlobalKey<FormState>();
    var controller = Get.put(AddTeamToChallenge());
    return BgWidget(
      child: Scaffold(
        backgroundColor: transparentColor,
        appBar: AppBar(
          leading: CustomLeading(),
          bottom: PreferredSize(
            preferredSize: Size(double.infinity, 55),
            child: Padding(
              padding: EdgeInsets.only(
                  left: MediaQuery.sizeOf(context).width * 0.1),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Sized(height: 0.005),
                      largeText(
                        title: 'Add Team to Challenge',
                        context: context,
                        fontWeight: FontWeight.w500,
                        color: whiteColor,
                      ),
                      Sized(height: 0.005),
                      smallText(
                        title: 'Enter Your Valid Information .',
                        color: secondaryTextColor.withOpacity(0.85),
                        fontWeight: FontWeight.w500,
                      ),
                      Sized(height: 0.005),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 15,vertical: 8),
          color: whiteColor,
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Form(
              key: key,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Obx(
                        ()=> Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: cardTextColor,
                        shape: BoxShape.circle,
                        image: controller.selectedImage.value != null
                            ? DecorationImage(image: AssetImage(controller.selectedImage.value!))
                            : null,
                      ),
                      height: MediaQuery.sizeOf(context).height * 0.18,
                      width: MediaQuery.sizeOf(context).width * 0.3,
                      child:   IconButton(onPressed: (){
                        controller.selectImage(context);
                      }, icon: const Icon(Icons.camera_alt_outlined,color:cardMyTournament,),),
                    ),
                  ),
                  Sized(width: 0.03,),
                  CustomTextField(
                    imagePath: personIcon,
                      validate: (value){
                        return value.isEmpty ? 'Enter Team Name ': null ;
                      },
                      controller: controller.teamNameController, hintText: 'Team Name',title: 'Team Name',),
                  Sized(height: 0.03,),
                  CustomTextField(
                    imagePath: personIcon,
                      validate: (value){
                        return value.isEmpty ? 'Enter Captain Name ': null ;
                      },
                      controller: controller.teamLeaderName, hintText: 'Leader Name',title: 'Leader Name',),
                  Sized(height: 0.03,),
                  CustomTextField(
                    imagePath: phoneIcon,
                    validate: (value){
                      return value.isEmpty ? 'Enter Phone Number': null ;
                    },
                    controller: controller.teamLeaderPhone, hintText: 'Phone Number',keyboardType: TextInputType.number,title: 'Phone No',),
                  Sized(height: 0.03,),
                  CustomTextField(
                    imagePath: addressIcon,
                    validate: (value){
                      return value.isEmpty ? 'Enter Location': null ;
                    },
                    controller: controller.location, hintText: 'Location',title: 'Location',),
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
                  Sized(height: 0.2,),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
