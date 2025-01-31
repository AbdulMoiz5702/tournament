import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:tournemnt/consts/colors.dart';
import 'package:tournemnt/consts/images_path.dart';
import 'package:tournemnt/reusbale_widget/bg_widgets.dart';
import 'package:tournemnt/reusbale_widget/custom_button.dart';
import 'package:tournemnt/reusbale_widget/custom_indicator.dart';
import 'package:tournemnt/reusbale_widget/custom_sizedBox.dart';
import 'package:tournemnt/reusbale_widget/custom_textfeild.dart';
import 'package:tournemnt/reusbale_widget/text_widgets.dart';
import 'package:tournemnt/reusbale_widget/toast_class.dart';
import '../controllers/add_challenges_controller.dart';
import '../reusbale_widget/customLeading.dart';
import 'challenge-type_selection.dart';

class AddChallengeScreen extends StatelessWidget {
  final String userId;
  const  AddChallengeScreen({required this.userId});
  @override
  Widget build(BuildContext context) {
    final key = GlobalKey<FormState>();
    var controller = Get.put(AddChallengesController());
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
                        title: 'Add Challenge',
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
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            color: whiteColor,
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
                        color: cardTextColor,
                        shape: BoxShape.circle,
                        image: controller.selectedImage.value != null
                            ? DecorationImage(image: AssetImage(controller.selectedImage.value!))
                            : null,
                      ),
                      height: MediaQuery.sizeOf(context).height * 0.16,
                      width: MediaQuery.sizeOf(context).width * 0.3,
                      child:   IconButton(onPressed: (){
                        controller.selectImage(context);
                      }, icon: const Icon(Icons.camera_alt_outlined,color:cardMyTournament,),),
                    ),
                  ),
                  Sized(height: 0.03,),
                  CustomTextField(
                    imagePath: personIcon,
                    controller: controller.teamName, hintText: 'Team Name',validate: (value){
                    return value.isEmpty ? 'Enter  Team Name': null ;
                  },title: 'Team Name',),
                  Sized(height: 0.03,),
                  CustomTextField(
                    imagePath: personIcon,
                    validate: (value){
                    return value.isEmpty ? 'Enter  Captain Name': null ;
                  },controller: controller.captainName, hintText: 'Captain Name',title: 'Captain Name',),
                  Sized(height: 0.03,),
                  CustomTextField(
                    onTap: (){
                      Get.to(()=> ChallengeTypeSelection(controller: controller,));
                    },
                    imagePath: personIcon,
                    validate: (value){
                      return value.isEmpty ? 'Enter Challenges Type': null ;
                    },
                    controller: controller.challengeType, hintText: 'Challenges Type',keyboardType: TextInputType.number,title: 'Challenges Type',),
                  Sized(height: 0.03,),
                  CustomTextField(
                    imagePath: phoneIcon,
                    validate: (value){
                      return value.isEmpty ? 'Enter Phone Number ': null ;
                    },
                    controller: controller.leaderPhone, hintText: 'Phone Number ',keyboardType: TextInputType.number,title: 'Phone Number ',),
                  Sized(height: 0.03,),
                  CustomTextField(
                    imagePath: addressIcon,
                    validate: (value){
                      return value.isEmpty ? 'Enter Location': null ;
                    },
                    controller: controller.location, hintText: 'Location',keyboardType: TextInputType.streetAddress,title: 'Location',),
                  Sized(height: 0.03,),
                  GestureDetector(
                    onTap: () {
                      controller.selectDate(context);
                    },
                    child: AbsorbPointer(
                      child: CustomTextField(
                        imagePath: dateIcon,
                        validate: (value){
                          return value.isEmpty ? 'Enter Start Date': null ;

                        },
                        controller: controller.startDateController,
                        hintText: 'Date',
                        title: 'Date',
                      ),
                    ),
                  ),
                  Sized(height: 0.03),
                  GestureDetector(
                    onTap: () {
                      controller.selectTime(context);
                    },
                    child: AbsorbPointer(
                      child: CustomTextField(
                        imagePath: timeIcon,
                        validate: (value){
                          return value.isEmpty ? 'Enter Match time ': null ;
                        },
                        controller: controller.startDateTimeController,
                        hintText: 'Time ',
                        title: 'Time ',
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
                  Sized(height: 0.05,),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

