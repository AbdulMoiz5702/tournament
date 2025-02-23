import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tournemnt/consts/firebase_consts.dart';
import '../reusbale_widget/toast_class.dart';

class ViewChallengesController extends GetxController {


  var isChallengeAccepted = false.obs;

  void deleteTeam({required BuildContext context,required String teamId,required  String challengeId}) async {
    try {
      await fireStore.collection(challengesCollection).doc(challengeId).collection(challengesTeamCollection).doc(teamId).delete();
    } catch (e) {
      ToastClass.showToastClass(context: context, message: 'Failed to delete team: $e');
    }
  }

  void updateTeam({required BuildContext context,required String teamId,required Map<String, dynamic> newData,required  String challengeId}) async {
    try {
      await fireStore.collection(challengesCollection).doc(challengeId).collection(challengesTeamCollection).doc(teamId).update(newData);
    } catch (e) {
      ToastClass.showToastClass(context: context, message: 'Failed to update team: $e');
    }
  }

  void showEditDialog({required BuildContext context,required String teamId,required String  teamName,required String teamLeaderName ,required String teamLeaderPhone,required String location,required  String challengeId}) {
    TextEditingController teamNameController = TextEditingController(text: teamName);
    TextEditingController leaderNameController = TextEditingController(text: teamLeaderName);
    TextEditingController leaderPhoneController = TextEditingController(text: teamLeaderPhone);
    TextEditingController locationController = TextEditingController(text: location);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Team'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(controller: teamNameController, decoration: InputDecoration(labelText: 'Team Name')),
                TextField(controller: leaderNameController, decoration: InputDecoration(labelText: 'Leader Name')),
                TextField(controller: leaderPhoneController, decoration: InputDecoration(labelText: 'Leader Phone')),
                TextField(controller: locationController, decoration: InputDecoration(labelText: 'Location')),
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
                Map<String, dynamic> newData = {
                  'teamName': teamNameController.text,
                  'teamLeaderName': leaderNameController.text,
                  'teamLeaderPhone': leaderPhoneController.text,
                  'location': locationController.text,
                };
               updateTeam(context: context, teamId: teamId, newData: newData, challengeId: challengeId);
                Navigator.of(context).pop();
                teamNameController.dispose();
                leaderNameController.dispose();
                leaderPhoneController.dispose();
                locationController.dispose();
              },
              child: Text('Update'),
            ),
          ],
        );
      },
    );
  }




}