import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tournemnt/consts/firebase_consts.dart';
import 'package:tournemnt/consts/images_path.dart';
import 'package:tournemnt/reusbale_widget/custom_sizedBox.dart';
import 'package:tournemnt/reusbale_widget/custom_textfeild.dart';
import 'package:tournemnt/reusbale_widget/text_widgets.dart';

import '../consts/colors.dart';
import '../reusbale_widget/toast_class.dart';

class UserChallengesController extends GetxController {
  deleteChallenge(
      {required BuildContext context, required String challengeId}) async {
    try {
      await fireStore
          .collection(challengesCollection)
          .doc(challengeId)
          .delete();
    } catch (e) {
      ToastClass.showToastClass(
          context: context, message: 'Failed to delete challenge: $e');
    }
  }

  updateChallenge({
    required BuildContext context,
    required String challengeId,
    required String newTeamName,
    required String newLeaderName,
    required String newLeaderPhoneNumber,
    required String newLocation,
  }) async {
    try {
      await fireStore.collection(challengesCollection).doc(challengeId).update({
        'challengerTeamName': newTeamName,
        'teamLeaderName': newLeaderName,
        'challengerLeaderPhone': newLeaderPhoneNumber,
        'location': newLocation,
        'token':userToken,
      });
    } catch (e) {
      ToastClass.showToastClass(
          context: context, message: 'Failed to update challenge: $e');
    }
  }

  showEditDialog(
      {
        required BuildContext context,
        required String challengeId,
        required String teamName,
        required String leaderName,
        required String leaderPhone,
        required String location}) {
    TextEditingController teamNameController =
        TextEditingController(text: teamName);
    TextEditingController leaderNameController =
        TextEditingController(text: leaderName);
    TextEditingController leaderPhoneController =
        TextEditingController(text: leaderPhone);
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
                updateChallenge(context: context, challengeId: challengeId, newTeamName: teamNameController.text, newLeaderName: leaderNameController.text, newLeaderPhoneNumber: leaderPhoneController.text, newLocation:  locationController.text,);
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


