import 'package:cloud_firestore/cloud_firestore.dart';
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


class AddTournamentsController extends GetxController {


  @override
  void onInit() {
    super.onInit();
    organizerName = TextEditingController(text: controller.userName);
    organizerPhoneNumber = TextEditingController(text: controller.phoneNumber);
    location = TextEditingController(text: controller.location);
  }


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    nameController.dispose();
    organizerName.dispose();
    organizerPhoneNumber.dispose();
    location.dispose();
    tournamentType.dispose();
    tournamentFee.dispose();
    startDateController.dispose();
    totalTeamController.dispose();
    areaLevel.dispose();
  }


  var controller = Get.put(ZegoCloudController());
  var nameController = TextEditingController();
  late TextEditingController organizerName ;
  late TextEditingController organizerPhoneNumber ;
  late TextEditingController location;
  var tournamentType = TextEditingController();
  var tournamentFee = TextEditingController();
  var startDateController = TextEditingController(); // Add this controller for the start date
  var startDateTimeController = TextEditingController(); // Add this controller for the start date
  var totalTeamController = TextEditingController();
  var totalPlayerController = TextEditingController();
  var tournamentsRules = TextEditingController();
  var areaLevel = TextEditingController();
  var isLoading = false.obs;
  var selectedDate = Rxn<DateTime>();
  var selectedImage = Rxn<String>();
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

  String getSelectedTournamentType() {
    return "${overTypeList[currentIndexOver.value]} | ${ageLevelList[currentIndexAge.value]} | ${currentIndexArea.value == 2 ? areaLevel.text.trim():areaLevelList[currentIndexArea.value]}";
  }


  selectImage(BuildContext context) async {
    await showModalBottomSheet(
      backgroundColor:cardTextColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30)),
      ),
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            color: loginEnabledButtonColor,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30)),
          ),
          height: MediaQuery.sizeOf(context).height * 0.5,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: loginEnabledButtonColor,
                  ),
                  child: mediumText(title: 'Select Tournament Avatar',color: whiteColor,context: context)),
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

  addTournament({required String userId,required BuildContext context}) async {
    try {
      isLoading(true);
      final String name = nameController.text;
      await fireStore.collection(tournamentsCollection).add({
        'name': name,
        'organizerName': organizerName.text.toString(),
        'tournamentOvers': tournamentType.text.toString(),
        'tournamentFee': tournamentFee.text.toString(),
        'organizerPhoneNumber': organizerPhoneNumber.text.toString(),
        'location': location.text.toString(),
        'startDate': selectedDate.toString(),
        'organizer_UserID': userId,
        'isCompleted': 'false',
        'totalTeams':int.parse(totalTeamController.text.toString()),
        'registerTeams':0,
        'imagePath':selectedImage.toString(),
        'token':userToken,
        'rules':tournamentsRules.text.trim(),
        'startTime':selectedTime.toString(),
        'totalPlayers':int.parse(totalPlayerController.text.toString()),
      }).then((value) => {
        isLoading(false),
        Navigator.pop(context),
      });
    } catch (error) {
      isLoading(false);
      ToastClass.showToastClass(context: context, message: 'Tournament Added Failed $error');
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