import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tournemnt/consts/firebase_consts.dart';
import 'package:tournemnt/consts/images_path.dart';
import 'package:tournemnt/reusbale_widget/text_widgets.dart';
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
          backgroundColor: whiteColor,
          title: mediumText(title: 'Confirm Delete'),
          content: smallText(title: 'Are you sure you want to remove your team from the tournament?',fontWeight: FontWeight.w500,color:loginEnabledButtonColor ),
          actions: [
            TextButton(
              style: ButtonStyle(foregroundColor:  MaterialStateProperty.all(tCardBgColor)),
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              style: ButtonStyle(foregroundColor:  MaterialStateProperty.all(tCardBgColor)),
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
          backgroundColor: whiteColor,
          title: mediumText(title: 'Edit Team'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Sized(height: 0.03,),
                CustomTextField(
                  imagePath: personIcon,
                  controller: nameController,
                  hintText: 'Team Name',
                  validate: (value) {
                    return value.isEmpty ? 'Team Name required': null ;
                  },
                ),
                Sized(height: 0.03,),
                CustomTextField(
                  imagePath: personIcon,
                  controller: leaderNameController,
                  hintText: 'Team Leader Name',
                  validate: (value) {
                    return value.isEmpty ? 'Team Leader Name required': null ;
                  },
                ),
                Sized(height: 0.03,),
                CustomTextField(
                  imagePath: phoneIcon,
                  controller: leaderPhoneController,
                  hintText: 'Leader Phone Number',
                  validate: (value) {
                    return value.isEmpty ? 'Leader Phone Number required': null ;
                  },
                  keyboardType: TextInputType.number,
                ),
                Sized(height: 0.03,),
                CustomTextField(
                  imagePath: addressIcon,
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
              style: ButtonStyle(foregroundColor:  MaterialStateProperty.all(tCardBgColor)),
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              style: ButtonStyle(foregroundColor:  MaterialStateProperty.all(tCardBgColor)),
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