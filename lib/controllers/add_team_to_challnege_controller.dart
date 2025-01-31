


import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tournemnt/consts/firebase_consts.dart';
import 'package:tournemnt/controllers/view_challenge_controller.dart';
import '../consts/colors.dart';
import '../consts/images_path.dart';
import '../reusbale_widget/custom_sizedBox.dart';
import '../reusbale_widget/text_widgets.dart';
import '../reusbale_widget/toast_class.dart';
import 'call_controller.dart';

class AddTeamToChallenge extends GetxController {



  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    location = TextEditingController(text: controller.location);
    teamLeaderPhone = TextEditingController(text: controller.phoneNumber);
    teamLeaderName = TextEditingController(text: controller.userName);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    location.dispose();
    teamLeaderPhone.dispose();
    teamLeaderName.dispose();
    teamNameController.dispose();
  }

  var controller = Get.find<ZegoCloudController>();
  late TextEditingController location ;
  late TextEditingController teamLeaderPhone ;
  late TextEditingController teamLeaderName ;
  var teamNameController = TextEditingController();

  var isLoading = false.obs;
  var selectedDate = Rxn<DateTime>();
  var selectedImage = Rxn<String>();
  var viewChallengeController = Get.put(ViewChallengesController());

  selectImage(BuildContext context) async {
    await showModalBottomSheet(
      backgroundColor:loginEnabledButtonColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30)),
      ),
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return Container(
          decoration:const  BoxDecoration(
            color: loginEnabledButtonColor,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30)),
          ),
          height: MediaQuery.sizeOf(context).height * 0.5,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  alignment: Alignment.center,
                  padding:const  EdgeInsets.all(5),
                  decoration:const  BoxDecoration(
                    color: loginEnabledButtonColor,
                  ),
                  child: mediumText(title: 'Select Your Avatar',color: whiteColor,context: context)),
              Sized(height: 0.03,),
              Container(
                  color: loginEnabledButtonColor,
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

  addTeam({required BuildContext context,required String challengeId,required}) {
    fireStore.collection(challengesCollection).doc(challengeId).get().then((challengeSnapshot) {
      var challengeData = challengeSnapshot.data();
      viewChallengeController.isChallengeAccepted(true);
      int teamCount = challengeData?['teamCount'] ?? 0;
      if (teamCount < 2) {
        String teamName = teamNameController.text;
        if (teamName.isNotEmpty) {
          isLoading(true);
          fireStore.collection(challengesCollection).doc(challengeId).collection(teamsCollection).add({
            'teamName': teamName,
            'teamLeaderName':teamLeaderName.text.toString(),
            'teamLeaderPhone':teamLeaderPhone.text.toString(),
            'location':location.text.toString(),
            'accepterId':currentUser!.uid,
             'token':userToken,
            'imageLink':selectedImage.toString(),
          }).then((value) {
            isLoading(false);
            fireStore.collection(challengesCollection).doc(challengeId).update({
              'teamCount': teamCount + 1,
              'isChallengeAccepted':'true',
            });
            Navigator.of(context).pop();
          }).catchError((error) {
            isLoading(false);
            viewChallengeController.isChallengeAccepted(true);
            ToastClass.showToastClass(context: context, message: 'Failed to add team: $error');
          });
        } else {
          viewChallengeController.isChallengeAccepted(true);
          isLoading(false);
        }
      } else {
        isLoading(false);
        viewChallengeController.isChallengeAccepted(true);
        ToastClass.showToastClass(context: context, message: 'This challenge is already full');
      }
    });
  }

}