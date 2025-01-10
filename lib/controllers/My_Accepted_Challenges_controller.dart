import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tournemnt/consts/firebase_consts.dart';

import '../consts/colors.dart';
import '../consts/images_path.dart';
import '../reusbale_widget/custom_sizedBox.dart';
import '../reusbale_widget/custom_textfeild.dart';
import '../reusbale_widget/text_widgets.dart';
import '../reusbale_widget/toast_class.dart';

class MyAcceptedChallengesController extends GetxController {
  deleteTeam(
      {required BuildContext context,
      required String teamId,
      required String challengeId}) async {
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
      ToastClass.showToastClass(
          context: context, message: 'Failed to delete team: $e');
    }
  }

  updateTeam(
      {required BuildContext context,
      required String teamId,
      required Map<String, dynamic> newData,
      required String challengeId}) async {
    try {
      await fireStore
          .collection(challengesCollection)
          .doc(challengeId)
          .collection(challengesTeamCollection)
          .doc(teamId)
          .update(newData);
    } catch (e) {
      ToastClass.showToastClass(
          context: context, message: 'Failed to update team: $e');
    }
  }

  showEditDialog(
      {required BuildContext context,
        required String teamId,
        required String teamName,
        required String teamLeaderName,
        required String teamLeaderPhone,
        required String location,
        required String challengeId
      }) {
    TextEditingController teamNameController =
        TextEditingController(text: teamName);
    TextEditingController leaderNameController =
        TextEditingController(text: teamLeaderName);
    TextEditingController leaderPhoneController =
        TextEditingController(text: teamLeaderPhone);
    TextEditingController locationController =
        TextEditingController(text: location);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: whiteColor,
          title: mediumText(title: 'Edit Challenge'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Sized(height: 0.03,),
                CustomTextField(controller: teamNameController, hintText: 'Team Name', validate: (v){},imagePath: personIcon,),
                Sized(height: 0.03,),
                CustomTextField(controller: leaderNameController, hintText: 'Captain Name', validate: (v){},imagePath: personIcon,),
                Sized(height: 0.03,),
                CustomTextField(controller: leaderPhoneController, hintText: 'Captain Phone', validate: (v){},imagePath: phoneIcon,),
                Sized(height: 0.03,),
                CustomTextField(controller: locationController, hintText: 'Address', validate: (v){},imagePath: addressIcon,),
              ],
            ),
          ),
          actions: [
            TextButton(
              style: ButtonStyle(foregroundColor: MaterialStateProperty.all(tCardBgColor)),
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              style: ButtonStyle(foregroundColor: MaterialStateProperty.all(tCardBgColor)),
              onPressed: () {
                Map<String, dynamic> newData = {
                  'teamName': teamNameController.text,
                  'teamLeaderName': leaderNameController.text,
                  'teamLeaderPhone': leaderPhoneController.text,
                  'location': locationController.text,
                  'token':userToken,
                };
                updateTeam(context: context, teamId: teamId, newData: newData, challengeId: challengeId);
                Navigator.of(context).pop();
              },
              child: Text('Update'),
            ),
          ],
        );
      },
    );
  }
}
