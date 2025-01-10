// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:tournemnt/consts/colors.dart';
import 'package:tournemnt/consts/images_path.dart';
import 'package:tournemnt/public_tournmnets/tournament_type_selection.dart';
import 'package:tournemnt/reusbale_widget/bg_widgets.dart';
import 'package:tournemnt/reusbale_widget/custom_button.dart';
import 'package:tournemnt/reusbale_widget/custom_indicator.dart';
import 'package:tournemnt/reusbale_widget/custom_textfeild.dart';
import 'package:tournemnt/reusbale_widget/text_widgets.dart';
import 'package:tournemnt/reusbale_widget/toast_class.dart';
import '../controllers/Add_tournamnets_contoller.dart';
import '../reusbale_widget/customLeading.dart';
import '../reusbale_widget/custom_sizedBox.dart';

class AddTournamentPage extends StatelessWidget {
  final String userId;
 const  AddTournamentPage({super.key,required this.userId});


  @override
  Widget build(BuildContext context) {
    final key = GlobalKey<FormState>();
    var controller = Get.put(AddTournamentsController());
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
                        title: 'Add Tournament',
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
        body:  Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          color: whiteColor,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Form(
              key: key,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Sized(height: 0.02),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          height: MediaQuery.sizeOf(context).height * 0.16,
                          width: MediaQuery.sizeOf(context).width * 0.3,
                          child:   IconButton(onPressed: (){
                            controller.selectImage(context);
                          }, icon: const Icon(Icons.camera_alt_outlined,color:cardMyTournament,),),
                        ),
                      ),
                      Sized(width: 0.03,),
                       Container(
                        height: MediaQuery.sizeOf(context).height * 0.125,
                        width: MediaQuery.sizeOf(context).width * 0.6,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomTextField(
                              imagePath: personIcon,
                              isDense: true,
                              validate: (value){
                                return value.isEmpty ? 'Enter  Organizer Name ': null ;
                              },
                              controller: controller.organizerName,
                              hintText: 'Organizer Name',
                              title: 'Organizer Name',
                            ),
                            Sized(height: 0.01),
                            CustomTextField(
                              imagePath: phoneIcon,
                              isDense: true,
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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Column(
                      children: [
                        Sized(height: 0.03),
                        CustomTextField(
                          imagePath: personIcon,
                          validate: (value){
                            return value.isEmpty ? 'Enter  Tournament Name ': null ;
                          },
                          controller: controller.nameController,
                          hintText: 'Tournament  Name',
                          title: 'Tournament  Name',
                        ),
                        Sized(height: 0.03),
                        CustomTextField(
                          imagePath: personIcon,
                          validate: (value){
                            return value.isEmpty ? 'Enter  Fee': null ;
                          },
                          controller: controller.tournamentFee,
                          hintText: 'Tournament Fee',
                          keyboardType: TextInputType.number,
                          title: 'Tournament Fee',
                        ),
                        Sized(height: 0.03),
                        CustomTextField(
                          onTap: (){
                            Get.to(()=> TournamentTypeSelection());
                          },
                          imagePath: personIcon,
                          validate: (value){
                            return value.isEmpty ? 'Enter  Tournament Type': null ;
                          },
                          controller: controller.tournamentType,
                          hintText: 'Tournament Type ',
                          keyboardType: TextInputType.text,
                          title: 'Tournament Type ',
                        ),
                        Sized(height: 0.03),
                        CustomTextField(
                          imagePath: personIcon,
                          validate: (value){
                            return value.isEmpty ? 'Enter Maximum Teams': null ;
                          },
                          controller: controller.totalTeamController,
                          hintText: 'Maximum Teams',
                          keyboardType: TextInputType.number,
                          title: 'Maximum Teams',
                        ),
                        Sized(height: 0.03),
                        CustomTextField(
                          imagePath: personIcon,
                          validate: (value){
                            return value.isEmpty ? 'Enter  Maximum Players': null ;
                          },
                          controller: controller.totalPlayerController,
                          hintText: 'Maximum Players',
                          keyboardType: TextInputType.number,
                          title: 'Maximum Players',
                        ),
                        Sized(height: 0.03),
                        CustomTextField(
                          imagePath: addressIcon,
                          validate: (value){
                            return value.isEmpty ? 'Enter  Location': null ;
                          },
                          controller: controller.location,
                          hintText: 'Ground Location',
                          title: 'Ground Location',
                        ),
                        Sized(height: 0.03),
                        GestureDetector(
                          onTap: () {
                            controller.selectDate(context);
                          },
                          child: AbsorbPointer(
                            child: CustomTextField(
                              imagePath: dateIcon,
                              validate: (value){
                                return value.isEmpty ? 'Enter  Start date ': null ;
                              },
                              controller: controller.startDateController,
                              hintText: 'Tournament Start Date',
                              title: 'Tournament Start Date',
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
                                return value.isEmpty ? 'Enter  Match time ': null ;
                              },
                              controller: controller.startDateTimeController,
                              hintText: 'Tournament Match time ',
                              title: 'Tournament Match time ',
                            ),
                          ),
                        ),
                        Sized(height: 0.03),
                        CustomTextField(
                          showLeading: false,
                          isMaxLines: true,
                          imagePath: addressIcon,
                          validate: (value){
                            return value.isEmpty ? 'Write Tournament Rules': null ;
                          },
                          controller: controller.tournamentsRules,
                          hintText: 'Write Tournament Rules',
                          title: '',
                        ),
                        Sized(height: 0.03),
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
                        Sized(height: 0.03),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }


}
