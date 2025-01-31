import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tournemnt/consts/firebase_consts.dart';
import '../consts/colors.dart';
import '../models_classes.dart';
import '../reusbale_widget/custom_button.dart';
import '../reusbale_widget/custom_sizedBox.dart';
import '../reusbale_widget/text_widgets.dart';
import '../reusbale_widget/toast_class.dart';

class MyTournamentsTeamsController extends GetxController {
  var isLoading = false.obs;
  var roundNumber = 0.obs;
  var isMatchStarted = 'false'.obs;

  var startDateController = TextEditingController(); // Add this controller for the start date
  var startDateTimeController = TextEditingController(); // Add this controller for the start date
  var selectedDate = Rxn<DateTime>();
  var selectedTime = TimeOfDay.now().obs;

  // Change to RxList<Team>
  var selectedTeams = RxList<Team>();

  void toggleTeamSelection(Team team) {
    if (selectedTeams.contains(team)) {
      selectedTeams.remove(team); // Unselect the team
    } else if (selectedTeams.length < 2) {
      selectedTeams.add(team); // Select the team
    } else {
      Get.snackbar('Selection Limit', 'You can only select two teams at a time.',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  bool isTeamSelected(Team team) {
    return selectedTeams.contains(team);
  }

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
      'vs':false,
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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30))
      ),
      backgroundColor: tCardBgColor,
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
              mediumText(title: 'Confirm $message', fontWeight: FontWeight.w500,color: whiteColor),
              Sized(
                height: 0.01,
              ),
              smallText(
                  title: 'Are you sure you want to $message this team?',
                  fontWeight: FontWeight.w500,color: whiteColor),
              Sized(
                height: 0.005,
              ),
              smallText(title: 'Select Round Number', fontWeight: FontWeight.w500,color: whiteColor),
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
                      child: smallText(title: 'Round ${index + 1}',fontWeight: FontWeight.w500,color: whiteColor),
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
                    child:  mediumText(title: 'Cancel',color: whiteColor),
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
                    child: mediumText(title: 'Confirm Round',color: whiteColor),
                  ),
                ],
              ),
              Sized(
                height: 0.01,
              ),
              SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    CustomButton(
                       fontWeight: FontWeight.w500,
                       fontSize: 14,
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
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
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
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
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
        ToastClass.showToastClass(context: context, message: "request time out");
      }).then((value) {
        isLoading(false);
        isMatchStarted.value = tournamentStatus;
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
  makeSchedule({required String tournamentId,required String teamOne,required String teamTwo,required String teamTwoId,required String teamOneId,required String teamOneToken,required String teamTwoToken,required BuildContext context,required String teamOneImage,required String teamTwoImage})async{
    try{
      isLoading(true);
      var data = fireStore.collection(tournamentsCollection).doc(tournamentId).collection(vsTeamCollection).doc();
      await data.set({
        'teamOne':teamOne,
        'teamTwo':teamTwo,
        'teamTwoId':teamTwoId,
        'teamOneId':teamOneId,
        'date':selectedDate.toString(),
        'time':selectedTime.value.toString(),
        'teamOneToken':teamOneToken,
        'teamTwoToken':teamTwoToken,
        'teamOneImage':teamOneImage,
        'teamTwoImage':teamTwoImage,
      }).then((value) async {
        try{
          // Update 'vs' field for teamOne
          var teamOneDoc = fireStore
              .collection(teamsCollection) // Directly access teamsCollection
              .doc(teamOneId);

          await teamOneDoc.update({'vs': true});

          // Update 'vs' field for teamTwo
          var teamTwoDoc = fireStore
              .collection(teamsCollection) // Directly access teamsCollection
              .doc(teamTwoId);

          await teamTwoDoc.update({'vs': true});
        }catch(e){
          print('vs error : $e');
        }
      });
      isLoading(false);
      selectedTeams.clear();
      Navigator.pop(context);
      startDateTimeController.clear();
      startDateController.clear();
    }catch(e){
      isLoading(false);
    }
  }

  selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            datePickerTheme: DatePickerThemeData(
              dividerColor: whiteColor,
              confirmButtonStyle: ButtonStyle(
                foregroundColor: WidgetStateProperty.all<Color>(whiteColor),
                backgroundColor: WidgetStateProperty.all<Color>(cardBgColor),
              ),
              cancelButtonStyle: ButtonStyle(
                foregroundColor: WidgetStateProperty.all<Color>(whiteColor),
                backgroundColor: WidgetStateProperty.all<Color>(cardCallButtonColor),
              ),
            ),
            colorScheme:  ColorScheme.light(
              primary: cardTextColor, // Header background color
              onPrimary: whiteColor, // Header text color
              surface: cardTextColor, // Background color of calendar picker
              onSurface: whiteColor, // Text color
            ),
            dialogBackgroundColor: cardTextColor,
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedDate.value) {
      selectedDate.value = picked;
      startDateController.text = "${selectedDate.value!.day}/${selectedDate.value!.month}/${selectedDate.value!.year}";
    }
  }

  Future<void> selectTime(BuildContext context) async {
    var theme = Theme.of(context);
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime.value,
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
          child: Theme(
            data: ThemeData.light().copyWith(
              timePickerTheme: TimePickerThemeData(
                entryModeIconColor: whiteColor,
                helpTextStyle: TextStyle(color: whiteColor),
                dayPeriodBorderSide: BorderSide(color: cardBgColor),
                confirmButtonStyle: ButtonStyle(
                  foregroundColor: WidgetStateProperty.all<Color>(whiteColor),
                  backgroundColor: WidgetStateProperty.all<Color>(cardBgColor),
                ),
                cancelButtonStyle: ButtonStyle(
                  foregroundColor: WidgetStateProperty.all<Color>(whiteColor),
                  backgroundColor: WidgetStateProperty.all<Color>(cardCallButtonColor),
                ),
                dialTextColor: blackColor,
                backgroundColor: cardTextColor,
                hourMinuteTextColor: whiteColor,
                dialHandColor: loginEnabledButtonColor,
                dialBackgroundColor:whiteColor,
                shape: RoundedRectangleBorder(
                  side:  BorderSide(color: theme.scaffoldBackgroundColor),
                  borderRadius: BorderRadius.circular(16),
                ),
                dayPeriodColor: WidgetStateColor.resolveWith(
                      (states) => theme.scaffoldBackgroundColor, // Set to white
                ),
                dayPeriodTextColor: WidgetStateColor.resolveWith(
                      (states) => whiteColor,
                ),
                dayPeriodShape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero, // Remove the border radius
                  side: BorderSide.none, // Remove the border
                ),
                hourMinuteColor: WidgetStateColor.resolveWith(
                      (states) => theme.scaffoldBackgroundColor, // Change this to white
                ),
                hourMinuteShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                inputDecorationTheme: InputDecorationTheme(
                  fillColor: theme.scaffoldBackgroundColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                dayPeriodTextStyle:  TextStyle(
                  color: buttonColor,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            child: child!,
          ),
        );
      },
    );

    if (picked != null && picked != selectedTime.value) {
      selectedTime.value = TimeOfDay(
        hour: picked.hour,
        minute: (picked.minute ~/ 5) * 5,
      );
      startDateTimeController.text = formatTime(); // Update controller
    }
  }

  bool isSelectedTimeValid(TimeOfDay selectedTime) {
    final now = DateTime.now();
    final selectedDateTime = DateTime(now.year, now.month, now.day, selectedTime.hour, selectedTime.minute);
    final thresholdTime = now.add(const Duration(days: 1));
    return selectedDateTime.isAfter(thresholdTime);
  }

  String formatTime() {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, selectedTime.value.hour, selectedTime.value.minute);
    var format = DateFormat.jm();
    return format.format(dt);
  }

}
