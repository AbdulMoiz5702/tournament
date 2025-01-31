import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tournemnt/consts/firebase_consts.dart';
import 'package:tournemnt/consts/images_path.dart';

import '../consts/colors.dart';
import '../reusbale_widget/custom_sizedBox.dart';
import '../reusbale_widget/text_widgets.dart';
import '../reusbale_widget/toast_class.dart';
import 'call_controller.dart';




class AddChallengesController extends GetxController {





  var controller = Get.find<ZegoCloudController>();
  var teamName = TextEditingController();
  late TextEditingController captainName  ;
  late  TextEditingController location ;
  late TextEditingController leaderPhone ;
  var challengeType = TextEditingController();
  var startDateController = TextEditingController();
  var startDateTimeController = TextEditingController(); // Add this controller for the start date
  var areaLevel = TextEditingController();
  var isLoading = false.obs;
  var selectedDate = Rxn<DateTime>();
  var selectedImage = Rxn<String>();
  var selectedTime = TimeOfDay.now().obs;
  var currentIndexOver = (-1).obs;
  var currentIndexAge = (-1).obs;
  var currentIndexArea = (-1).obs;

  @override
  void onInit() {
    super.onInit();
    captainName = TextEditingController(text: controller.userName);
    location = TextEditingController(text: controller.location);
    leaderPhone = TextEditingController(text: controller.phoneNumber);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    captainName.dispose();
    location.dispose();
    leaderPhone.dispose();
    challengeType.dispose();
    startDateController.dispose();
    teamName.dispose();
  }

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


  addChallenge({required BuildContext context ,}) {
    String title = teamName.text;
    String description = captainName.text;
    if (title.isNotEmpty && description.isNotEmpty) {
      isLoading(true);
      final String formattedStartTime = "TimeOfDay(${selectedTime.value.hour.toString().padLeft(2, '0')}:${selectedTime.value.minute.toString().padLeft(2, '0')})";
      fireStore.collection(challengesCollection).add({
        'challengerTeamName': title,
        'teamLeaderName': description,
        'location':location.text.toString(),
        'challengerLeaderPhone':leaderPhone.text.toString(),
        'Over':overTypeList[currentIndexOver.value].toString(),
        'age':ageLevelList[currentIndexAge.value].toString(),
        'area': currentIndexArea.value == 2 ? areaLevel.text.trim():areaLevelList[currentIndexArea.value],
        'isChallengeAccepted':'false',
        'teamCount': 1,
        'challenger':currentUser!.uid,
        'token':userToken,
        'startDate': selectedDate.toString(),
        'startTime':formattedStartTime,
        'imagePath':selectedImage.toString(),
      }).then((value) {
        isLoading(false);
        ToastClass.showToastClass(context: context, message: 'Challenge added successfully');
        Navigator.of(context).pop();
      }).catchError((error) {
        isLoading(false);
        ToastClass.showToastClass(context: context, message: 'Failed to add challenge: $error');
      });
    } else {
      isLoading(false);
      ToastClass.showToastClass(context: context, message: 'Please fill all fields');
    }
  }

  deleteTeam({required BuildContext context, required String teamId, required String challengeId}) async {
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
      ToastClass.showToastClass(context: context, message: 'Failed to delete team: $e');
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
            colorScheme: const ColorScheme.light(
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


  selectImage(BuildContext context) async {
    await showModalBottomSheet(
      backgroundColor:loginEnabledButtonColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30)),
      ),
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.sizeOf(context).height * 0.5,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Sized(height: 0.03,),
              Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(5),
                  decoration: const BoxDecoration(
                    color: loginEnabledButtonColor,
                  ),
                  child: mediumText(title: 'Select Your Avatar',color: whiteColor,context: context)),
              Sized(height: 0.03,),
              Container(
                  color: loginEnabledButtonColor,
                  height: MediaQuery.sizeOf(context).height * 0.35,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: BouncingScrollPhysics(),
                    child: Row(
                      children: List.generate(imagesListOther.length, (index) {
                        return GestureDetector(
                          onTap: (){
                            selectedImage.value = imagesListOther[index];

                            Navigator.pop(context);
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                margin: EdgeInsets.only(right: 10),
                                height: MediaQuery.sizeOf(context).height * 0.15,
                                width: MediaQuery.sizeOf(context).width * 0.3,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: secondaryTextColor,
                                    image: DecorationImage(image: AssetImage(imagesListOther[index]),fit: BoxFit.cover)
                                ),),
                              Sized(height: 0.02,),
                              Container(
                                  margin: EdgeInsets.only(left: 5),
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(7),
                                    color: secondaryTextFieldColor,
                                  ),
                                  child: smallText(title: teamsTypesNameList[index],context: context,color: blueColor,fontWeight: FontWeight.bold)),
                            ],
                          ),
                        );
                      }),
                    ),
                  )
              ),
            ],
          ),
        );
      },
    );
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