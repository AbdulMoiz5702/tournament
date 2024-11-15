import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tournemnt/consts/firebase_consts.dart';

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
          title: Text('Edit Challenge'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                    controller: teamNameController,
                    decoration: InputDecoration(labelText: 'Team Name')),
                TextField(
                    controller: leaderNameController,
                    decoration: InputDecoration(labelText: 'Leader Name')),
                TextField(
                    controller: leaderPhoneController,
                    decoration: InputDecoration(labelText: 'Leader Phone')),
                TextField(
                    controller: locationController,
                    decoration: InputDecoration(labelText: 'Location')),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
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


