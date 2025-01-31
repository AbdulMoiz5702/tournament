// ignore_for_file: use_build_context_synchronously
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tournemnt/consts/colors.dart';
import 'package:tournemnt/consts/images_path.dart';
import 'package:tournemnt/reusbale_widget/bg_widgets.dart';
import 'package:tournemnt/reusbale_widget/customLeading.dart';
import 'package:tournemnt/reusbale_widget/custom_button.dart';
import 'package:tournemnt/reusbale_widget/custom_indicator.dart';
import 'package:tournemnt/reusbale_widget/custom_sizedBox.dart';
import 'package:tournemnt/reusbale_widget/custom_textfeild.dart';
import 'package:tournemnt/reusbale_widget/text_widgets.dart';
import 'package:tournemnt/reusbale_widget/toast_class.dart';

import '../../controllers/add_team_tournament_controller.dart';
import '../../services/notification_sevices.dart';



class AddTeamPage extends StatefulWidget {
  final String tournamentId;
  final String userId;
  final int registerTeams ;
  final String token ;
  final String isCompleted;
  const AddTeamPage({super.key,required this.tournamentId,required this.userId,required this.registerTeams,required this.token,required this.isCompleted});
  @override
  State<AddTeamPage> createState() => _AddTeamPageState();
}

class _AddTeamPageState extends State<AddTeamPage> {
  @override
  void initState() {
    super.initState();
    controller.newRegisterTeam.value = widget.registerTeams +1 ;
  }

  final key = GlobalKey<FormState>();
  var controller = Get.put(AddTeamTournamentController());
  NotificationServices notificationServices = NotificationServices();

  @override
  Widget build(BuildContext context) {
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
                        title: 'Add Team Info  ',
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
          padding: EdgeInsets.symmetric(horizontal:20),
          color: whiteColor,
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Form(
              key: key,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
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
                  Sized(height: 0.035,),
                  CustomTextField(
                    imagePath: personIcon,
                      validate: (value){
                        return value.isEmpty ? 'Team Name': null ;
                      },
                      controller: controller.nameController, hintText: 'Team Name',
                    title: 'Team Name',
                  ),
                  Sized(height: 0.035,),
                  CustomTextField(
                    imagePath: personIcon,
                    validate: (value){
                      return value.isEmpty ? 'Captain Name ': null ;
                    },
                    controller: controller.teamLeaderName, hintText: 'Captain Name  ',keyboardType: TextInputType.name,title: 'Captain Name',),
                  Sized(height: 0.035,),
                  CustomTextField(
                    imagePath: phoneIcon,
                    validate: (value){
                      return value.isEmpty ? 'Phone Number': null ;
                    },
                    controller: controller.teamLeaderPhoneNumber, hintText: 'Phone Number',keyboardType: TextInputType.number,title: 'Phone Number',),
                  Sized(height: 0.035,),
                  CustomTextField(
                      imagePath: addressIcon,
                      validate: (value){
                        return value.isEmpty ? 'Location': null ;
                      },
                      controller: controller.teamLocation, hintText: 'Location',title: 'Location',),
                  Sized(height: 0.08,),
                  Obx(() => controller.isLoading.value == true ? CustomIndicator() :CustomButton(title: 'Register', onTap: (){
                    if(key.currentState!.validate()){
                      if(controller.selectedImage.value != null && controller.selectedImage.value!.isNotEmpty){
                        controller.addTeam(tournamentId: widget.tournamentId,userId: widget.userId,context: context);
                        notificationServices.sendNotificationToSingleUser(widget.token, 'Hey There', 'A Team got register in your tournament',
                            {
                              'type':'ViewMyTournamentsTeams',
                              'tournamentId':widget.tournamentId,
                              'userId':widget.userId,
                              'isHomeScreen':false.toString(),
                              'isCompleted':widget.isCompleted.toString(),
                              'registerTeams':widget.registerTeams.toString(),
                              'token':widget.token
                            }
                        );
                      }else{
                        ToastClass.showToastClass(context: context, message: 'Please Select your Team Icon');
                      }
                    }else{
                      ToastClass.showToastClass(context: context, message: 'Please Fill all the Fields');
                    }
                  }),),
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