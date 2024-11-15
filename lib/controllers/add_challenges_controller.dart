import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tournemnt/consts/firebase_consts.dart';
import 'package:tournemnt/consts/images_path.dart';

import '../consts/colors.dart';
import '../reusbale_widget/custom_sizedBox.dart';
import '../reusbale_widget/text_widgets.dart';
import '../reusbale_widget/toast_class.dart';
import 'call_controller.dart';




class AddChallengesController extends GetxController {





  var controller = Get.find<ZegoCloudController>();

  var teamName = TextEditingController();
  late TextEditingController captainName  ;
  late  TextEditingController location ;
  late TextEditingController leaderPhone ;
  var matchOvers = TextEditingController();
  var startDateController = TextEditingController();
  var isLoading = false.obs;
  var selectedDate = Rxn<DateTime>();
  var selectedImage = Rxn<String>();

  @override
  void onInit() {
    super.onInit();
    captainName = TextEditingController(text: controller.userName);
    location = TextEditingController(text: controller.location);
    leaderPhone = TextEditingController(text: controller.phoneNumber);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    captainName.dispose();
    location.dispose();
    leaderPhone.dispose();
    matchOvers.dispose();
    startDateController.dispose();
    teamName.dispose();
  }




  addChallenge({required BuildContext context ,}) {
    String title = teamName.text;
    String description = captainName.text;
    if (title.isNotEmpty && description.isNotEmpty) {
      isLoading(true);
      fireStore.collection(challengesCollection).add({
        'challengerTeamName': title,
        'teamLeaderName': description,
        'location':location.text.toString(),
        'challengerLeaderPhone':leaderPhone.text.toString(),
        'Overs':matchOvers.text.toString(),
        'isChallengeAccepted':'false',
        'teamCount': 1,
        'challenger':currentUser!.uid,
        'token':userToken,
        'startDate': selectedDate.toString(),
        'imagePath':selectedImage.toString(),
      }).then((value) {
        isLoading(false);
        ToastClass.showToastClass(context: context, message: 'Challenge added successfully');
        Navigator.of(context).pop();
      }).catchError((error) {
        isLoading(false);
        ToastClass.showToastClass(context: context, message: 'Failed to add challenge: $error');
      });
    } else {
      isLoading(false);
      ToastClass.showToastClass(context: context, message: 'Please fill all fields');
    }
  }

  deleteTeam({required BuildContext context, required String teamId, required String challengeId}) async {
    try {
      await fireStore
          .collection(challengesCollection)
          .doc(challengeId)
          .collection(challengesTeamCollection)
          .doc(teamId)
          .delete()
          .then((value) async {
        await fireStore
            .collection(challengesCollection)
            .doc(challengeId)
            .update({
          'isChallengeAccepted': 'false',
          'teamCount': 1,
        });
      });
    } catch (e) {
      ToastClass.showToastClass(context: context, message: 'Failed to delete team: $e');
    }
  }

  selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate.value) {
        selectedDate.value = picked;
        startDateController.text = "${selectedDate.value!.day}/${selectedDate.value!.month}/${selectedDate.value!.year}";
    }
  }

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
          height: MediaQuery.sizeOf(context).height * 0.5,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Sized(height: 0.03,),
              Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: primaryTextColor,
                  ),
                  child: mediumText(title: 'Select Your Avatar',color: whiteColor,context: context)),
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


}