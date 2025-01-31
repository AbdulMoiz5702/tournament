import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tournemnt/consts/firebase_consts.dart';
import '../consts/colors.dart';
import '../consts/images_path.dart';
import '../reusbale_widget/toast_class.dart';

class UpdateTournamentController extends GetxController {

  var isLoading = false.obs;
  var name = ''.obs;
  var organizerName = ''.obs;
  var organizerPhoneNumber = ''.obs;
  var tournamentFee = ''.obs;
  var location = ''.obs;
  var tournamentType = TextEditingController();
  var startDateController = TextEditingController(); // Add this controller for the start date
  var selectedDate = Rxn<DateTime>();
  var selectedTime = TimeOfDay.now().obs;
  var startDateTimeController = TextEditingController(); // Add this controller for the start date
  final formKey = GlobalKey<FormState>();
  var totalTeamController = TextEditingController();
  var totalPlayerController = TextEditingController();
  var tournamentsRules = TextEditingController();
  var areaLevel = TextEditingController();
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

  String getSelectedTournamentType() {
    return "${overTypeList[currentIndexOver.value]} | ${ageLevelList[currentIndexAge.value]} | ${currentIndexArea.value == 2 ? areaLevel.text.trim():areaLevelList[currentIndexArea.value]}";
  }

  updateTournament({required String tournamentId,required BuildContext context}) async {
    if (formKey.currentState!.validate()) {
      isLoading(true);
      formKey.currentState!.save();
      DateTime startDate = selectedDate.value! ;
      String formattedStartDate = DateFormat('yyyy-MM-dd HH:mm:ss.SSS').format(startDate);
      final String formattedStartTime = "TimeOfDay(${selectedTime.value.hour.toString().padLeft(2, '0')}:${selectedTime.value.minute.toString().padLeft(2, '0')})";
      await fireStore
          .collection(tournamentsCollection)
          .doc(tournamentId)
          .update({
        'name': name.value,
        'organizerName': organizerName.value,
        'organizerPhoneNumber': organizerPhoneNumber.value,
        'tournamentFee': tournamentFee.value,
        'tournamentOvers': tournamentType.text.toString(),
        'location': location.value,
        'startDate':  formattedStartDate, // Convert text to DateTime if not empty
        'token':userToken,
        'startTime':formattedStartTime,
        'totalPlayers':int.parse(totalPlayerController.text.toString()),
        'rules':tournamentsRules.text.trim(),
        'totalTeams':int.parse(totalTeamController.text.toString()),
      }).then((value){
        isLoading(false);
        Navigator.pop(context);
      }).onError((error, stackTrace){
        isLoading(false);
        print(error);
        print(stackTrace);
        ToastClass.showToastClass(context: context, message: 'Something went wrong');
      });
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