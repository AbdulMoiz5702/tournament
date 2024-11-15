// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:tournemnt/consts/colors.dart';
import 'package:tournemnt/reusbale_widget/custom_button.dart';
import 'package:tournemnt/reusbale_widget/custom_indicator.dart';
import 'package:tournemnt/reusbale_widget/custom_textfeild.dart';
import 'package:tournemnt/reusbale_widget/text_widgets.dart';
import 'package:tournemnt/reusbale_widget/toast_class.dart';
import '../controllers/Add_tournamnets_contoller.dart';
import '../reusbale_widget/custom_sizedBox.dart';

class AddTournamentPage extends StatelessWidget {
  final String userId;
  AddTournamentPage({required this.userId});


  @override
  Widget build(BuildContext context) {
    final key = GlobalKey<FormState>();
    var controller = Get.put(AddTournamentsController());
    return Scaffold(
      appBar: AppBar(
       automaticallyImplyLeading: true,
        centerTitle: false,
        title: largeText(title: 'Add Tournament', context: context,color: secondaryTextColor),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: SingleChildScrollView(
          child: Form(
            key: key,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        child:   IconButton(onPressed: (){
                          controller.selectImage(context);
                        }, icon: const Icon(Icons.camera_alt_outlined,color:blueColor,),),
                      ),
                    ),
                    Sized(width: 0.03,),
                    Container(
                      height: MediaQuery.sizeOf(context).height * 0.16,
                      width: MediaQuery.sizeOf(context).width * 0.6,
                      child: Column(
                        children: [
                          CustomTextField(
                            validate: (value){
                              return value.isEmpty ? 'Enter  Organizer Name ': null ;
                            },
                            controller: controller.organizerName,
                            hintText: 'Organizer Name',
                            title: 'Organizer Name',
                          ),
                          Sized(height: 0.02),
                          CustomTextField(
                            validate: (value){
                              return value.isEmpty ? 'Enter  Phone number': null ;
                            },
                            controller: controller.organizerPhoneNumber,
                            hintText: 'Phone number',
                            keyboardType: TextInputType.number,
                            title: 'Phone number',
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                Sized(height: 0.02),
                CustomTextField(
                  validate: (value){
                    return value.isEmpty ? 'Enter  Tournament Name ': null ;
                  },
                  controller: controller.nameController,
                  hintText: 'Tournament name',
                  title: 'Tournament name',
                ),
                Sized(height: 0.02),
                CustomTextField(
                  validate: (value){
                    return value.isEmpty ? 'Enter  Fee': null ;
                  },
                  controller: controller.tournamentFee,
                  hintText: 'Tournament Fee',
                  keyboardType: TextInputType.number,
                  title: 'Tournament Fee',
                ),
                Sized(height: 0.02),
                CustomTextField(
                  validate: (value){
                    return value.isEmpty ? 'Enter  Overs': null ;
                  },
                  controller: controller.tournamentOvers,
                  hintText: 'Tournament Overs',
                  keyboardType: TextInputType.number,
                  title: 'Overs',
                ),
                Sized(height: 0.02),
                CustomTextField(
                  validate: (value){
                    return value.isEmpty ? 'Enter  Total Teams': null ;
                  },
                  controller: controller.totalTeamController,
                  hintText: 'Maximum Teams',
                  keyboardType: TextInputType.number,
                  title: 'Maximum Teams',
                ),
                Sized(height: 0.02),
                CustomTextField(
                  validate: (value){
                    return value.isEmpty ? 'Enter  Location': null ;
                  },
                  controller: controller.location,
                  hintText: 'Tournament Location',
                  title: 'Tournament Location',
                ),
                Sized(height: 0.02),
                GestureDetector(
                  onTap: () {
                    controller.selectDate(context);
                  },
                  child: AbsorbPointer(
                    child: CustomTextField(
                      validate: (value){
                        return value.isEmpty ? 'Enter  Start date ': null ;
                      },
                      controller: controller.startDateController,
                      hintText: 'Date',
                      title: 'Date',
                    ),
                  ),
                ),
                Sized(height: 0.02),
                Obx(() => controller.isLoading.value == true ? const CustomIndicator():CustomButton(
                  title: 'Register tournament',
                  onTap: () {
                    if(key.currentState!.validate()){
                      if(controller.selectedImage.value != null && controller.selectedImage.value!.isNotEmpty){
                        controller.addTournament(userId: userId,context: context);
                      }else{
                        ToastClass.showToastClass(context: context, message: 'Please Select your Tournament Icon');
                      }
                    }else{
                      ToastClass.showToastClass(context: context, message: 'Please Fill all the Fields');
                    }
                  },
                ),),
              ],
            ),
          ),
        ),
      ),
    );
  }


}
