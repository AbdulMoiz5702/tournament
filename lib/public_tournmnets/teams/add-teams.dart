// ignore_for_file: use_build_context_synchronously
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tournemnt/consts/colors.dart';
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
  AddTeamPage({required this.tournamentId,required this.userId,required this.registerTeams,required this.token});
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
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        automaticallyImplyLeading: true,
        title: largeText(title: 'Add Team',context: context),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Form(
            key: key,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Obx(() => Container(
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
                  }, icon: const Icon(Icons.camera_alt_outlined,color:blueColor,),),
                ),),
                Sized(height: 0.03,),
                CustomTextField(
                    validate: (value){
                      return value.isEmpty ? 'Enter  Team Name': null ;
                    },
                    controller: controller.nameController, hintText: 'Team Name',
                  title: 'Team Name',
                ),
                Sized(height:0.03,),
                CustomTextField(
                  validate: (value){
                    return value.isEmpty ? 'Enter  Leader Name': null ;
                  },
                  controller: controller.teamLeaderName, hintText: 'Team Leader Name',keyboardType: TextInputType.name,title: 'Team Leader Name',),
                Sized(height:0.03,),
                CustomTextField(
                  validate: (value){
                    return value.isEmpty ? 'Enter  Phone No': null ;
                  },
                  controller: controller.teamLeaderPhoneNumber, hintText: 'Phone No',keyboardType: TextInputType.number,title: 'Phone No',),
                Sized(height:0.03,),
                CustomTextField(
                    validate: (value){
                      return value.isEmpty ? 'Enter  Location': null ;
                    },
                    controller: controller.teamLocation, hintText: 'Team location',title: 'Team location',),
                Sized(height:0.03,),
                Obx(() => controller.isLoading.value == true ? CustomIndicator() :CustomButton(title: 'Register Team', onTap: (){
                  if(key.currentState!.validate()){
                    if(controller.selectedImage.value != null && controller.selectedImage.value!.isNotEmpty){
                      controller.addTeam(tournamentId: widget.tournamentId,userId: widget.userId,context: context);
                      notificationServices.sendNotificationToSingleUser(widget.token, 'Hey There', 'A Team got register in your tournament');
                    }else{
                      ToastClass.showToastClass(context: context, message: 'Please Select your Team Icon');
                    }
                  }else{
                    ToastClass.showToastClass(context: context, message: 'Please Fill all the Fields');
                  }
                }),)
              ],
            ),
          ),
        ),
      ),
    );
  }

}