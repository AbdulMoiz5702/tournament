import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tournemnt/consts/firebase_consts.dart';
import 'package:tournemnt/consts/images_path.dart';
import 'package:tournemnt/reusbale_widget/custom_sizedBox.dart';
import 'package:tournemnt/reusbale_widget/custom_textfeild.dart';
import 'package:tournemnt/reusbale_widget/text_widgets.dart';

import '../consts/colors.dart';
import '../reusbale_widget/toast_class.dart';

class UserChallengesController extends GetxController {



  var isLoading = false.obs;
  final formKey = GlobalKey<FormState>();
  var teamName = ''.obs;
  var captainName = ''.obs;
  var leaderPhone = ''.obs;
  var location = ''.obs;
  var over = ''.obs;
  var age = ''.obs;
  var area = ''.obs;
  var challengeType = TextEditingController();
  var startDateController = TextEditingController();
  var startDateTimeController = TextEditingController(); // Add this controller for the start date
  var areaLevel = TextEditingController();
  var selectedDate = Rxn<DateTime>();
  var selectedTime = TimeOfDay.now().obs;
  var currentIndexOver = (-1).obs;
  var currentIndexAge = (-1).obs;
  var currentIndexArea = (-1).obs;

  selectRadioOver(index){
    currentIndexOver.value = index;
  }

  selectRadioAge(index){
    currentIndexAge.value = index;
  }

  selectRadioArea(index){
    currentIndexArea.value = index;
  }

  String getSelectRadioOver() {
    return '${overTypeList[currentIndexOver.value]} | ${ageLevelList[currentIndexAge.value]} | ${currentIndexArea.value == 2 ? areaLevel.text.trim():areaLevelListChallenge[currentIndexArea.value]}';
  }


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
    required String challengeId ,
  }) async {
    try {
      isLoading(true);
      formKey.currentState!.save();
      DateTime startDate = selectedDate.value! ;
      String formattedStartDate = DateFormat('yyyy-MM-dd HH:mm:ss.SSS').format(startDate);
      final String formattedStartTime = "TimeOfDay(${selectedTime.value.hour.toString().padLeft(2, '0')}:${selectedTime.value.minute.toString().padLeft(2, '0')})";
      await fireStore.collection(challengesCollection).doc(challengeId).update({
        'challengerTeamName': teamName.value,
        'teamLeaderName': captainName.value,
        'challengerLeaderPhone': leaderPhone.value,
        'location': location.value,
        'token':userToken,
        'startDate':formattedStartDate,
        'startTime':formattedStartTime,
        'Over':currentIndexOver.value == -1 ? over.value : overTypeList[currentIndexOver.value].toString(),
        'age':currentIndexAge.value == -1 ? age.value :  ageLevelList[currentIndexAge.value].toString(),
        'area': currentIndexArea.value == 2 ? areaLevel.text.trim():currentIndexArea.value == -1 ? area.value : areaLevelList[currentIndexArea.value],
      });
      isLoading(false);
      Navigator.pop(context);
    } catch (e) {
      ToastClass.showToastClass(
          context: context, message: 'Failed to update challenge: $e');
      isLoading(false);
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
                dayPeriodTextStyle: const TextStyle(
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
            colorScheme:  const ColorScheme.light(
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
      final formattedUI = DateFormat('dd MMM yyyy').format(selectedDate.value!);
      startDateController.text = formattedUI;
    }
  }

}


