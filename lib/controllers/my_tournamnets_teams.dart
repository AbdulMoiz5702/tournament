import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tournemnt/consts/firebase_consts.dart';
import '../reusbale_widget/custom_button.dart';
import '../reusbale_widget/custom_sizedBox.dart';
import '../reusbale_widget/text_widgets.dart';
import '../reusbale_widget/toast_class.dart';

class MyTournamentsTeamsController extends GetxController {
  var isLoading = false.obs;
  var roundNumber = 0.obs;

  deleteTeam(
      {required BuildContext context,
      required String teamId,
      required String tournamentId,
      required int registerTeams}) async {
    await fireStore
        .collection(teamsCollection)
        .doc(teamId)
        .delete()
        .then((value) async {
      await fireStore
          .collection(tournamentsCollection)
          .doc(tournamentId)
          .update({
        'registerTeams': registerTeams - 1,
      });
    }).timeout(const Duration(seconds: 5), onTimeout: () {
      ToastClass.showToastClass(context: context, message: 'Request Time Out');
    });
  }

  updateTeamStatus(
      {required String teamId,
      required String updatedTeamStatus,
      required String roundNUmber,
      required BuildContext context}) async {
    await fireStore.collection(teamsCollection).doc(teamId).update({
      'teamResult': updatedTeamStatus,
      'roundsQualify': roundNUmber,
    }).then((value) {
      ToastClass.showToastClass(
          context: context, message: 'Team Status Updated');
    }).timeout(const Duration(seconds: 5), onTimeout: () {
      ToastClass.showToastClass(context: context, message: 'Request Time Out');
    }).onError((error, stackTrace) {
      print(error.toString());
      ToastClass.showToastClass(
          context: context, message: 'Something went wrong');
    });
  }

  confirmUpdate(
      {required BuildContext context,
      required String teamId,
      required String message,
      required String teamStatus}) {
    int selectedRound =
        roundNumber.value; // To keep track of the selected round
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Sized(
                height: 0.01,
              ),
              mediumText(title: 'Confirm $message', context: context),
              Sized(
                height: 0.01,
              ),
              smallText(
                  title: 'Are you sure you want to $message this team?',
                  context: context),
              Sized(
                height: 0.01,
              ),
              smallText(title: 'Select Round Number', context: context),
              Sized(
                height: 0.02,
              ),
              SizedBox(
                height: MediaQuery.sizeOf(context).height * 0.1,
                child: CupertinoPicker(
                  itemExtent: 32.0,
                  onSelectedItemChanged: (int index) {
                    selectedRound = index + 1; // Assuming rounds start from 1
                  },
                  children: List<Widget>.generate(20, (int index) {
                    return Center(
                      child: Text('Round ${index + 1}'),
                    );
                  }),
                ),
              ),
              Sized(
                height: 0.01,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      updateTeamStatus(
                          teamId: teamId,
                          updatedTeamStatus: teamStatus,
                          roundNUmber:
                              'This Team $message in Round $selectedRound',
                          context: context);
                    },
                    child: const Text('Confirm Round'),
                  ),
                ],
              ),
              Sized(
                height: 0.01,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    CustomButton(
                        width: 0.35,
                        title: 'Quarter Final',
                        onTap: () {
                          Navigator.of(context).pop();
                          updateTeamStatus(
                              teamId: teamId,
                              updatedTeamStatus: teamStatus,
                              roundNUmber:
                                  'This Team $message in Quarter Final',
                              context: context);
                        }),
                    Sized(
                      width: 0.03,
                    ),
                    CustomButton(
                        width: 0.35,
                        title: 'Semi Final',
                        onTap: () {
                          Navigator.of(context).pop();
                          updateTeamStatus(
                              teamId: teamId,
                              updatedTeamStatus: teamStatus,
                              roundNUmber: 'This Team $message in  Semi Final',
                              context: context);
                        }),
                    Sized(
                      width: 0.03,
                    ),
                    CustomButton(
                        width: 0.35,
                        title: 'Final',
                        onTap: () {
                          Navigator.of(context).pop();
                          updateTeamStatus(
                              teamId: teamId,
                              updatedTeamStatus: teamStatus,
                              roundNUmber: 'This Team $message in  Final',
                              context: context);
                        }),
                  ],
                ),
              ),
              Sized(
                height: 0.01,
              ),
            ],
          ),
        );
      },
    );
  }

  startTournament(
      {required String tournamentStatus,
      required String tournamentId,
      required BuildContext context}) async {
    try {
      isLoading(true);
      await fireStore
          .collection(tournamentsCollection)
          .doc(tournamentId)
          .update({
        'isCompleted': tournamentStatus,
      }).timeout(const Duration(seconds: 5), onTimeout: () {
        isLoading(false);
        ToastClass.showToastClass(
            context: context, message: "request time out");
      }).then((value) {
        isLoading(false);
      });
    } catch (e) {
      isLoading(false);
      ToastClass.showToastClass(
          context: context, message: "something went wrong");
    }
  }

  confirmDeleteTeam(
      {required BuildContext context,
      required String teamId,
      required String tournamentId,
      required int registerTeams}) {
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
              onPressed: () {
                deleteTeam(
                    context: context,
                    teamId: teamId,
                    tournamentId: tournamentId,
                    registerTeams: registerTeams);
                Navigator.of(context).pop();
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
