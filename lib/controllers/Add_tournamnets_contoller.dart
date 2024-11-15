import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tournemnt/consts/firebase_consts.dart';
import 'package:tournemnt/consts/images_path.dart';
import '../consts/colors.dart';
import '../reusbale_widget/custom_sizedBox.dart';
import '../reusbale_widget/text_widgets.dart';
import '../reusbale_widget/toast_class.dart';
import 'call_controller.dart';


class AddTournamentsController extends GetxController {


  @override
  void onInit() {
    super.onInit();
    organizerName = TextEditingController(text: controller.userName);
    organizerPhoneNumber = TextEditingController(text: controller.phoneNumber);
    location = TextEditingController(text: controller.location);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    nameController.dispose();
    organizerName.dispose();
    organizerPhoneNumber.dispose();
    location.dispose();
    tournamentOvers.dispose();
    tournamentFee.dispose();
    startDateController.dispose();
    totalTeamController.dispose();
  }

  var controller = Get.find<ZegoCloudController>();
  var nameController = TextEditingController();
  late TextEditingController organizerName ;
  late TextEditingController organizerPhoneNumber ;
  late TextEditingController location;
  var tournamentOvers = TextEditingController();
  var tournamentFee = TextEditingController();
  var startDateController = TextEditingController(); // Add this controller for the start date
  var totalTeamController = TextEditingController();
  var isLoading = false.obs;
  var selectedDate = Rxn<DateTime>();
  var selectedImage = Rxn<String>();

  selectImage(BuildContext context) async {
    await showModalBottomSheet(
      backgroundColor:primaryTextColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30)),
      ),
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            color: primaryTextColor,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30)),
          ),
          height: MediaQuery.sizeOf(context).height * 0.5,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: primaryTextColor,
                  ),
                  child: mediumText(title: 'Select Tournament Avatar',color: whiteColor,context: context)),
              Sized(height: 0.03,),
              Container(
                  color: primaryTextColor,
                  height: MediaQuery.sizeOf(context).height * 0.35,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: BouncingScrollPhysics(),
                    child: Row(
                      children: List.generate(imagesListOther.length, (index) {
                        return GestureDetector(
                          onTap: (){
                            selectedImage.value = imagesListOther[index];

                            Navigator.pop(context);
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                margin: EdgeInsets.only(right: 10),
                                height: MediaQuery.sizeOf(context).height * 0.15,
                                width: MediaQuery.sizeOf(context).width * 0.3,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                    color: secondaryTextColor,
                                    image: DecorationImage(image: AssetImage(imagesListOther[index]),fit: BoxFit.cover)
                                ),),
                              Sized(height: 0.02,),
                              Container(
                                  margin: EdgeInsets.only(left: 5),
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(7),
                                    color: secondaryTextFieldColor,
                                  ),
                                  child: smallText(title: teamsTypesNameList[index],context: context,color: blueColor,fontWeight: FontWeight.bold)),
                            ],
                          ),
                        );
                      }),
                    ),
                  )
              ),
            ],
          ),
        );
      },
    );
  }

  selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
        selectedDate.value = picked;
        startDateController.text = "${selectedDate.value!.day}/${selectedDate.value!.month}/${selectedDate.value!.year}";
    }
  }

  addTournament({required String userId,required BuildContext context}) async {
    try {
      isLoading(true);
      final String name = nameController.text;
      await fireStore.collection(tournamentsCollection).add({
        'name': name,
        'organizerName': organizerName.text.toString(),
        'tournamentOvers': tournamentOvers.text.toString(),
        'tournamentFee': tournamentFee.text.toString(),
        'organizerPhoneNumber': organizerPhoneNumber.text.toString(),
        'location': location.text.toString(),
        'startDate': selectedDate.toString(),
        'organizer_UserID': userId,
        'isCompleted': 'false',
        'totalTeams':int.parse(totalTeamController.text.toString()),
        'registerTeams':0,
        'imagePath':selectedImage.toString(),
        'token':userToken,
      }).then((value) => {
        isLoading(false),
        Navigator.pop(context),
      });
    } catch (error) {
      isLoading(false);
      ToastClass.showToastClass(context: context, message: 'Tournament Added Failed $error');
    }
  }




}