import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tournemnt/consts/firebase_consts.dart';
import '../consts/colors.dart';
import '../models_classes.dart';
import '../reusbale_widget/custom_sizedBox.dart';
import '../reusbale_widget/custom_textfeild.dart';
import '../reusbale_widget/toast_class.dart';

class MyMatchesTeamController extends GetxController {

  deleteTeam({required BuildContext context,required String teamId}) async {
    await fireStore.collection(teamsCollection).doc(teamId).delete().then((value) {
    }).timeout(const Duration(seconds: 5), onTimeout: () {
    ToastClass.showToastClass(context: context, message: 'Request Time Out');
    });
  }

  confirmDeleteTeam({required BuildContext context,required String teamId}) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: Text('Are you sure you want to delete this team?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () => deleteTeam(context: context,teamId: teamId),
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  updateTeam({
    required BuildContext context,
    required String teamId,
    required String newName,
    required String newLeaderName,
    required String newLeaderPhoneNumber,
    required String newLocation
}) async {
    try {
      await fireStore.collection(teamsCollection).doc(teamId).update({
        'name': newName,
        'teamLeader': newLeaderName,
        'teamLeaderNumber': newLeaderPhoneNumber,
        'teamLocation': newLocation,
        'token':userToken,
      });
    } catch (e) {
      // ignore: use_build_context_synchronously
      ToastClass.showToastClass(context: context, message: 'Failed to update team: $e');
    }
  }

  showEditDialog({required BuildContext context,required Team team}) {
    TextEditingController nameController =
    TextEditingController(text: team.name);
    TextEditingController leaderNameController =
    TextEditingController(text: team.teamLeaderName);
    TextEditingController leaderPhoneController =
    TextEditingController(text: team.teamLeaderPhoneNumber);
    TextEditingController locationController =
    TextEditingController(text: team.teamLocation);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: backGroundColor,
          title: Text('Edit Team'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Sized(height: 0.01,),
                CustomTextField(
                  controller: nameController,
                  hintText: 'Team Name',
                  validate: (value) {
                    return value.isEmpty ? 'Team Name required': null ;
                  },
                ),
                Sized(height: 0.01,),
                CustomTextField(
                  controller: leaderNameController,
                  hintText: 'Team Leader Name',
                  validate: (value) {
                    return value.isEmpty ? 'Team Leader Name required': null ;
                  },
                ),
                Sized(height: 0.01,),
                CustomTextField(
                  controller: leaderPhoneController,
                  hintText: 'Leader Phone Number',
                  validate: (value) {
                    return value.isEmpty ? 'Leader Phone Number required': null ;
                  },
                  keyboardType: TextInputType.number,
                ),
                Sized(height: 0.01,),
                CustomTextField(
                  controller: locationController,
                  hintText: 'Leader Phone Number',
                  validate: (value) {
                    return value.isEmpty ? 'Location required': null ;
                  },
                ),
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
                updateTeam(
                 context: context,
                  teamId: team.id,
                  newName:  nameController.text,
                  newLeaderName:leaderNameController.text,
                  newLeaderPhoneNumber: leaderPhoneController.text,
                  newLocation: locationController.text,
                );
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